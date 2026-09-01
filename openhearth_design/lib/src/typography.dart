import 'package:flutter/material.dart';

/// OpenHearth typography roles.
///
/// **Fonts come from this package** (since 0.7.1). `openhearth_design`
/// declares the canonical Lora and Nunito files (OFL, in `fonts/`) as
/// package fonts, and every style here passes `package: 'openhearth_design'`,
/// so its family resolves to `packages/openhearth_design/Lora` /
/// `.../Nunito`. Any app that depends on the package gets the same type,
/// offline, with no font files or pubspec block of its own. Privacy
/// posture: zero runtime fetches, zero Google CDN traffic.
///
/// An app that still bundles its own `Lora`/`Nunito` keeps working: those
/// families are simply unused by these styles. Its own code that names
/// `fontFamily: 'Lora'` directly still resolves to its own copy, and stops
/// resolving the day the copy is removed — see the README migration note.
abstract final class OhTypography {
  static const _package = 'openhearth_design';
  static const _heading = 'Lora';
  static const _ui = 'Nunito';

  /// Platform monospace. No monospace file is bundled anywhere in the fleet
  /// (the old `JetBrains Mono` request resolved to nothing), so [code] asks
  /// for the platform's generic family rather than a face that is not there.
  static const _mono = 'monospace';

  /// The one type ladder: 16 px body, stepped by about 1.2 (a minor third)
  /// and rounded. Every size any role or Material slot uses is on it; no
  /// two distinct sizes are closer than 3 px, because a one- or two-pixel
  /// step (the old 11/12/14 and 22/24) reads as a mistake, not a level.
  /// Below 16 there is exactly one step, 13: roles that share it differ by
  /// weight, which is how you separate small type (Kadavy: "bold instead").
  static const List<double> ladder = [13, 16, 19, 23, 28, 33, 40, 48, 57];

  // Weights requested below are only those the canonical files in
  // `fonts/` supply: Lora 400, 400 italic, 500, 700; Nunito 400, 500, 600,
  // 700. There is no Lora 300 or 600 and no Nunito italic anywhere in the
  // fleet; `test/font_bundle_test.dart` fails if a style asks for one.

  // ── Display / Heading — Lora ─────────────────────────────────────────────

  static TextStyle display({Color? color}) => TextStyle(
        fontFamily: _heading, package: _package,
        fontSize: 48, fontWeight: FontWeight.w700,
        height: 1.15, letterSpacing: -0.6, color: color,
      );

  static TextStyle headline1({Color? color}) => TextStyle(
        fontFamily: _heading, package: _package,
        fontSize: 40, fontWeight: FontWeight.w700,
        height: 1.2, letterSpacing: -0.5, color: color,
      );

  static TextStyle headline2({Color? color}) => TextStyle(
        fontFamily: _heading, package: _package,
        fontSize: 33, fontWeight: FontWeight.w700,
        height: 1.2, letterSpacing: -0.4, color: color,
      );

  static TextStyle headline3({Color? color}) => TextStyle(
        fontFamily: _heading, package: _package,
        fontSize: 28, fontWeight: FontWeight.w700,
        height: 1.25, letterSpacing: -0.3, color: color,
      );

  static TextStyle headline4({Color? color}) => TextStyle(
        fontFamily: _heading, package: _package,
        fontSize: 23, fontWeight: FontWeight.w700,
        height: 1.3, letterSpacing: -0.2, color: color,
      );

  // ── Title / Body / Label — Nunito ────────────────────────────────────────

  static TextStyle title({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 23, fontWeight: FontWeight.w700,
        height: 1.3, letterSpacing: -0.2, color: color,
      );

  /// App-bar and section titles.
  static TextStyle titleSm({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 19, fontWeight: FontWeight.w600,
        height: 1.3, letterSpacing: -0.1, color: color,
      );

  /// Prose to read at length.
  static TextStyle bodyLg({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 19, fontWeight: FontWeight.w400,
        height: 1.4, color: color,
      );

  static TextStyle body({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 16, fontWeight: FontWeight.w400,
        height: 1.4, color: color,
      );

  /// Secondary text. The same step as [caption]; the two names are kept so
  /// call sites read by intent.
  static TextStyle bodySm({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w400,
        height: 1.4, letterSpacing: 0.2, color: color,
      );

  /// Chips, tabs, field labels: small, told apart from body by weight.
  static TextStyle label({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w600,
        height: 1.35, letterSpacing: 0.2, color: color,
      );

  /// Section labels. Sentence case; heavier than [label] so it holds at
  /// 13 px in a secondary colour.
  static TextStyle labelSm({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w700,
        height: 1.35, letterSpacing: 0.4, color: color,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w400,
        height: 1.4, letterSpacing: 0.3, color: color,
      );

  static TextStyle button({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 16, fontWeight: FontWeight.w600,
        height: 1.25, color: color,
      );

  static TextStyle buttonSm({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w600,
        height: 1.25, letterSpacing: 0.2, color: color,
      );

  // ── List rows ────────────────────────────────────────────────────────────

  /// A list row's title: body size, one weight up, so a row reads as
  /// title-over-detail without growing (the old ListTile was 18 regular
  /// over 16 regular). `OhTheme` wires it into `listTileTheme`.
  static TextStyle listTitle({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 16, fontWeight: FontWeight.w600,
        height: 1.35, color: color,
      );

  /// A list row's detail line, one step below [listTitle].
  static TextStyle listSubtitle({Color? color}) => TextStyle(
        fontFamily: _ui, package: _package,
        fontSize: 13, fontWeight: FontWeight.w400,
        height: 1.4, letterSpacing: 0.2, color: color,
      );

  // ── Mono — platform monospace ───────────────────────────────────────────

  static TextStyle code({Color? color}) => TextStyle(
        fontFamily: _mono,
        fontSize: 13, fontWeight: FontWeight.w400,
        height: 1.4, color: color,
      );

  // ── Material-slot ladder — habit-lineage apps ──────────────────────────

  /// The `TextTheme` shipped by the habit-lineage apps (Sundial, Furrow,
  /// Glass, Bulwark), which build their own `ThemeData`.
  ///
  /// Since 0.7.0 it sits on the same [ladder] as the role methods: each
  /// Material slot takes the nearest step to its old stock-Material size
  /// (57/45/36/32/28/24/22/16/14/16/14/12/14/12/11). It still sets *only*
  /// `fontFamily`/`fontSize`/`fontWeight` — no height, no letterSpacing —
  /// so those apps keep their line metrics. The old block asked for Lora
  /// w600, which no bundled file supplies; the headlines are w700 now.
  ///
  /// Visible changes for those apps: `bodyMedium` (default `Text`) 14 → 16,
  /// `bodyLarge` 16 → 19, `labelLarge` (buttons) 14 → 16, the 11/12 labels
  /// → 13. Their goldens and identity tests need re-approval.
  static const TextTheme materialTextTheme = TextTheme(
    displayLarge:  TextStyle(fontFamily: 'Lora', package: _package, fontSize: 57, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontFamily: 'Lora', package: _package, fontSize: 48, fontWeight: FontWeight.w700),
    displaySmall:  TextStyle(fontFamily: 'Lora', package: _package, fontSize: 40, fontWeight: FontWeight.w700),
    headlineLarge:  TextStyle(fontFamily: 'Lora', package: _package, fontSize: 33, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontFamily: 'Lora', package: _package, fontSize: 28, fontWeight: FontWeight.w700),
    headlineSmall:  TextStyle(fontFamily: 'Lora', package: _package, fontSize: 23, fontWeight: FontWeight.w700),
    titleLarge:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 19, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 13, fontWeight: FontWeight.w700),
    bodyLarge:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 19),
    bodyMedium: TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 16),
    bodySmall:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 13),
    labelLarge:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 13, fontWeight: FontWeight.w600),
    labelSmall:  TextStyle(fontFamily: 'Nunito', package: _package, fontSize: 13, fontWeight: FontWeight.w500),
  );
}
