// packages/openhearth_design/test/oh_icon_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Regression coverage for the filled-icon-button collision documented at
/// `theme.dart`'s `iconTheme:` line: `OhTheme` sets an app-wide
/// `ThemeData.iconTheme.color = primary`. Flutter 3.38.7's
/// `IconButtonTheme.resolve` applies that ambient color ABOVE
/// `IconButton.filled`'s own `defaultStyleOf` (which would otherwise pick
/// `onPrimary`), so an unstyled `IconButton.filled` paints its glyph in
/// `primary` — the same color it just filled its own background with. The
/// glyph is invisible. `OhIconButton` pins the correct foreground at the
/// widget level, the highest-precedence style layer, to fix this.
void main() {
  // Every public OhTheme constructor, per `theme.dart`.
  final themes = <String, ThemeData Function()>{
    'light': OhTheme.light,
    'hearthDark': OhTheme.hearthDark,
    'night': OhTheme.night,
  };

  Color? resolvedIconColor(WidgetTester tester, Finder wrapperFinder) {
    final ctx = tester.element(
      find.descendant(of: wrapperFinder, matching: find.byType(Icon)),
    );
    return IconTheme.of(ctx).color;
  }

  Future<void> pump(
    WidgetTester tester,
    ThemeData theme,
    Widget child,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  for (final entry in themes.entries) {
    final themeName = entry.key;
    final themeBuilder = entry.value;

    group('OhIconButton under OhTheme.$themeName()', () {
      testWidgets('filled resolves to onPrimary, not primary', (tester) async {
        final theme = themeBuilder();
        await pump(
          tester,
          theme,
          OhIconButton.filled(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        );

        final resolved = resolvedIconColor(tester, find.byType(OhIconButton));

        expect(resolved, theme.colorScheme.onPrimary);
        expect(resolved, isNot(theme.colorScheme.primary));
      });

      testWidgets('filledTonal resolves to onSecondaryContainer, not primary',
          (tester) async {
        final theme = themeBuilder();
        await pump(
          tester,
          theme,
          OhIconButton.filledTonal(
            icon: const Icon(Icons.pause),
            onPressed: () {},
          ),
        );

        final resolved = resolvedIconColor(tester, find.byType(OhIconButton));

        expect(resolved, theme.colorScheme.onSecondaryContainer);
        expect(resolved, isNot(theme.colorScheme.primary));
      });

      // Collision witness: this is what OhIconButton exists to fix. A bare
      // Flutter IconButton.filled, unstyled, under our theme, paints its
      // glyph in `primary` — the exact color of its own fill, i.e.
      // invisible. If this test starts failing, either Flutter's
      // IconButtonTheme resolution order changed or OhTheme stopped
      // setting the app-wide iconTheme; either way, re-read the comment at
      // theme.dart's `iconTheme:` line and reconsider whether
      // OhIconButton is still needed before touching this assertion.
      testWidgets(
          'collision witness: a bare IconButton.filled resolves to '
          'primary (its own fill color) under this theme', (tester) async {
        final theme = themeBuilder();
        await pump(
          tester,
          theme,
          IconButton.filled(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        );

        final resolved = resolvedIconColor(tester, find.byType(IconButton));

        expect(resolved, theme.colorScheme.primary);
      });
    });
  }

  group('OhIconButton passthrough', () {
    // Both constructors delegate through separate switch arms in `build`
    // that re-list every parameter by hand — a copy-paste site. Running
    // the same assertions under both variants is what would actually
    // catch a param dropped from just one arm (e.g. filledTonal missing
    // `constraints`); a filled-only test would stay green through that.
    final variants = <String,
        Widget Function({
      required Widget icon,
      required VoidCallback? onPressed,
      String? tooltip,
      double? iconSize,
      BoxConstraints? constraints,
      EdgeInsetsGeometry? padding,
      bool autofocus,
      FocusNode? focusNode,
      ButtonStyle? style,
    })>{
      'filled': OhIconButton.filled,
      'filledTonal': OhIconButton.filledTonal,
    };

    for (final entry in variants.entries) {
      final variantName = entry.key;
      final build = entry.value;

      testWidgets(
          '$variantName: constraints, iconSize and tooltip reach the '
          'inner IconButton', (tester) async {
        const constraints = BoxConstraints.tightFor(width: 64, height: 64);
        await pump(
          tester,
          OhTheme.light(),
          build(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
            tooltip: 'Play',
            iconSize: 36,
            constraints: constraints,
          ),
        );

        final inner = tester.widget<IconButton>(find.byType(IconButton));

        expect(inner.constraints, constraints);
        expect(inner.iconSize, 36);
        expect(inner.tooltip, 'Play');
      });

      testWidgets(
          '$variantName: padding, autofocus and focusNode reach the '
          'inner IconButton', (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        const padding = EdgeInsets.all(20);

        await pump(
          tester,
          OhTheme.light(),
          build(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
            padding: padding,
            autofocus: true,
            focusNode: focusNode,
          ),
        );

        final inner = tester.widget<IconButton>(find.byType(IconButton));

        expect(inner.padding, padding);
        expect(inner.autofocus, isTrue);
        expect(inner.focusNode, focusNode);
      });
    }
  });

  group('OhIconButton disabled state', () {
    // onPressed is nullable — "disabled buttons are real call sites" per
    // spec. The concern: IconButton.styleFrom(foregroundColor: x) sets no
    // disabledForegroundColor, and ButtonStyleButton resolves widget style
    // before theme/default per-property, not as an all-or-nothing swap —
    // so it's worth confirming the disabled glyph doesn't fall through to
    // the ambient iconTheme (primary), which is exactly the collision this
    // widget exists to avoid.
    testWidgets(
        'filled: disabled glyph does not fall back to the ambient '
        'primary iconTheme', (tester) async {
      final theme = OhTheme.light();
      await pump(
        tester,
        theme,
        const OhIconButton.filled(
          icon: Icon(Icons.play_arrow),
          onPressed: null,
        ),
      );

      final resolved = resolvedIconColor(tester, find.byType(OhIconButton));

      expect(resolved, isNot(theme.colorScheme.primary));
    });
  });

  group('OhIconButton caller-supplied style', () {
    testWidgets('caller style wins over the built-in foreground',
        (tester) async {
      const callerColor = Colors.purple;
      await pump(
        tester,
        OhTheme.light(),
        OhIconButton.filled(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {},
          style: IconButton.styleFrom(foregroundColor: callerColor),
        ),
      );

      final resolved = resolvedIconColor(tester, find.byType(OhIconButton));

      expect(resolved, callerColor);
      expect(resolved, isNot(OhTheme.light().colorScheme.onPrimary));
    });
  });
}
