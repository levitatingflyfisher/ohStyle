// packages/openhearth_design/lib/src/theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'radii.dart';
import 'typography.dart';

/// OpenHearth theme builders.
///
/// Three themes, not two. See `ohStyle/CLAUDE.md` and the tri-theme section
/// of `openHearthStyleGuide.md` for the why.
///
/// - [light]       — default. Hearth terracotta on warm linen. Daytime.
/// - [hearthDark]  — warm dark. Hearth-300 salmon on brown-black, inside
///                   the hearth/linen family. Evening / reflective reading.
/// - [night]       — neutral high-contrast dark. Sage accent on true grays,
///                   leaves the warm family on purpose. Deep reading,
///                   middle-of-the-night sessions, long budgeting work.
///
/// Every method accepts [appAccent] to override the primary interactive
/// color per app (e.g. Lullaby passes `OhColors.sage500`). The surface
/// and text ramps stay consistent across apps within a theme.
abstract final class OhTheme {
  // ── Light ────────────────────────────────────────────────────────────────

  /// Light theme. Hearth terracotta by default. Pass [appAccent] to override.
  static ThemeData light({Color? appAccent}) {
    final primary = appAccent ?? OhColors.hearth500;
    final cs = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      surface: OhColors.linen100,
      onSurface: OhColors.linen900,
      surfaceContainerHighest: OhColors.linen200,
      onSurfaceVariant: OhColors.linen700,
      outline: OhColors.linen300,
      outlineVariant: OhColors.linen200,
      error: OhColors.red500,
      onError: Colors.white,
      errorContainer: OhColors.red100,
      onErrorContainer: OhColors.red500,
    );
    return _baseTheme(
      cs: cs,
      primary: primary,
      scaffold: OhColors.linen50,
      onSurfaceForChrome: OhColors.linen900,
      cardColor: OhColors.linen100,
      buttonFg: Colors.white,
      inputFill: OhColors.linen100,
      inputBorder: OhColors.linen300,
      inputHint: OhColors.linen400,
      inputLabel: OhColors.linen500,
      dividerColor: OhColors.linen200,
      sliderInactive: primary.withValues(alpha: 0.18),
      sliderOverlayAlpha: 0.15,
      textThemeIsDark: false,
    );
  }

  // ── Hearth-dark (evening) ────────────────────────────────────────────────

  /// Warm dark theme, hearth family. Hearth-400 by default.
  static ThemeData hearthDark({Color? appAccent}) {
    final primary = appAccent ?? OhColors.hearth400;
    final cs = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primary,
      onPrimary: OhColors.linen900,
      surface: OhColors.darkSurfaceCard,
      onSurface: OhColors.linen100,
      surfaceContainerHighest: OhColors.darkSurfaceElevated,
      onSurfaceVariant: OhColors.linen300,
      outline: OhColors.darkBorderDefault,
      outlineVariant: OhColors.darkBorderSubtle,
      error: OhColors.red500,
      onError: Colors.white,
      errorContainer: OhColors.red500,
      onErrorContainer: OhColors.linen100,
    );
    return _baseTheme(
      cs: cs,
      primary: primary,
      scaffold: OhColors.darkSurfaceBase,
      onSurfaceForChrome: OhColors.linen100,
      cardColor: OhColors.darkSurfaceCard,
      buttonFg: OhColors.linen900,
      inputFill: OhColors.darkSurfaceCard,
      inputBorder: OhColors.darkBorderSubtle,
      inputHint: OhColors.linen500,
      inputLabel: OhColors.linen400,
      dividerColor: OhColors.darkBorderSubtle,
      sliderInactive: OhColors.darkBorderDefault,
      sliderOverlayAlpha: 0.2,
      textThemeIsDark: true,
    );
  }

  // ── Night (deep reading) ─────────────────────────────────────────────────

  /// Neutral high-contrast dark. Sage-400 by default (softer on the eyes
  /// than hearth at very low ambient light). Intentionally leaves the
  /// hearth/linen palette — warmth is atmospheric but tiring after 20+
  /// minutes of focused reading.
  static ThemeData night({Color? appAccent}) {
    final primary = appAccent ?? OhColors.sage400;
    final cs = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primary,
      onPrimary: OhColors.nightSurfaceBase,
      surface: OhColors.nightSurfaceCard,
      onSurface: OhColors.nightTextPrimary,
      surfaceContainerHighest: OhColors.nightSurfaceElevated,
      onSurfaceVariant: OhColors.nightTextDim,
      outline: OhColors.nightBorder,
      outlineVariant: OhColors.nightBorder,
      error: OhColors.red500,
      onError: Colors.white,
      errorContainer: OhColors.red500,
      onErrorContainer: OhColors.nightTextPrimary,
    );
    return _baseTheme(
      cs: cs,
      primary: primary,
      scaffold: OhColors.nightSurfaceBase,
      onSurfaceForChrome: OhColors.nightTextPrimary,
      cardColor: OhColors.nightSurfaceCard,
      buttonFg: OhColors.nightSurfaceBase,
      inputFill: OhColors.nightSurfaceElevated,
      inputBorder: OhColors.nightBorder,
      inputHint: OhColors.nightTextDim,
      inputLabel: OhColors.nightTextDim,
      dividerColor: OhColors.nightBorder,
      sliderInactive: OhColors.nightBorder,
      sliderOverlayAlpha: 0.2,
      textThemeIsDark: true,
      textPrimaryOverride: OhColors.nightTextPrimary,
      textSecondaryOverride: OhColors.nightTextDim,
    );
  }

  /// Shorthand for `Theme.of(context).colorScheme`.
  static ColorScheme colorsOf(BuildContext context) =>
      Theme.of(context).colorScheme;

  // ── Internal ─────────────────────────────────────────────────────────────

  /// Shared ThemeData builder for all three variants. Every knob that
  /// differs between light/hearthDark/night is a named parameter — the
  /// builder itself stays identical so every theme speaks the same grammar.
  static ThemeData _baseTheme({
    required ColorScheme cs,
    required Color primary,
    required Color scaffold,
    required Color onSurfaceForChrome,
    required Color cardColor,
    required Color buttonFg,
    required Color inputFill,
    required Color inputBorder,
    required Color inputHint,
    required Color inputLabel,
    required Color dividerColor,
    required Color sliderInactive,
    required double sliderOverlayAlpha,
    required bool textThemeIsDark,
    Color? textPrimaryOverride,
    Color? textSecondaryOverride,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: scaffold,
      textTheme: _buildTextTheme(
        isDark: textThemeIsDark,
        primaryOverride: textPrimaryOverride,
        secondaryOverride: textSecondaryOverride,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: onSurfaceForChrome,
        titleTextStyle: OhTypography.titleSm(color: onSurfaceForChrome),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: OhRadii.lg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: buttonFg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: OhTypography.button(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: OhTypography.button(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: OhTypography.button(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(color: inputHint),
        labelStyle: TextStyle(color: inputLabel),
      ),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
      // Deliberate, app-wide: plain icons pick up the brand accent without
      // every call site setting a color. The tradeoff: Flutter 3.38.7
      // resolves this ambient color ABOVE `IconButton.filled` /
      // `.filledTonal`'s own `defaultStyleOf`, so an unstyled filled icon
      // button paints its glyph in `primary` — the same color it just
      // filled its own background with, i.e. invisible. Use
      // `OhIconButton.filled` / `.filledTonal` (in `icon_buttons.dart`)
      // for those two variants; it pins the correct foreground at the
      // widget level, which outranks this theme setting.
      iconTheme: IconThemeData(color: primary),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 4,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: OhRadii.lg),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: sliderInactive,
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: sliderOverlayAlpha),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required bool isDark,
    Color? primaryOverride,
    Color? secondaryOverride,
  }) {
    final textColor = primaryOverride ??
        (isDark ? OhColors.linen100 : OhColors.linen900);
    final secondaryColor = secondaryOverride ??
        (isDark ? OhColors.linen300 : OhColors.linen700);
    return TextTheme(
      displayLarge:   OhTypography.display(color: textColor),
      displayMedium:  OhTypography.headline1(color: textColor),
      displaySmall:   OhTypography.headline2(color: textColor),
      headlineLarge:  OhTypography.headline3(color: textColor),
      headlineMedium: OhTypography.headline4(color: textColor),
      headlineSmall:  OhTypography.title(color: textColor),
      titleLarge:     OhTypography.titleSm(color: textColor),
      titleMedium:    OhTypography.label(color: textColor),
      titleSmall:     OhTypography.labelSm(color: secondaryColor),
      bodyLarge:      OhTypography.bodyLg(color: textColor),
      bodyMedium:     OhTypography.body(color: textColor),
      bodySmall:      OhTypography.bodySm(color: secondaryColor),
      labelLarge:     OhTypography.button(color: textColor),
      labelMedium:    OhTypography.caption(color: secondaryColor),
      labelSmall:     OhTypography.caption(color: secondaryColor),
    );
  }
}
