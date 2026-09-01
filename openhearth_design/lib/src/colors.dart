import 'package:flutter/material.dart';

abstract final class OhColors {
  // ── Hearth (warmth — brand terracotta) ───────────────────────────────────
  // The colour language (style guide §2.3) gives red two jobs and keeps
  // them apart: *warmth* (who we are: brand, the one primary action,
  // identity moments) and *urgency* (error, destructive). Warmth sits at
  // OKLCH hue 42 (clay), urgency at hue 22 (crimson). Warmth is never
  // painted on anything destructive or failed.
  // 0.7.0 moved 400/500/600 from hue 32 to hue 42 (research note
  // 2026-09-26-colour-language.md §4); 500 is a step darker than the note's
  // #A4512E so it clears 4.5:1 on the raised container (linen200) too.
  static const hearth50  = Color(0xFFFDF5F3);
  static const hearth100 = Color(0xFFF8E8E3);
  static const hearth200 = Color(0xFFEDCDC5);
  static const hearth300 = Color(0xFFD9A99E);
  static const hearth400 = Color(0xFFCD8366); // hearthDark warmth
  static const hearth500 = Color(0xFF9E4D2C); // light warmth (primary)
  static const hearth600 = Color(0xFF893F21); // light warmth, pressed
  static const hearth700 = Color(0xFF6E2F22);
  static const hearth800 = Color(0xFF511F15);
  static const hearth900 = Color(0xFF370F09);

  // ── Linen (neutrals — warm whites/browns) ────────────────────────────────
  static const linen50  = Color(0xFFFBF8F4); // app background
  static const linen100 = Color(0xFFF5EFE6); // card surface
  static const linen200 = Color(0xFFEAE1D4); // subtle dividers
  static const linen300 = Color(0xFFC7B9A0); // decorative borders; dark secondary text
  static const linen400 = Color(0xFFB3A08A); // hearthDark hint text (2.21:1 on light — never text there)
  static const linen500 = Color(0xFF8C7B65); // control borders (3:1); NOT text on light (3.58:1)
  static const linen600 = Color(0xFF6E5F4C); // light secondary text + input hint (5.40:1)
  static const linen700 = Color(0xFF4D3E2E); // light label text, neutral icons
  static const linen800 = Color(0xFF35281C); // headings
  static const linen900 = Color(0xFF2C1810); // primary text

  // ── Sage (secondary — nature/success) ────────────────────────────────────
  static const sage100 = Color(0xFFE0EFEA);
  static const sage200 = Color(0xFFBED8CE);
  static const sage300 = Color(0xFF7DBB9A); // dark/night success
  static const sage400 = Color(0xFF7BAF96);
  static const sage500 = Color(0xFF5E9478);
  static const sage600 = Color(0xFF4A7B65);
  static const sage700 = Color(0xFF386D54); // light success text (5.27:1)

  // ── Slate (tertiary — informational/calm) ────────────────────────────────
  static const slate100 = Color(0xFFDDE5F1);
  static const slate200 = Color(0xFF8FB4E4); // dark/night attention
  static const slate300 = Color(0xFF97ACCA);
  static const slate500 = Color(0xFF5C7599);
  static const slate600 = Color(0xFF39659B); // light attention (pointing-out, links)
  static const slate700 = Color(0xFF3A5070);

  // ── Semantic accents: urgency, caution, pointing-out ─────────────────────
  // Urgency is never carried by hue alone: every error or destructive
  // element also has an icon and a word. Prefer the role names in
  // [OhColorRoles] over these ramp steps.
  static const amber100 = Color(0xFFFCEDCD); // light warning surface
  static const amber300 = Color(0xFFE7B551); // dark/night warning (text + icon)
  // Kept for existing callers only: 2.29:1 on linen, fails even as an icon.
  static const amber400 = Color(0xFFC49A3C);
  static const amber500 = Color(0xFFA0701A); // light warning icon (3:1, marks only)
  static const amber700 = Color(0xFF805307); // light warning text
  static const red100   = Color(0xFFFFE7E6); // light urgency surface
  static const red300   = Color(0xFFFF939C); // dark/night urgency
  static const red500   = Color(0xFF9B1D29); // light urgency: error, destructive

  // Status surfaces (a tinted container behind a status line).
  static const successSurface   = Color(0xFFE1F4E9);
  static const attentionSurface = Color(0xFFE4F0FF);

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
  static const darkUrgencySurface   = Color(0xFF4B1D1F);
  static const darkWarningSurface   = Color(0xFF3E2D10);
  static const darkSuccessSurface   = Color(0xFF1B3427);
  static const darkAttentionSurface = Color(0xFF202F42);

  // ── Night surface palette ────────────────────────────────────────────────
  // Neutral high-contrast dark, deliberately NOT in the hearth/linen family.
  // Used by [OhTheme.night] — the "deep reading" theme optimized for long
  // sessions (2am re-polls, multi-paragraph glossary entries, sustained
  // budgeting work). Leaves the warm palette on purpose — warmth is
  // atmospheric but harder on the eyes at very low ambient light.
  static const nightSurfaceBase     = Color(0xFF0A0A0C);
  static const nightSurfaceCard     = Color(0xFF141418);
  static const nightSurfaceElevated = Color(0xFF1F1F25);
  static const nightBorder          = Color(0xFF2A2A32); // decorative
  static const nightBorderControl   = Color(0xFF76767F); // a field's only edge (3.64:1)
  static const nightTextPrimary     = Color(0xFFEDEDF0);
  static const nightTextDim         = Color(0xFFA0A0AC);
  static const nightUrgencySurface   = Color(0xFF421B1C);
  static const nightWarningSurface   = Color(0xFF37290F);
  static const nightSuccessSurface   = Color(0xFF192E23);
  static const nightAttentionSurface = Color(0xFF1D2A3A);
}
