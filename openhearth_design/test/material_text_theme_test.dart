// OhTypography.materialTextTheme is the Material-slot TextTheme the four
// habit-lineage apps (Sundial / Furrow / Glass / Bulwark) build their own
// ThemeData from. Since 0.7.0 each slot sits on OhTypography.ladder (the
// nearest step to its old stock-Material size) and the headlines ask for
// Lora w700 instead of the unbundled w600.
//
// These are WHOLE-STYLE equality assertions: `TextStyle.==` compares every
// field (inherit, color, fontStyle, letterSpacing, wordSpacing, height,
// decoration, shadows, …), so the block may still set only
// family/size/weight — the apps' line metrics depend on that.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

void main() {
  const t = OhTypography.materialTextTheme;

  // The block, restated inline. Each entry sets ONLY
  // fontFamily/fontSize(/fontWeight) — every other TextStyle field must be
  // at its default, which whole-style equality enforces.
  final expected = <String, (TextStyle?, TextStyle)>{
    'displayLarge': (
      t.displayLarge,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 57, fontWeight: FontWeight.w700),
    ),
    'displayMedium': (
      t.displayMedium,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 48, fontWeight: FontWeight.w700),
    ),
    'displaySmall': (
      t.displaySmall,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 40, fontWeight: FontWeight.w700),
    ),
    'headlineLarge': (
      t.headlineLarge,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 33, fontWeight: FontWeight.w700),
    ),
    'headlineMedium': (
      t.headlineMedium,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 28, fontWeight: FontWeight.w700),
    ),
    'headlineSmall': (
      t.headlineSmall,
      const TextStyle(fontFamily: 'Lora', package: 'openhearth_design', fontSize: 23, fontWeight: FontWeight.w700),
    ),
    'titleLarge': (
      t.titleLarge,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 19, fontWeight: FontWeight.w700),
    ),
    'titleMedium': (
      t.titleMedium,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 16, fontWeight: FontWeight.w600),
    ),
    'titleSmall': (
      t.titleSmall,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 13, fontWeight: FontWeight.w700),
    ),
    'bodyLarge': (
      t.bodyLarge,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 19),
    ),
    'bodyMedium': (
      t.bodyMedium,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 16),
    ),
    'bodySmall': (
      t.bodySmall,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 13),
    ),
    'labelLarge': (
      t.labelLarge,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 16, fontWeight: FontWeight.w600),
    ),
    'labelMedium': (
      t.labelMedium,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 13, fontWeight: FontWeight.w600),
    ),
    'labelSmall': (
      t.labelSmall,
      const TextStyle(fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 13, fontWeight: FontWeight.w500),
    ),
  };

  group('OhTypography.materialTextTheme — the habit-lineage Material slots on the one ladder', () {
    for (final MapEntry(key: name, value: (style, want)) in expected.entries) {
      test('$name is exactly the 0.7.0 ladder style', () {
        expect(style, isNotNull, reason: '$name must be present');
        // Whole-style equality: TextStyle.== compares every field, so this
        // catches drift in fontStyle, wordSpacing, decoration, inherit, …
        // — not just the three properties the apps' block sets.
        expect(style, want, reason: '$name must match the ladder block exactly');
      });
    }
  });
}
