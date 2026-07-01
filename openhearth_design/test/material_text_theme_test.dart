// Expectations in this file are derived from the byte-identical
// `static const TextTheme _textTheme` block in the four habit-lineage apps
// (Sundial / Furrow / Glass / Bulwark — lib/shared/theme/app_theme.dart).
// OhTypography.materialTextTheme MUST reproduce that block exactly so the
// apps can delete their copies with zero visual change.
//
// These are WHOLE-STYLE equality assertions: `TextStyle.==` compares every
// field (inherit, color, fontStyle, letterSpacing, wordSpacing, height,
// decoration, shadows, …), so ANY property drift from the apps' block —
// not just family/size/weight — fails the suite. That is the point: the
// byte-equality constraint means "no other property may ever be set".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

void main() {
  const t = OhTypography.materialTextTheme;

  // The apps' block, restated inline. Each entry sets ONLY
  // fontFamily/fontSize(/fontWeight) — every other TextStyle field must be
  // at its default, which whole-style equality enforces.
  final expected = <String, (TextStyle?, TextStyle)>{
    'displayLarge': (
      t.displayLarge,
      const TextStyle(fontFamily: 'Lora', fontSize: 57, fontWeight: FontWeight.w700),
    ),
    'displayMedium': (
      t.displayMedium,
      const TextStyle(fontFamily: 'Lora', fontSize: 45, fontWeight: FontWeight.w700),
    ),
    'displaySmall': (
      t.displaySmall,
      const TextStyle(fontFamily: 'Lora', fontSize: 36, fontWeight: FontWeight.w700),
    ),
    'headlineLarge': (
      t.headlineLarge,
      const TextStyle(fontFamily: 'Lora', fontSize: 32, fontWeight: FontWeight.w700),
    ),
    'headlineMedium': (
      t.headlineMedium,
      const TextStyle(fontFamily: 'Lora', fontSize: 28, fontWeight: FontWeight.w600),
    ),
    'headlineSmall': (
      t.headlineSmall,
      const TextStyle(fontFamily: 'Lora', fontSize: 24, fontWeight: FontWeight.w600),
    ),
    'titleLarge': (
      t.titleLarge,
      const TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.w700),
    ),
    'titleMedium': (
      t.titleMedium,
      const TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600),
    ),
    'titleSmall': (
      t.titleSmall,
      const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w600),
    ),
    'bodyLarge': (
      t.bodyLarge,
      const TextStyle(fontFamily: 'Nunito', fontSize: 16),
    ),
    'bodyMedium': (
      t.bodyMedium,
      const TextStyle(fontFamily: 'Nunito', fontSize: 14),
    ),
    'bodySmall': (
      t.bodySmall,
      const TextStyle(fontFamily: 'Nunito', fontSize: 12),
    ),
    'labelLarge': (
      t.labelLarge,
      const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w600),
    ),
    'labelMedium': (
      t.labelMedium,
      const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500),
    ),
    'labelSmall': (
      t.labelSmall,
      const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w500),
    ),
  };

  group('OhTypography.materialTextTheme — the habit-lineage Material ladder', () {
    for (final MapEntry(key: name, value: (style, want)) in expected.entries) {
      test('$name is byte-equal to the apps\' pre-adoption style', () {
        expect(style, isNotNull, reason: '$name must be present');
        // Whole-style equality: TextStyle.== compares every field, so this
        // catches drift in fontStyle, wordSpacing, decoration, inherit, …
        // — not just the three properties the apps' block sets.
        expect(style, want, reason: '$name must match the apps\' block exactly');
      });
    }
  });
}
