import 'package:flutter/material.dart';

abstract final class OhSpacing {
  // ── Scale ─────────────────────────────────────────────────────────────────
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 40.0;
  static const xxl = 64.0;

  // ── Convenience EdgeInsets ────────────────────────────────────────────────
  static const insetSm   = EdgeInsets.all(8);
  static const insetMd   = EdgeInsets.all(16);
  static const insetLg   = EdgeInsets.all(24);
  static const insetHMd  = EdgeInsets.symmetric(horizontal: 16);
  static const insetHLg  = EdgeInsets.symmetric(horizontal: 24);
  static const insetVSm  = EdgeInsets.symmetric(vertical: 8);
  static const insetVMd  = EdgeInsets.symmetric(vertical: 16);
  static const insetVLg  = EdgeInsets.symmetric(vertical: 24);
  static const insetPage = EdgeInsets.symmetric(horizontal: 24, vertical: 16);
}
