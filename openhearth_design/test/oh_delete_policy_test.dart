import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Operator ruling (2026-09-26): an easy gesture (a swipe) asks for
/// confirmation; a deliberate delete gets Undo instead, and that Undo never
/// expires on a timer.
void main() {
  Future<void> pumpHost(
    WidgetTester tester,
    Widget body, {
    ThemeData? theme,
    Size size = const Size(400, 800),
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? OhTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(body: body),
        ),
      ),
    );
  }

  group('showOhConfirm', () {
    Future<Future<bool>> open(
      WidgetTester tester, {
      bool destructive = false,
      ThemeData? theme,
      String confirmLabel = 'Delete 3 items',
    }) async {
      late Future<bool> result;
      await pumpHost(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => result = showOhConfirm(
              context,
              title: 'Delete 3 items?',
              message: 'They move to Recently deleted.',
              confirmLabel: confirmLabel,
              destructive: destructive,
            ),
            child: const Text('open'),
          ),
        ),
        theme: theme,
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('confirm returns true', (tester) async {
      final result = await open(tester);
      await tester.tap(find.text('Delete 3 items'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);
    });

    testWidgets('cancel returns false', (tester) async {
      final result = await open(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });

    testWidgets('dismissing the barrier returns false', (tester) async {
      final result = await open(tester);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });

    testWidgets('confirm label names the act (asserts on generic verbs)',
        (tester) async {
      await pumpHost(tester, Builder(builder: (context) {
        return TextButton(
          onPressed: () => showOhConfirm(context,
              title: 'Delete this entry?', confirmLabel: 'OK'),
          child: const Text('open'),
        );
      }));
      await tester.tap(find.text('open'));
      expect(tester.takeException(), isA<AssertionError>());
    });

    for (final entry in <String, ThemeData Function()>{
      'light': OhTheme.light,
      'hearthDark': OhTheme.hearthDark,
      'night': OhTheme.night,
    }.entries) {
      testWidgets('neutral by default under ${entry.key}', (tester) async {
        final theme = entry.value();
        await open(tester, theme: theme);
        final button = tester.widget<FilledButton>(find.bySubtype<FilledButton>());
        final bg = button.style?.backgroundColor?.resolve({});
        expect(bg, isNot(theme.colorScheme.error));
      });

      testWidgets('danger styling only when destructive under ${entry.key}',
          (tester) async {
        final theme = entry.value();
        await open(tester, destructive: true, theme: theme);
        final button = tester.widget<FilledButton>(find.bySubtype<FilledButton>());
        expect(button.style?.backgroundColor?.resolve({}),
            theme.colorScheme.error);
        expect(button.style?.foregroundColor?.resolve({}),
            theme.colorScheme.onError);
      });

      // Colour language rule 1: urgency is hue + icon + word, so a
      // destructive confirm still reads as dangerous in greyscale.
      testWidgets('destructive confirm carries the urgency icon under '
          '${entry.key}', (tester) async {
        await open(tester, destructive: true, theme: entry.value());
        expect(
          find.descendant(
            of: find.bySubtype<FilledButton>(),
            matching: find.byIcon(Icons.report_outlined),
          ),
          findsOneWidget,
        );
        expect(find.text('Delete 3 items'), findsOneWidget);
      });

      testWidgets('a neutral confirm has no urgency icon under ${entry.key}',
          (tester) async {
        await open(tester, theme: entry.value());
        expect(find.byIcon(Icons.report_outlined), findsNothing);
      });
    }

    testWidgets('confirmColor overrides the danger colour (palette laws)',
        (tester) async {
      const clay = Color(0xFFB5714B);
      await pumpHost(tester, Builder(builder: (context) {
        return TextButton(
          onPressed: () => showOhConfirm(context,
              title: 'Delete it?',
              confirmLabel: 'Delete recipe',
              destructive: true,
              confirmColor: clay),
          child: const Text('open'),
        );
      }));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(find.bySubtype<FilledButton>());
      expect(button.style?.backgroundColor?.resolve({}), clay);
    });
  });

  group('OhUndoController', () {
    test('show exposes the pending entry; undo restores and clears', () async {
      final c = OhUndoController();
      var restored = 0;
      c.show(message: 'Deleted "Soup"', onUndo: () async => restored++);
      expect(c.pending?.message, 'Deleted "Soup"');
      await c.undo();
      expect(restored, 1);
      expect(c.pending, isNull);
    });

    test('a second delete commits the first (the next action)', () async {
      final c = OhUndoController();
      final committed = <String>[];
      c.show(
          message: 'a',
          onUndo: () async {},
          onCommit: () async => committed.add('a'));
      c.show(
          message: 'b',
          onUndo: () async {},
          onCommit: () async => committed.add('b'));
      expect(committed, ['a']);
      expect(c.pending?.message, 'b');
    });

    test('dismiss commits without undoing', () async {
      final c = OhUndoController();
      var undone = 0, committed = 0;
      c.show(
          message: 'x',
          onUndo: () async => undone++,
          onCommit: () async => committed++);
      await c.dismiss();
      expect(undone, 0);
      expect(committed, 1);
      expect(c.pending, isNull);
    });

    test('undo does not also commit', () async {
      final c = OhUndoController();
      var committed = 0;
      c.show(
          message: 'x',
          onUndo: () async {},
          onCommit: () async => committed++);
      await c.undo();
      await c.dismiss();
      expect(committed, 0);
    });
  });

  group('OhUndoBar', () {
    testWidgets('renders nothing when nothing is pending', (tester) async {
      final c = OhUndoController();
      await pumpHost(tester, OhUndoBar(controller: c));
      expect(find.text('Undo'), findsNothing);
    });

    testWidgets('never expires: still there after an hour', (tester) async {
      final c = OhUndoController();
      await pumpHost(tester, OhUndoBar(controller: c));
      c.show(message: 'Deleted 3 items', onUndo: () async {});
      await tester.pump();
      expect(find.text('Deleted 3 items'), findsOneWidget);
      await tester.pump(const Duration(hours: 1));
      expect(find.text('Deleted 3 items'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('Undo restores and hides the bar', (tester) async {
      final c = OhUndoController();
      var restored = 0;
      await pumpHost(tester, OhUndoBar(controller: c));
      c.show(message: 'Deleted', onUndo: () async => restored++);
      await tester.pump();
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(restored, 1);
      expect(find.text('Undo'), findsNothing);
    });

    testWidgets('close dismisses and commits', (tester) async {
      final c = OhUndoController();
      var committed = 0;
      await pumpHost(tester, OhUndoBar(controller: c));
      c.show(
          message: 'Deleted',
          onUndo: () async {},
          onCommit: () async => committed++);
      await tester.pump();
      await tester.tap(find.byTooltip('Dismiss'));
      await tester.pumpAndSettle();
      expect(committed, 1);
      expect(find.text('Deleted'), findsNothing);
    });

    for (final entry in <String, ThemeData Function()>{
      'light': OhTheme.light,
      'hearthDark': OhTheme.hearthDark,
      'night': OhTheme.night,
    }.entries) {
      testWidgets('close glyph is legible on the bar under ${entry.key}',
          (tester) async {
        final theme = entry.value();
        final c = OhUndoController();
        await pumpHost(tester, OhUndoBar(controller: c), theme: theme);
        c.show(message: 'Deleted', onUndo: () async {});
        await tester.pump();
        // OhTheme's ambient iconTheme is primary; the glyph must take the
        // bar's inverse foreground instead.
        final ctx = tester.element(find.byIcon(Icons.close));
        expect(IconTheme.of(ctx).color, theme.colorScheme.onInverseSurface);
      });
    }

    testWidgets('Undo is at least 48dp tall', (tester) async {
      final c = OhUndoController();
      await pumpHost(tester, OhUndoBar(controller: c));
      c.show(message: 'Deleted', onUndo: () async {});
      await tester.pump();
      final size = tester.getSize(find.widgetWithText(TextButton, 'Undo'));
      expect(size.height, greaterThanOrEqualTo(48));
    });

    testWidgets('navigating away commits exactly once, without throwing',
        (tester) async {
      final c = OhUndoController();
      var committed = 0;
      final navKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navKey,
        theme: OhTheme.light(),
        home: const Scaffold(body: Text('home')),
      ));
      navKey.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(body: OhUndoBar(controller: c)),
      ));
      await tester.pumpAndSettle();
      c.show(
          message: 'Deleted',
          onUndo: () async {},
          onCommit: () async => committed++);
      await tester.pump();
      expect(find.text('Deleted'), findsOneWidget);

      navKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(committed, 1);
      expect(c.pending, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('survives 320dp at 2.0 text scale', (tester) async {
      final c = OhUndoController();
      await pumpHost(
        tester,
        Align(
          alignment: Alignment.bottomCenter,
          child: OhUndoBar(controller: c),
        ),
        size: const Size(320, 640),
        textScale: 2.0,
      );
      c.show(
          message: 'Deleted "Grandma\'s Sunday roast with all the trimmings"',
          onUndo: () async {});
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('Undo'), findsOneWidget);
    });
  });
}
