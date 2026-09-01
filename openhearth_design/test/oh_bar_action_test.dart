import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

import 'support/package_fonts.dart';

/// The fleet ruling on top bars is "icon plus a short label; rare actions in
/// a worded menu". Reckon, Trellis and StillLife each grew a copy of the
/// widget that does it; `OhBarAction` is the one they share. These tests
/// pin the single collapse rule and prove it keeps the title whole in a
/// real `AppBar` at the fleet's worst case, 320 dp at 3.0x text.
void main() {
  // Real metrics: the bar only fits or not in the fonts people see.
  setUpAll(loadPackageFontsAsConsumerSees);

  Future<void> pumpBar(
    WidgetTester tester, {
    required Size size,
    required double scale,
    required String title,
    required List<Widget> actions,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: OhTheme.light(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
      ),
    ));
  }

  // The bar Trellis's Library carries, the busiest in the fleet: a title,
  // a worded filter, the theme toggle and a worded More menu.
  List<Widget> busyBar({VoidCallback? onFilter}) => [
        OhBarActions(children: [
          OhBarAction(
            icon: Icons.filter_alt_outlined,
            label: 'Filter',
            onPressed: onFilter ?? () {},
          ),
          OhThemeToggle(
            value: OhThemeModePreference.system,
            onChanged: (_) {},
          ),
          OhBarOverflow<String>(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'a', child: Text('Import a book')),
            ],
            onSelected: (_) {},
          ),
        ]),
      ];

  /// The title's text is laid out whole: not ellipsized, not clipped.
  void expectTitleWhole(WidgetTester tester, String title) {
    final paragraph =
        tester.renderObject<RenderParagraph>(find.text(title));
    expect(paragraph.didExceedMaxLines, isFalse,
        reason: 'the title "$title" was ellipsized');
    expect(
      paragraph.getMaxIntrinsicWidth(double.infinity),
      lessThanOrEqualTo(paragraph.size.width + 0.5),
      reason: 'the title "$title" does not fit its box',
    );
  }

  /// Every command in [labels] is named on screen: by its word, or (folded)
  /// by its tooltip. Returns the labels whose word is visible.
  Set<String> wordsOnScreen(WidgetTester tester, Map<String, String> labels) {
    final shown = <String>{};
    labels.forEach((word, tooltip) {
      if (find.text(word).evaluate().isNotEmpty) {
        shown.add(word);
      } else {
        expect(find.byTooltip(tooltip), findsOneWidget,
            reason: '"$word" is neither worded nor in a tooltip');
      }
    });
    return shown;
  }

  const busyLabels = {
    'Filter': 'Filter',
    'Auto': 'Theme: Follow phone',
    'More': 'More',
  };

  group('folding by space', () {
    test('the fallback rule shows words up to and including 1.5x', () {
      expect(OhBarAction.labelMaxScale, 1.5);
      expect(OhBarAction.collapsesAt(TextScaler.noScaling), isFalse);
      expect(OhBarAction.collapsesAt(const TextScaler.linear(1.3)), isFalse);
      expect(OhBarAction.collapsesAt(const TextScaler.linear(1.5)), isFalse);
      expect(OhBarAction.collapsesAt(const TextScaler.linear(1.51)), isTrue);
      expect(OhBarAction.collapsesAt(const TextScaler.linear(3.0)), isTrue);
    });

    for (final scale in [1.0, 1.3, 1.5]) {
      testWidgets('at 360 dp x $scale two worded commands keep their words',
          (tester) async {
        await pumpBar(tester,
            size: const Size(360, 780),
            scale: scale,
            title: 'Library',
            actions: [
              OhBarActions(children: [
                OhBarAction(
                    icon: Icons.filter_alt_outlined,
                    label: 'Filter',
                    onPressed: () {}),
                OhThemeToggle(
                    value: OhThemeModePreference.system, onChanged: (_) {}),
              ]),
            ]);
        expect(find.text('Filter'), findsOneWidget);
        expect(find.text('Auto'), findsOneWidget);
        expect(tester.takeException(), isNull);
        expectTitleWhole(tester, 'Library');
      });
    }

    testWidgets('a lone "Undo" beside "Lilt" keeps its word at 320 dp x 3.0',
        (tester) async {
      await pumpBar(tester,
          size: const Size(320, 640),
          scale: 3.0,
          title: 'Lilt',
          actions: [
            OhBarActions(children: [
              OhBarAction(icon: Icons.undo, label: 'Undo', onPressed: () {}),
            ]),
          ]);
      expect(tester.takeException(), isNull);
      expect(find.text('Undo'), findsOneWidget);
      expectTitleWhole(tester, 'Lilt');
    });

    testWidgets('a busy bar at 360 dp x 1.3 folds the rightmost first and '
        'keeps the title whole', (tester) async {
      await pumpBar(tester,
          size: const Size(360, 780),
          scale: 1.3,
          title: 'Library',
          actions: busyBar());
      expect(tester.takeException(), isNull);
      expectTitleWhole(tester, 'Library');
      final shown = wordsOnScreen(tester, busyLabels);
      expect(shown, contains('Filter'), reason: 'the leftmost folds last');
      expect(shown, isNot(contains('More')), reason: 'the rightmost folds first');
    });

    for (final (size, scale) in const [
      (Size(320, 640), 3.0),
      (Size(360, 780), 3.0),
      (Size(320, 640), 2.0),
    ]) {
      testWidgets('a busy bar at ${size.width.toInt()} dp x $scale keeps the '
          'title whole and every command named', (tester) async {
        await pumpBar(tester,
            size: size, scale: scale, title: 'Library', actions: busyBar());
        expect(tester.takeException(), isNull);
        expectTitleWhole(tester, 'Library');
        final shown = wordsOnScreen(tester, busyLabels);
        // Folding runs right to left: a visible word never sits right of a
        // folded one.
        final order = busyLabels.keys.toList();
        for (var i = 1; i < order.length; i++) {
          if (shown.contains(order[i])) {
            expect(shown, contains(order[i - 1]));
          }
        }
      });
    }

    for (final (size, scale) in const [
      (Size(360, 780), 1.3),
      (Size(320, 640), 3.0),
    ]) {
      testWidgets('a title too long to be whole keeps its floor at '
          '${size.width.toInt()} dp x $scale, folding right to left',
          (tester) async {
        const long = 'A Rather Longer Title Than Any Bar Would Prefer';
        await pumpBar(tester,
            size: size, scale: scale, title: long, actions: busyBar());
        expect(tester.takeException(), isNull);
        final title = tester.getSize(find.text(long)).width;
        expect(title,
            greaterThanOrEqualTo(size.width * OhBarActions.minTitleShare - 1),
            reason: 'the title keeps its floor');
        final shown = wordsOnScreen(tester, busyLabels);
        final order = busyLabels.keys.toList();
        for (var i = 1; i < order.length; i++) {
          if (shown.contains(order[i])) expect(shown, contains(order[i - 1]));
        }
        if (scale < 1.5) {
          expect(shown, isNotEmpty,
              reason: 'a long title does not fold every word at 1.3x');
        }
      });
    }

    testWidgets('a short-titled bar at 320 dp x 3.0 keeps its title whole',
        (tester) async {
      await pumpBar(tester,
          size: const Size(320, 640),
          scale: 3.0,
          title: 'Reckon',
          actions: [
            OhBarActions(children: [
              OhBarAction(
                  icon: Icons.groups_outlined,
                  label: 'Group vote',
                  onPressed: () {}),
              OhThemeToggle(
                  value: OhThemeModePreference.system, onChanged: (_) {}),
            ]),
          ]);
      expect(tester.takeException(), isNull);
      expectTitleWhole(tester, 'Reckon');
    });

    testWidgets('a back button counts against the room', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: nav,
        theme: OhTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(3.0)),
          child: child!,
        ),
        home: const Scaffold(body: SizedBox()),
      ));
      nav.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Settings'), actions: [
            OhBarActions(children: [
              OhThemeToggle(
                  value: OhThemeModePreference.system, onChanged: (_) {}),
            ]),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(BackButton), findsOneWidget);
      expectTitleWhole(tester, 'Settings');
    });

    testWidgets('a title that is not a plain Text falls back to the fixed '
        'rule', (tester) async {
      for (final (scale, worded) in const [(1.3, true), (3.0, false)]) {
        tester.view.physicalSize = const Size(360, 780);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          theme: OhTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const TextField(),
              actions: [
                OhBarActions(children: [
                  OhBarAction(
                      icon: Icons.close, label: 'Close', onPressed: () {}),
                ]),
              ],
            ),
          ),
        ));
        await tester.pump();
        expect(find.text('Close'), worded ? findsOneWidget : findsNothing,
            reason: 'at ${scale}x');
      }
    });

    testWidgets('a command outside a row follows the fixed rule',
        (tester) async {
      for (final (scale, worded) in const [(1.5, true), (3.0, false)]) {
        await pumpBar(tester,
            size: const Size(360, 780),
            scale: scale,
            title: 'Lilt',
            actions: [
              OhBarAction(icon: Icons.undo, label: 'Undo', onPressed: () {}),
            ]);
        expect(find.text('Undo'), worded ? findsOneWidget : findsNothing,
            reason: 'at ${scale}x');
      }
    });

    testWidgets('the hidden face is not focusable', (tester) async {
      await pumpBar(tester,
          size: const Size(320, 640),
          scale: 3.0,
          title: 'Library',
          actions: busyBar());
      await tester.pumpAndSettle();
      // Tab through the bar: every stop is a shown face.
      final stops = <Rect>{};
      for (var i = 0; i < 8; i++) {
        FocusManager.instance.primaryFocus?.nextFocus();
        await tester.pump();
        final ctx = FocusManager.instance.primaryFocus?.context;
        if (ctx == null) continue;
        final box = ctx.findRenderObject() as RenderBox?;
        if (box == null || !box.attached || !box.hasSize) continue;
        stops.add(box.localToGlobal(Offset.zero) & box.size);
      }
      // Every stop is a shown face: at 320 x 3.0 the busy bar is all
      // folded (48 dp faces), so no stop can be a hidden worded face.
      expect(stops, isNotEmpty);
      for (final r in stops) {
        expect(r.width, lessThan(60),
            reason: 'a focus stop landed on a hidden worded face: $r');
      }
    });

    testWidgets('a theme toggle outside a bar row keeps its word at 3.0',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: OhTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(3.0)),
          child: child!,
        ),
        home: Scaffold(
          body: Center(
            child: OhThemeToggle(
                value: OhThemeModePreference.system, onChanged: (_) {}),
          ),
        ),
      ));
      expect(find.text('Auto'), findsOneWidget);
    });
  });

  group('the one name', () {
    for (final scale in [1.0, 3.0]) {
      testWidgets('reads as one button named "Refresh" at ${scale}x',
          (tester) async {
        final handle = tester.ensureSemantics();
        var taps = 0;
        await pumpBar(tester,
            size: const Size(360, 780),
            scale: scale,
            title: 'Result',
            actions: [
              OhBarAction(
                  icon: Icons.refresh,
                  label: 'Refresh',
                  onPressed: () => taps++),
            ]);
        expect(
          tester.getSemantics(find.byType(OhBarAction)),
          matchesSemantics(
            label: 'Refresh',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );
        // The screen reader's tap reaches the command.
        tester.semantics.tap(find.semantics.byLabel('Refresh'));
        await tester.pump();
        expect(taps, 1);
        handle.dispose();
      });
    }

    testWidgets('semanticLabel names it more fully than the short word',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpBar(tester,
          size: const Size(360, 780),
          scale: 1.0,
          title: 'Result',
          actions: [
            OhBarAction(
              icon: Icons.refresh,
              label: 'Refresh',
              semanticLabel: 'Refresh the vote',
              onPressed: () {},
            ),
          ]);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.bySemanticsLabel('Refresh the vote'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('a disabled command says so', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpBar(tester,
          size: const Size(360, 780),
          scale: 1.0,
          title: 'Result',
          actions: const [
            OhBarAction(icon: Icons.refresh, label: 'Refresh', onPressed: null),
          ]);
      expect(
        tester.getSemantics(find.byType(OhBarAction)),
        matchesSemantics(
          label: 'Refresh',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('the More menu is one button named "More" that opens',
        (tester) async {
      final handle = tester.ensureSemantics();
      String? picked;
      await pumpBar(tester,
          size: const Size(360, 780),
          scale: 1.0,
          title: 'Inbox',
          actions: [
            OhBarOverflow<String>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'import', child: Text('Import feeds')),
              ],
              onSelected: (v) => picked = v,
            ),
          ]);
      expect(find.bySemanticsLabel('More'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(OhBarOverflow<String>)),
        matchesSemantics(
          label: 'More',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import feeds'));
      await tester.pumpAndSettle();
      expect(picked, 'import');
      handle.dispose();
    });
  });

  testWidgets('a disabled command dims its glyph with its word',
      (tester) async {
    await pumpBar(tester,
        size: const Size(360, 780),
        scale: 1.0,
        title: 'Match',
        actions: const [
          OhBarAction(icon: Icons.undo, label: 'Undo', onPressed: null),
        ]);
    final word = tester.widget<RichText>(find.descendant(
        of: find.byType(OhBarAction), matching: find.byType(RichText)).last);
    final glyph = tester.widget<RichText>(find.descendant(
        of: find.byIcon(Icons.undo), matching: find.byType(RichText)));
    expect(glyph.text.style!.color, word.text.style!.color);
  });

  group('tap target', () {
    for (final scale in [1.0, 3.0]) {
      testWidgets('every bar command is at least 48 dp at ${scale}x',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpBar(tester,
            size: const Size(360, 780),
            scale: scale,
            title: 'Library',
            actions: busyBar());
        for (final type in [OhBarAction, OhBarOverflow<String>]) {
          final size = tester.getSize(find.byType(type));
          expect(size.width, greaterThanOrEqualTo(48), reason: '$type');
          expect(size.height, greaterThanOrEqualTo(48), reason: '$type');
        }
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });
    }
  });

  testWidgets('a tap runs the command in both modes', (tester) async {
    var taps = 0;
    for (final scale in [1.0, 3.0]) {
      await pumpBar(tester,
          size: const Size(360, 780),
          scale: scale,
          title: 'Library',
          actions: busyBar(onFilter: () => taps++));
      await tester.tap(find.byType(OhBarAction));
      await tester.pump();
    }
    expect(taps, 2);
  });

  testWidgets('OhBarActions caps other bar words at 2x', (tester) async {
    await pumpBar(tester,
        size: const Size(360, 780),
        scale: 3.0,
        title: 'T',
        actions: [
          OhBarActions(children: [
            Builder(
              builder: (context) => Text(
                  'x${MediaQuery.textScalerOf(context).scale(10)}',
                  key: const Key('probe')),
            ),
          ]),
        ]);
    expect(find.text('x20.0'), findsOneWidget);
  });
}
