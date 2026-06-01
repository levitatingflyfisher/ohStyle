import 'package:flutter/material.dart';

/// OpenHearth elevation ramp.
///
/// Shadows are warm (hinting brown, not cool gray) to match the linen /
/// hearth palette. Four steps cover the realistic spectrum: surfaces at
/// rest, floating affordances (FABs, toasts), modal content (bottom
/// sheets, dialogs), and fleeting overlays (menus, tooltips).
///
/// Consumers import lists directly:
///   ```
///   Container(decoration: BoxDecoration(boxShadow: OhElevation.raised))
///   ```
abstract final class OhElevation {
  static const Color _warmShadow = Color(0xFF2C1810); // linen-900
  static const Color _darkShadow = Color(0xFF000000);

  // ── Light mode ───────────────────────────────────────────────────────────

  /// Cards, pressed chips, stationary surfaces sitting just above the scaffold.
  static List<BoxShadow> get raised => [
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.06),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.04),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ];

  /// FABs, promoted buttons, inline toasts.
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.1),
          offset: const Offset(0, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.08),
          offset: const Offset(0, 8),
          blurRadius: 20),
      ];

  /// Bottom sheets and dialogs. Detached from the surface below.
  static List<BoxShadow> get modal => [
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.14),
          offset: const Offset(0, 12),
          blurRadius: 28,
        ),
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.1),
          offset: const Offset(0, 24),
          blurRadius: 48,
          spreadRadius: -8,
        ),
      ];

  /// Menus and tooltips. Sharp and close to the surface — quick dismissals.
  static List<BoxShadow> get overlay => [
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.16),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
        BoxShadow(
          color: _warmShadow.withValues(alpha: 0.1),
          offset: const Offset(0, 6),
          blurRadius: 14,
          spreadRadius: -4,
        ),
      ];

  // ── Dark mode ────────────────────────────────────────────────────────────

  /// Dark-mode cards. Shadows are true black with lower alpha — the eye
  /// reads elevation via contrast, not warmth, on a dark bg.
  static List<BoxShadow> get raisedDark => [
        BoxShadow(
          color: _darkShadow.withValues(alpha: 0.4),
          offset: const Offset(0, 1),
          blurRadius: 3,
        ),
      ];

  static List<BoxShadow> get floatingDark => [
        BoxShadow(
          color: _darkShadow.withValues(alpha: 0.5),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ];

  static List<BoxShadow> get modalDark => [
        BoxShadow(
          color: _darkShadow.withValues(alpha: 0.6),
          offset: const Offset(0, 12),
          blurRadius: 32,
        ),
      ];

  static List<BoxShadow> get overlayDark => [
        BoxShadow(
          color: _darkShadow.withValues(alpha: 0.55),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ];
}
