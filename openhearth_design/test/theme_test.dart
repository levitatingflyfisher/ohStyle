// packages/openhearth_design/test/theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Since dropping google_fonts, styles resolve from plain family names.
/// Tests no longer need a zone guard around font lookups.
void _test(String name, void Function() body) {
  test(name, body);
}

void main() {

  group('OhTypography', () {
    _test('display() has fontSize 48', () {
      expect(OhTypography.display().fontSize, 48.0);
    });
    _test('body() has fontSize 16', () {
      expect(OhTypography.body().fontSize, 16.0);
    });
    _test('labelSm() has fontSize 12', () {
      expect(OhTypography.labelSm().fontSize, 12.0);
    });
    _test('color override is applied', () {
      final style = OhTypography.body(color: OhColors.hearth500);
      expect(style.color, OhColors.hearth500);
    });
    _test('display() fontWeight is w700', () {
      expect(OhTypography.display().fontWeight, FontWeight.w700);
    });
    _test('button() fontWeight is w600', () {
      expect(OhTypography.button().fontWeight, FontWeight.w600);
    });
  });

  group('OhTheme.light', () {
    _test('constructs without error', () {
      expect(() => OhTheme.light(), returnsNormally);
    });
    _test('default primary is hearth500', () {
      expect(OhTheme.light().colorScheme.primary, OhColors.hearth500);
    });
    _test('appAccent overrides primary', () {
      expect(
        OhTheme.light(appAccent: OhColors.sage500).colorScheme.primary,
        OhColors.sage500,
      );
    });
    _test('scaffold background is linen50', () {
      expect(OhTheme.light().scaffoldBackgroundColor, OhColors.linen50);
    });
    _test('surface is linen100', () {
      expect(OhTheme.light().colorScheme.surface, OhColors.linen100);
    });
    _test('onSurface is linen900', () {
      expect(OhTheme.light().colorScheme.onSurface, OhColors.linen900);
    });
    _test('textTheme.displayLarge fontSize is 48', () {
      expect(OhTheme.light().textTheme.displayLarge?.fontSize, 48.0);
    });
    _test('textTheme.bodyMedium color is linen900 in light', () {
      expect(OhTheme.light().textTheme.bodyMedium?.color, OhColors.linen900);
    });
    _test('has textButtonTheme with primary foreground', () {
      final theme = OhTheme.light();
      final style = theme.textButtonTheme.style!;
      final fg = style.foregroundColor?.resolve({});
      expect(fg, OhColors.hearth500);
    });
    _test('appAccent flows through to textButtonTheme', () {
      final theme = OhTheme.light(appAccent: OhColors.sage500);
      final style = theme.textButtonTheme.style!;
      final fg = style.foregroundColor?.resolve({});
      expect(fg, OhColors.sage500);
    });
    _test('has inputDecorationTheme with linen100 fill', () {
      final theme = OhTheme.light();
      expect(theme.inputDecorationTheme.fillColor, OhColors.linen100);
      expect(theme.inputDecorationTheme.filled, isTrue);
    });
  });

  group('OhTheme.hearthDark', () {
    _test('constructs without error', () {
      expect(() => OhTheme.hearthDark(), returnsNormally);
    });
    _test('default primary is hearth400', () {
      expect(OhTheme.hearthDark().colorScheme.primary, OhColors.hearth400);
    });
    _test('appAccent overrides primary', () {
      expect(
        OhTheme.hearthDark(appAccent: OhColors.sage500).colorScheme.primary,
        OhColors.sage500,
      );
    });
    _test('scaffold background is darkSurfaceBase (warm brown-black)', () {
      expect(OhTheme.hearthDark().scaffoldBackgroundColor,
          OhColors.darkSurfaceBase);
    });
    _test('surface is darkSurfaceCard', () {
      expect(OhTheme.hearthDark().colorScheme.surface,
          OhColors.darkSurfaceCard);
    });
    _test('textTheme.bodyMedium color is linen100', () {
      expect(OhTheme.hearthDark().textTheme.bodyMedium?.color,
          OhColors.linen100);
    });
    _test('has textButtonTheme with primary foreground', () {
      final theme = OhTheme.hearthDark();
      final style = theme.textButtonTheme.style!;
      final fg = style.foregroundColor?.resolve({});
      expect(fg, OhColors.hearth400);
    });
    _test('appAccent flows through to textButtonTheme', () {
      final theme = OhTheme.hearthDark(appAccent: OhColors.sage500);
      final style = theme.textButtonTheme.style!;
      final fg = style.foregroundColor?.resolve({});
      expect(fg, OhColors.sage500);
    });
    _test('has inputDecorationTheme with darkSurfaceCard fill', () {
      final theme = OhTheme.hearthDark();
      expect(theme.inputDecorationTheme.fillColor, OhColors.darkSurfaceCard);
      expect(theme.inputDecorationTheme.filled, isTrue);
    });
  });

  group('OhTheme.night', () {
    _test('constructs without error', () {
      expect(() => OhTheme.night(), returnsNormally);
    });
    _test('default primary is sage400 (softer than hearth for long reading)',
        () {
      expect(OhTheme.night().colorScheme.primary, OhColors.sage400);
    });
    _test('appAccent overrides primary', () {
      expect(
        OhTheme.night(appAccent: OhColors.hearth400).colorScheme.primary,
        OhColors.hearth400,
      );
    });
    _test('scaffold is neutral near-black, not hearth brown', () {
      expect(OhTheme.night().scaffoldBackgroundColor,
          OhColors.nightSurfaceBase);
    });
    _test('surface is nightSurfaceCard', () {
      expect(OhTheme.night().colorScheme.surface, OhColors.nightSurfaceCard);
    });
    _test('onSurface uses neutral nightTextPrimary, not linen', () {
      expect(OhTheme.night().colorScheme.onSurface,
          OhColors.nightTextPrimary);
    });
    _test('outline is nightBorder', () {
      expect(OhTheme.night().colorScheme.outline, OhColors.nightBorder);
    });
    _test('bodyMedium text color is nightTextPrimary', () {
      expect(OhTheme.night().textTheme.bodyMedium?.color,
          OhColors.nightTextPrimary);
    });
  });

  group('OhTheme.colorsOf', () {
    testWidgets('returns colorScheme from context', (tester) async {
      late ColorScheme captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: OhTheme.light(),
          home: Builder(builder: (ctx) {
            captured = OhTheme.colorsOf(ctx);
            return const SizedBox();
          }),
        ),
      );
      expect(captured.primary, OhColors.hearth500);
    });
  });
}
