import 'package:flutter/animation.dart';

/// OpenHearth motion tokens.
///
/// Durations sit on the slower end of Material defaults because the
/// design principle ("calm over stimulating") prefers deliberate
/// transitions over snappy ones. Use these everywhere an animation
/// length would otherwise be a magic number.
///
/// Easing bindings follow Material 3's spec:
/// - [standard]     — most navigations, surface enters/exits
/// - [emphasized]   — the hero transitions that deserve attention
/// - [decelerated]  — things arriving from offscreen / appearing
abstract final class OhMotion {
  // ── Durations ────────────────────────────────────────────────────────────

  /// Immediate feedback: ripple expand, checkbox toggle.
  static const Duration instant = Duration(milliseconds: 80);

  /// Hover, press, simple state changes.
  static const Duration fast = Duration(milliseconds: 160);

  /// Route changes, card elevation shifts, tab switches.
  static const Duration standard = Duration(milliseconds: 240);

  /// Reveal animations, hero transitions, deliberate moments.
  static const Duration deliberate = Duration(milliseconds: 400);

  // ── Easings ──────────────────────────────────────────────────────────────

  /// Material 3 "standard" curve — balanced acceleration/deceleration.
  static const Curve standardCurve = Cubic(0.2, 0.0, 0, 1.0);

  /// Emphasized — stronger arrival, used for important transitions.
  static const Curve emphasized = Cubic(0.2, 0.0, 0, 1.0);

  /// Decelerated — fast in, gentle stop. For things entering the screen.
  static const Curve decelerated = Cubic(0.0, 0.0, 0.2, 1.0);
}
