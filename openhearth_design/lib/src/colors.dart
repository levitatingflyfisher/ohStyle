import 'package:flutter/material.dart';

abstract final class OhColors {
  // ── Hearth (primary brand — terracotta) ──────────────────────────────────
  static const hearth50  = Color(0xFFFDF5F3);
  static const hearth100 = Color(0xFFF8E8E3);
  static const hearth200 = Color(0xFFEDCDC5);
  static const hearth300 = Color(0xFFD9A99E);
  static const hearth400 = Color(0xFFC47B6A);
  static const hearth500 = Color(0xFFA85040); // PRIMARY interactive
  static const hearth600 = Color(0xFF8B3E2F);
  static const hearth700 = Color(0xFF6E2F22);
  static const hearth800 = Color(0xFF511F15);
  static const hearth900 = Color(0xFF370F09);

  // ── Linen (neutrals — warm whites/browns) ────────────────────────────────
  static const linen50  = Color(0xFFFBF8F4); // app background
  static const linen100 = Color(0xFFF5EFE6); // card surface
  static const linen200 = Color(0xFFEAE1D4); // subtle dividers
  static const linen300 = Color(0xFFC7B9A0); // borders, inactive icons
  static const linen400 = Color(0xFFB3A08A); // placeholder text
  static const linen500 = Color(0xFF8C7B65); // secondary text
  static const linen600 = Color(0xFF6E5F4C); // body text (softer)
  static const linen700 = Color(0xFF4D3E2E); // body text default
  static const linen800 = Color(0xFF35281C); // headings
  static const linen900 = Color(0xFF2C1810); // primary text

  // ── Sage (secondary — nature/success) ────────────────────────────────────
  static const sage100 = Color(0xFFE0EFEA);
  static const sage200 = Color(0xFFBED8CE);
  static const sage400 = Color(0xFF7BAF96);
  static const sage500 = Color(0xFF5E9478);
  static const sage600 = Color(0xFF4A7B65);

  // ── Slate (tertiary — informational/calm) ────────────────────────────────
  static const slate100 = Color(0xFFDDE5F1);
  static const slate300 = Color(0xFF97ACCA);
  static const slate500 = Color(0xFF5C7599);
  static const slate700 = Color(0xFF3A5070);

  // ── Semantic accents (sparingly) ─────────────────────────────────────────
  static const amber100 = Color(0xFFF5E9C8); // warning bg
  static const amber400 = Color(0xFFC49A3C); // warning
  static const red100   = Color(0xFFF5DDD9); // error bg
  static const red500   = Color(0xFFB0382A); // destructive/error

  // ── Hearth-dark surface palette ──────────────────────────────────────────
  // Warm brown-black, inside the hearth/linen family. Used by
  // [OhTheme.hearthDark] — the "evening" theme for reflective, lower-stakes
  // reading. See `ohStyle/CLAUDE.md` for when to pick hearth-dark vs night.
  static const darkSurfaceBase     = Color(0xFF1C1007);
  static const darkSurfaceCard     = Color(0xFF2A1A0D);
  static const darkSurfaceElevated = Color(0xFF3A2215);
  static const darkSurfaceHigh     = Color(0xFF4A2E1F);
  static const darkBorderSubtle    = Color(0xFF5A3A28);
  static const darkBorderDefault   = Color(0xFF6B4A34);

  // ── Night surface palette ────────────────────────────────────────────────
  // Neutral high-contrast dark, deliberately NOT in the hearth/linen family.
  // Used by [OhTheme.night] — the "deep reading" theme optimized for long
  // sessions (2am re-polls, multi-paragraph glossary entries, sustained
  // budgeting work). Leaves the warm palette on purpose — warmth is
  // atmospheric but harder on the eyes at very low ambient light.
  static const nightSurfaceBase     = Color(0xFF0A0A0C);
  static const nightSurfaceCard     = Color(0xFF141418);
  static const nightSurfaceElevated = Color(0xFF1F1F25);
  static const nightBorder          = Color(0xFF2A2A32);
  static const nightTextPrimary     = Color(0xFFEDEDF0);
  static const nightTextDim         = Color(0xFFA0A0AC);
}
