import 'package:flutter/material.dart';

import 'colors.dart';

/// The colour language as roles, one set per theme (style guide §2.3).
///
/// Five families keep three jobs apart:
///
/// - **warmth** — who we are: the one primary action per screen, identity
///   moments. Never on anything destructive or failed.
/// - **urgency** — error, destructive. Always hue **plus** an icon **plus**
///   a word; take the colour away and it must still read as urgent.
/// - **warning** — "check this". Hue plus a triangle icon plus a word.
/// - **attention** — pointing-out: selection, focus, "new", links. Always
///   with a shape (ring, check, dot, underline), never a tint alone.
/// - **success** — done, safe. Hue plus a check or a word.
///
/// Chrome (icons, app-bar glyphs, dividers, inactive tracks) is neutral:
/// [icon], [textSecondary], never warmth.
///
/// Read it with `OhColorRoles.of(context)`; every `OhTheme` builder attaches
/// the matching instance. Every text role clears 4.5:1 and every mark role
/// 3:1 on its theme's grounds; `test/contrast_test.dart` measures it.
@immutable
class OhColorRoles extends ThemeExtension<OhColorRoles> {
  const OhColorRoles({
    required this.warmth,
    required this.warmthPressed,
    required this.onWarmth,
    required this.urgency,
    required this.onUrgency,
    required this.urgencySurface,
    required this.warningText,
    required this.warningIcon,
    required this.warningSurface,
    required this.success,
    required this.successSurface,
    required this.attention,
    required this.onAttention,
    required this.attentionSurface,
    required this.info,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLabel,
    required this.icon,
    required this.controlBorder,
  });

  final Color warmth;
  final Color warmthPressed;
  final Color onWarmth;
  final Color urgency;
  final Color onUrgency;
  final Color urgencySurface;
  final Color warningText;

  /// A mark, not text: clears 3:1 only.
  final Color warningIcon;
  final Color warningSurface;
  final Color success;
  final Color successSurface;
  final Color attention;
  final Color onAttention;
  final Color attentionSurface;
  final Color info;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLabel;

  /// Neutral chrome glyphs.
  final Color icon;

  /// The border that is a control's only edge (3:1).
  final Color controlBorder;

  /// Light (hearth). Warmth is terracotta at OKLCH hue 42.
  static const light = OhColorRoles(
    warmth: OhColors.hearth500,
    warmthPressed: OhColors.hearth600,
    onWarmth: Colors.white,
    urgency: OhColors.red500,
    onUrgency: Colors.white,
    urgencySurface: OhColors.red100,
    warningText: OhColors.amber700,
    warningIcon: OhColors.amber500,
    warningSurface: OhColors.amber100,
    success: OhColors.sage700,
    successSurface: OhColors.successSurface,
    attention: OhColors.slate600,
    onAttention: Colors.white,
    attentionSurface: OhColors.attentionSurface,
    info: OhColors.slate700,
    textPrimary: OhColors.linen900,
    textSecondary: OhColors.linen600,
    textLabel: OhColors.linen700,
    icon: OhColors.linen700,
    controlBorder: OhColors.linen500,
  );

  /// hearthDark (evening). Status roles are shared with [night].
  static const hearthDark = OhColorRoles(
    warmth: OhColors.hearth400,
    warmthPressed: OhColors.hearth300,
    onWarmth: OhColors.linen900,
    urgency: OhColors.red300,
    onUrgency: OhColors.linen900,
    urgencySurface: OhColors.darkUrgencySurface,
    warningText: OhColors.amber300,
    warningIcon: OhColors.amber300,
    warningSurface: OhColors.darkWarningSurface,
    success: OhColors.sage300,
    successSurface: OhColors.darkSuccessSurface,
    attention: OhColors.slate200,
    onAttention: OhColors.linen900,
    attentionSurface: OhColors.darkAttentionSurface,
    info: OhColors.slate300,
    textPrimary: OhColors.linen100,
    textSecondary: OhColors.linen300,
    textLabel: OhColors.linen300,
    icon: OhColors.linen300,
    controlBorder: OhColors.linen500,
  );

  /// Night (deep reading). No warmth role: [warmth] is the sage accent.
  static const night = OhColorRoles(
    warmth: OhColors.sage400,
    warmthPressed: OhColors.sage300,
    onWarmth: OhColors.nightSurfaceBase,
    urgency: OhColors.red300,
    onUrgency: OhColors.nightSurfaceBase,
    urgencySurface: OhColors.nightUrgencySurface,
    warningText: OhColors.amber300,
    warningIcon: OhColors.amber300,
    warningSurface: OhColors.nightWarningSurface,
    success: OhColors.sage300,
    successSurface: OhColors.nightSuccessSurface,
    attention: OhColors.slate200,
    onAttention: OhColors.nightSurfaceBase,
    attentionSurface: OhColors.nightAttentionSurface,
    info: OhColors.slate300,
    textPrimary: OhColors.nightTextPrimary,
    textSecondary: OhColors.nightTextDim,
    textLabel: OhColors.nightTextDim,
    icon: OhColors.nightTextDim,
    controlBorder: OhColors.nightBorderControl,
  );

  /// The roles of the enclosing theme. A theme not built by `OhTheme`
  /// (the habit-lineage apps build their own `ThemeData`) carries no
  /// extension; it gets [hearthDark] when dark and [light] otherwise, so a
  /// dark app never receives light urgency on a dark ground. Such apps
  /// should still attach the right instance via `ThemeData(extensions:)`.
  static OhColorRoles of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<OhColorRoles>() ??
        (theme.brightness == Brightness.dark ? hearthDark : light);
  }

  @override
  OhColorRoles copyWith({
    Color? warmth,
    Color? warmthPressed,
    Color? onWarmth,
    Color? urgency,
    Color? onUrgency,
    Color? urgencySurface,
    Color? warningText,
    Color? warningIcon,
    Color? warningSurface,
    Color? success,
    Color? successSurface,
    Color? attention,
    Color? onAttention,
    Color? attentionSurface,
    Color? info,
    Color? textPrimary,
    Color? textSecondary,
    Color? textLabel,
    Color? icon,
    Color? controlBorder,
  }) =>
      OhColorRoles(
        warmth: warmth ?? this.warmth,
        warmthPressed: warmthPressed ?? this.warmthPressed,
        onWarmth: onWarmth ?? this.onWarmth,
        urgency: urgency ?? this.urgency,
        onUrgency: onUrgency ?? this.onUrgency,
        urgencySurface: urgencySurface ?? this.urgencySurface,
        warningText: warningText ?? this.warningText,
        warningIcon: warningIcon ?? this.warningIcon,
        warningSurface: warningSurface ?? this.warningSurface,
        success: success ?? this.success,
        successSurface: successSurface ?? this.successSurface,
        attention: attention ?? this.attention,
        onAttention: onAttention ?? this.onAttention,
        attentionSurface: attentionSurface ?? this.attentionSurface,
        info: info ?? this.info,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textLabel: textLabel ?? this.textLabel,
        icon: icon ?? this.icon,
        controlBorder: controlBorder ?? this.controlBorder,
      );

  @override
  OhColorRoles lerp(OhColorRoles? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return OhColorRoles(
      warmth: l(warmth, other.warmth),
      warmthPressed: l(warmthPressed, other.warmthPressed),
      onWarmth: l(onWarmth, other.onWarmth),
      urgency: l(urgency, other.urgency),
      onUrgency: l(onUrgency, other.onUrgency),
      urgencySurface: l(urgencySurface, other.urgencySurface),
      warningText: l(warningText, other.warningText),
      warningIcon: l(warningIcon, other.warningIcon),
      warningSurface: l(warningSurface, other.warningSurface),
      success: l(success, other.success),
      successSurface: l(successSurface, other.successSurface),
      attention: l(attention, other.attention),
      onAttention: l(onAttention, other.onAttention),
      attentionSurface: l(attentionSurface, other.attentionSurface),
      info: l(info, other.info),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textLabel: l(textLabel, other.textLabel),
      icon: l(icon, other.icon),
      controlBorder: l(controlBorder, other.controlBorder),
    );
  }
}
