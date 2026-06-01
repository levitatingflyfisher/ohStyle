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
}
