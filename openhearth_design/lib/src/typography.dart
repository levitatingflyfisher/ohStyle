import 'package:flutter/material.dart';

/// OpenHearth typography roles.
///
/// **Fonts are resolved from the consuming app's bundled assets** — this
/// package deliberately does not fetch from the network. Every consumer
/// must declare `Lora` and `Nunito` (and `JetBrains Mono` if [code] is
/// used) in its own `pubspec.yaml` under `flutter.fonts`. See the package
/// README for the exact snippet. Privacy posture: zero runtime fetches,
/// zero Google CDN traffic, works offline by construction.
///
/// Font family names below are exact strings Flutter will look up in the
/// app's asset manifest. Do not change them unless you also update every
/// consumer's pubspec.
abstract final class OhTypography {
  static const _heading = 'Lora';
  static const _ui = 'Nunito';
  static const _mono = 'JetBrains Mono';

  // ── Display / Heading — Lora ─────────────────────────────────────────────

  static TextStyle display({Color? color}) => TextStyle(
        fontFamily: _heading,
        fontSize: 48, fontWeight: FontWeight.w700,
        height: 1.333, letterSpacing: -0.6, color: color,
      );

  static TextStyle headline1({Color? color}) => TextStyle(
        fontFamily: _heading,
        fontSize: 36, fontWeight: FontWeight.w700,
        height: 1.444, letterSpacing: -0.5, color: color,
      );

  static TextStyle headline2({Color? color}) => TextStyle(
        fontFamily: _heading,
        fontSize: 30, fontWeight: FontWeight.w700,
        height: 1.467, letterSpacing: -0.4, color: color,
      );

  static TextStyle headline3({Color? color}) => TextStyle(
        fontFamily: _heading,
        fontSize: 24, fontWeight: FontWeight.w700,
        height: 1.5, letterSpacing: -0.3, color: color,
      );

  static TextStyle headline4({Color? color}) => TextStyle(
        fontFamily: _heading,
        fontSize: 20, fontWeight: FontWeight.w700,
        height: 1.6, letterSpacing: -0.2, color: color,
      );

  // ── Title / Body / Label — Nunito ────────────────────────────────────────

  static TextStyle title({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 20, fontWeight: FontWeight.w700,
        height: 1.6, letterSpacing: -0.2, color: color,
      );

  static TextStyle titleSm({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 18, fontWeight: FontWeight.w600,
        height: 1.556, letterSpacing: -0.1, color: color,
      );

  static TextStyle bodyLg({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 18, fontWeight: FontWeight.w400,
        height: 1.556, color: color,
      );

  static TextStyle body({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 16, fontWeight: FontWeight.w400,
        height: 1.5, color: color,
      );

  static TextStyle bodySm({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 14, fontWeight: FontWeight.w400,
        height: 1.429, letterSpacing: 0.2, color: color,
      );

  static TextStyle label({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 14, fontWeight: FontWeight.w500,
        height: 1.429, letterSpacing: 0.2, color: color,
      );

  static TextStyle labelSm({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 12, fontWeight: FontWeight.w500,
        height: 1.333, letterSpacing: 0.4, color: color,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 12, fontWeight: FontWeight.w400,
        height: 1.333, letterSpacing: 0.4, color: color,
      );

  static TextStyle button({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 16, fontWeight: FontWeight.w600,
        height: 1.5, color: color,
      );

  static TextStyle buttonSm({Color? color}) => TextStyle(
        fontFamily: _ui,
        fontSize: 14, fontWeight: FontWeight.w600,
        height: 1.429, letterSpacing: 0.1, color: color,
      );

  // ── Mono — JetBrains Mono (Glean et al.) ────────────────────────────────

  static TextStyle code({Color? color}) => TextStyle(
        fontFamily: _mono,
        fontSize: 14, fontWeight: FontWeight.w400,
        height: 1.429, color: color,
      );

  // ── Material-scale ladder — habit-lineage apps ──────────────────────────

  /// The Material-scale `TextTheme` ladder shipped by the habit-lineage apps
  /// (Sundial, Furrow, Glass, Bulwark), moved here verbatim from their
  /// byte-identical `app_theme.dart` copies.
  ///
  /// This is a **different ladder** from the role methods above ([display],
  /// [headline1], …): it follows the stock Material size scale (57/45/36/…)
  /// and sets *only* `fontFamily`/`fontSize`/`fontWeight` — no letterSpacing,
  /// no height. That difference is deliberate; do not "unify" the two.
  ///
  /// **Constraint: this block MUST stay byte-equal to what those four apps
  /// rendered before adopting it.** Their goldens assume it. Changing any
  /// entry here changes the type of four shipped apps.
  static const TextTheme materialTextTheme = TextTheme(
    displayLarge:  TextStyle(fontFamily: 'Lora', fontSize: 57, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontFamily: 'Lora', fontSize: 45, fontWeight: FontWeight.w700),
    displaySmall:  TextStyle(fontFamily: 'Lora', fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge:  TextStyle(fontFamily: 'Lora', fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontFamily: 'Lora', fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall:  TextStyle(fontFamily: 'Lora', fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge:  TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall:  TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge:  TextStyle(fontFamily: 'Nunito', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Nunito', fontSize: 14),
    bodySmall:  TextStyle(fontFamily: 'Nunito', fontSize: 12),
    labelLarge:  TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall:  TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w500),
  );
}
