// packages/openhearth_design/lib/src/icon_buttons.dart
import 'package:flutter/material.dart';

enum _OhIconButtonVariant { filled, filledTonal }

/// A drop-in wrapper around [IconButton.filled] / [IconButton.filledTonal]
/// that pins each variant's correct foreground color at the widget level —
/// the highest-precedence style layer, above `IconButtonThemeData` and the
/// ambient `ThemeData.iconTheme`.
///
/// ## Why this exists
///
/// `OhTheme` sets an app-wide `ThemeData.iconTheme = IconThemeData(color:
/// primary)` (see the comment at `theme.dart`'s `iconTheme:` line). Flutter
/// 3.38.7 resolves that ambient color ABOVE `IconButton.filled`'s own
/// `defaultStyleOf`, so an unstyled `IconButton.filled` paints its glyph in
/// `primary` — the exact color it just filled its own background with. The
/// glyph is invisible. `IconButton.filledTonal` has the same problem: it
/// gets `primary` instead of `onSecondaryContainer`.
///
/// Use `OhIconButton.filled` / `OhIconButton.filledTonal` anywhere the plain
/// Material widgets would otherwise be used, and the glyph resolves
/// correctly under every `OhTheme` variant.
class OhIconButton extends StatelessWidget {
  /// A filled icon button whose glyph resolves to `colorScheme.onPrimary`
  /// instead of colliding with its own `primary` background fill.
  const OhIconButton.filled({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.constraints,
    this.padding,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _OhIconButtonVariant.filled;

  /// A filled-tonal icon button whose glyph resolves to
  /// `colorScheme.onSecondaryContainer` instead of colliding with
  /// `primary`.
  const OhIconButton.filledTonal({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.constraints,
    this.padding,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _OhIconButtonVariant.filledTonal;

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final bool autofocus;
  final FocusNode? focusNode;
  final ButtonStyle? style;

  final _OhIconButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = switch (_variant) {
      _OhIconButtonVariant.filled => colorScheme.onPrimary,
      _OhIconButtonVariant.filledTonal => colorScheme.onSecondaryContainer,
    };

    // The caller's style wins where it sets a field; ButtonStyle.merge
    // keeps the receiver's non-null fields and falls back to the argument
    // for anything the receiver left unset — so `style!.merge(base)` lets
    // an explicit caller foregroundColor override ours while still
    // inheriting `base` for everything the caller didn't specify.
    final base = IconButton.styleFrom(foregroundColor: foreground);
    final resolvedStyle = style == null ? base : style!.merge(base);

    return switch (_variant) {
      _OhIconButtonVariant.filled => IconButton.filled(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
          iconSize: iconSize,
          constraints: constraints,
          padding: padding,
          autofocus: autofocus,
          focusNode: focusNode,
          style: resolvedStyle,
        ),
      _OhIconButtonVariant.filledTonal => IconButton.filledTonal(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
          iconSize: iconSize,
          constraints: constraints,
          padding: padding,
          autofocus: autofocus,
          focusNode: focusNode,
          style: resolvedStyle,
        ),
    };
  }
}
