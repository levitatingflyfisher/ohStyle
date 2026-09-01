# Changelog

## 0.9.0

Bar commands fold by space, not at a fixed text scale.

- **The fold rule.** Inside `OhBarActions`, words stay visible whenever they
  fit beside a whole title and fold (rightmost first, into the tooltip and
  screen-reader name) only when they do not. The row measures the AppBar's
  title `Text` (its style, the bar's 1.34x title-scale cap), the leading
  button and the title spacing, and the width the bar gives its actions.
  0.8.0's fixed rule (fold above 1.5x) dropped words where there was room:
  Lilt's lone "Undo" folded at 3.0 although it fit.
- **Long titles.** A title that cannot be whole even with every command
  folded ellipsizes regardless, so the row then folds only to keep the
  title `OhBarActions.minTitleShare` (30%) of the bar, instead of folding
  every word for nothing. Found on Trellis's reader, whose book titles
  folded every command at 1.3x under the first cut of this rule.
- The fixed rule remains the fallback for a command outside a row and for
  a title that is not a plain `Text` (pass `titleReserve:` instead).
- `OhBarFoldable(worded:, folded:)` lets a custom bar face join the rule.
  Both faces stay built; only the shown one is painted, hit-tested,
  focusable, seen by screen readers and "onstage" to finders.
- **Removed:** `OhBarActions.foldsIn` (replaced by `OhBarActions.inRow`).
- **Consumer work:** wrap each bar's actions in one `OhBarActions` to get
  the space rule; bars that fold at 3x in 0.8.0 may now keep words, so bar
  goldens at 2x and 3x can move.
- `contrast_test` now measures the bar ink (word and glyph, as rendered)
  on the bar in all three themes, at rest and scrolled under. All clear
  4.5:1; a seeded pale foreground fails at 2.2:1.

## 0.8.0

Top-bar commands (operator ruling: top-bar actions are icon + short label).
Reckon, Trellis and StillLife each grew a labelled bar-action widget, and
Lilt, porch and Bulwark did similar things inline; this is the shared one.

- `OhBarAction`: icon plus a short visible label, a tooltip, one
  screen-reader name in both modes (`semanticLabel` overrides the label),
  enabled state, 48 dp minimum target. Neutral ink (the bar's icon colour).
- **The collapse rule:** the word shows up to and including 1.5x text; above
  that the command folds to its icon, the word moving into the tooltip and
  the screen-reader name. Exposed as `OhBarAction.labelMaxScale`,
  `collapsesAt(TextScaler)` and `collapsed(context)`. Tests hold a title
  plus three controls whole at 320 dp × 3.0 in a real `AppBar`, and the
  words visible at 360 dp × 1.0/1.3/1.5.
- `OhBarActions`: the bar's row. Other words in it stop growing at 2x.
- `OhBarOverflow<T>`: the worded "More" menu, a drop-in for
  `PopupMenuButton` that folds by the same rule.
- **Behaviour change:** `OhThemeToggle` inside an `OhBarActions` row now
  folds to its icon above 1.5x (name and tooltip "Theme: …"). Outside a
  bar row it is unchanged.
- **Consumer work:** apps with a local `BarAction`/`BarActions` copy move to
  these and delete theirs. The copies differed in ink (`onSurface` vs the
  bar's icon colour), padding and minimum size; the shared one uses the
  icon colour, 8 dp side padding and 48 × 48, so bar goldens can move.

## 0.7.2

- `OhErrorState`'s details text used `bodySmall.copyWith(fontFamily:
  'JetBrains Mono')`, a face no app bundles. Since 0.7.1 the themed style
  also carries `package: 'openhearth_design'`, so it actually asked for
  `packages/openhearth_design/JetBrains Mono`. Either way it rendered in
  whatever the engine fell back to. It now uses `OhTypography.code()`, the
  ladder's platform-monospace code face (13/1.4), and a test holds the family
  to the bundled faces or `monospace`.

## 0.7.1

Package fonts (operator ruling on the 0.7.0 rollout item).

- `pubspec.yaml` declares the canonical OFL faces in `fonts/` as package
  fonts: Lora 400, 400 italic, 500, 700 and Nunito 400, 500, 600, 700, the
  only faces that exist.
- Every `OhTypography` style (role methods and `materialTextTheme`) passes
  `package: 'openhearth_design'`, so `fontFamily` is now
  `packages/openhearth_design/Lora` / `packages/openhearth_design/Nunito`.
  Any dependent app renders the same type offline with no font files of
  its own. `code()` still uses platform `monospace`.
- **Backward compatible.** An app that still bundles its own Lora/Nunito
  keeps building and rendering; those copies are no longer read by
  `OhTypography` and only add about 370 KB. Pixels don't change, since the
  files are byte-identical fleet-wide and every consumer's own block declared
  all eight faces (checked at release). Every dependent now ships the package
  faces, including apps that don't use `OhTypography` (Lullaby).
- **Consumer work:** tests that pin `fontFamily == 'Lora'`/`'Nunito'` on an
  `OhTypography`/`OhTheme` style must expect the prefixed name. To drop an
  app's copies, remove its pubspec font block and files, and give any
  app-local `fontFamily: 'Lora'` a `package: 'openhearth_design'` (or use
  an `OhTypography` style). See the README migration note. Wait for C7 to
  learn package fonts before removing the copies.
- Tests: `font_bundle_test` checks each declared `weight:`/`style:` against
  the file's OS/2 table and requires the package prefix.
  `package_font_render_test` proves by layout width, plus a golden, that
  styles render in the package font and not the test fallback.

## 0.7.0

The token pass from the fleet audit (roadmap items 14, 15, 16). Every change
below alters how consuming apps render; app goldens need re-approval
(operator-approved). Apps are not changed by this release.

### Colour: warmth, urgency, pointing-out

Adopts the colour language in `research-notes/2026-09-26-colour-language.md`.
The brand and the error red were 1.13:1 apart (grey-identical) and the error
failed contrast on every dark ground. Now warmth (OKLCH hue 42) and urgency
(hue 22) are separate roles, urgency always travels with an icon and a word,
and chrome is neutral.

- Add `OhColorRoles`, a `ThemeExtension` attached by every `OhTheme` builder
  (`OhColorRoles.of(context)`): warmth, warmthPressed, onWarmth, urgency,
  onUrgency, urgencySurface, warningText, warningIcon, warningSurface,
  success, successSurface, attention, onAttention, attentionSurface, info,
  textPrimary, textSecondary, textLabel, icon, controlBorder. A theme not
  built by `OhTheme` gets `hearthDark` roles when dark and `light` otherwise;
  apps with their own `ThemeData` should attach the instance via
  `extensions:`.
- `showOhConfirm(destructive: true)` now carries `Icons.report_outlined` on
  the confirm button (`FilledButton.icon`; find it with
  `find.bySubtype<FilledButton>()`).
- Add `test/contrast_test.dart`: WCAG ratios for every pair the built themes
  wire, against scaffold, card and raised container: 4.5:1 text, 3:1 marks,
  no exceptions.

Token value changes (same name, new hex):

| Token | Old | New | Note |
|---|---|---|---|
| `hearth400` | `#C47B6A` | `#CD8366` | hearthDark primary |
| `hearth500` | `#A85040` | `#A4512E` | light primary; `--oh-hearth-500`, `--oh-color-interactive` |
| `hearth600` | `#8B3E2F` | `#893F21` | light pressed |
| `red500` | `#B0382A` | `#9B1D29` | light urgency only now |
| `red100` | `#F5DDD9` | `#FFE7E6` | light urgency surface |
| `amber100` | `#F5E9C8` | `#FCEDCD` | light warning surface |

New tokens: `red300 #FF939C`, `amber300 #E7B551`, `amber500 #AD7C1D`,
`amber700 #805307` (the note's warning icon `#AD7C1D` was darkened to `#A0701A` to clear 3:1 on `linen200`), `sage300 #7DBB9A`, `sage700 #386D54`, `slate200 #8FB4E4`,
`slate600 #39659B`, `successSurface #E1F4E9`, `attentionSurface #E4F0FF`,
`darkUrgencySurface #4B1D1F`, `darkWarningSurface #3E2D10`,
`darkSuccessSurface #1B3427`, `darkAttentionSurface #202F42`,
`nightUrgencySurface #421B1C`, `nightWarningSurface #37290F`,
`nightSuccessSurface #192E23`, `nightAttentionSurface #1D2A3A`,
`nightBorderControl #76767F`. Mirrored in `tokens.css` / `tokens.ts`.

Theme slot changes:

| Slot | Theme | Old | New |
|---|---|---|---|
| `colorScheme.error` | hearthDark, night | `red500` | `red300` |
| `colorScheme.onError` | hearthDark / night | white | `linen900` / `nightSurfaceBase` |
| `colorScheme.errorContainer` | hearthDark / night | `red500` | `darkUrgencySurface` / `nightUrgencySurface` |
| `colorScheme.onErrorContainer` | hearthDark, night | `linen100` / `nightTextPrimary` | `red300` |
| `iconTheme.color` | all | `primary` | `colorScheme.onSurfaceVariant` |
| input `hintStyle` | light / hearthDark | `linen400` / `linen500` | `linen600` / `linen400` |
| input `labelStyle` | light / hearthDark | `linen500` / `linen400` | `linen700` / `linen300` |
| input border | light / hearthDark / night | `linen300` / `darkBorderSubtle` / `nightBorder` | `linen500` / `linen500` / `nightBorderControl` |
| slider inactive track | light | `primary` @ 18% | `linen300` |
| `listTileTheme` | all | Material default | `listTitle` / `listSubtitle` |

CSS semantic tokens: `--oh-color-text-tertiary` light `linen-500` → `linen-600`,
dark → `linen-400`; `--oh-color-success` light `sage-500` → `sage-700`; the dark
block now overrides `--oh-color-error` (`red-300`) and `--oh-color-success`
(`sage-300`). New: `--oh-color-icon`, `--oh-color-border-control`,
`--oh-color-on-error`, `--oh-color-error-surface`, `--oh-color-warning-text`,
`--oh-color-warning-icon`, `--oh-color-warning-surface`,
`--oh-color-success-surface`, `--oh-color-attention`,
`--oh-color-attention-surface`, `--oh-color-info`, `--oh-color-text-link`.

Migration for apps (by what the code does, not by name):

| App code today | Use instead |
|---|---|
| `linen500` / `linen400` as text on light | `roles.textSecondary` (`linen600`) |
| `amber400` for warning text or icons | `roles.warningText` / `roles.warningIcon` |
| `sage500` / `sage600` as success text | `roles.success` |
| `slate500` for links | `roles.attention` |
| `red500` on a dark theme | `colorScheme.error` or `roles.urgency` |
| `colorScheme.primary` on a destructive or error element | `roles.urgency` + an icon + a word |
| a plain `Icon` relying on the accent colour | pass `color:` explicitly if it is the primary action |
| `appAccent: hearth300` (Lilt) or a slate accent | check ≥ 0.08 ΔE_ok from urgency/attention (colour rule 6) |

### Type ladder

- One ladder, `OhTypography.ladder` = 13/16/19/23/28/33/40/48/57 (~1.2 steps,
  none within 2 px). `test/type_ladder_test.dart` pins every style on it.
- Add `listTitle()` (16 w600) and `listSubtitle()` (13 w400), wired into
  `listTileTheme`.
- `OhTheme` text theme: `labelMedium` is now `label` (it was `caption`, the
  same as `labelSmall`).
- `code()` asks for platform `monospace`; no JetBrains Mono file exists in the
  fleet.

| Role | Old size/weight | New size/weight |
|---|---|---|
| `display` | 48/700 h1.333 | 48/700 h1.15 |
| `headline1` | 36/700 | 40/700 |
| `headline2` | 30/700 | 33/700 |
| `headline3` | 24/700 | 28/700 |
| `headline4` | 20/700 | 23/700 |
| `title` | 20/700 | 23/700 |
| `titleSm` | 18/600 | 19/600 |
| `bodyLg` | 18/400 h1.556 | 19/400 h1.4 |
| `body` | 16/400 h1.5 | 16/400 h1.4 |
| `bodySm` | 14/400 | 13/400 |
| `label` | 14/500 | 13/600 |
| `labelSm` | 12/500 | 13/700 |
| `caption` | 12/400 | 13/400 |
| `button` | 16/600 h1.5 | 16/600 h1.25 |
| `buttonSm` | 14/600 | 13/600 |
| `code` | JetBrains Mono 14 | monospace 13 |

`materialTextTheme` (Sundial, Furrow, Glass, Bulwark):

| Slot | Old | New |
|---|---|---|
| displayLarge | Lora 57/700 | Lora 57/700 |
| displayMedium | Lora 45/700 | Lora 48/700 |
| displaySmall | Lora 36/700 | Lora 40/700 |
| headlineLarge | Lora 32/700 | Lora 33/700 |
| headlineMedium | Lora 28/**600** | Lora 28/700 |
| headlineSmall | Lora 24/**600** | Lora 23/700 |
| titleLarge | Nunito 22/700 | Nunito 19/700 |
| titleMedium | Nunito 16/600 | Nunito 16/600 |
| titleSmall | Nunito 14/600 | Nunito 13/700 |
| bodyLarge | Nunito 16 | Nunito 19 |
| bodyMedium | Nunito 14 | Nunito 16 |
| bodySmall | Nunito 12 | Nunito 13 |
| labelLarge | Nunito 14/600 | Nunito 16/600 |
| labelMedium | Nunito 12/500 | Nunito 13/600 |
| labelSmall | Nunito 11/500 | Nunito 13/500 |

The byte-equality constraint on `materialTextTheme` is lifted; Sundial's
`design_sync_test` and Furrow's `text_theme_identity_test` pin the old block
and will fail until those apps re-approve.

### Fonts

- The canonical files now live in `openhearth_design/fonts/` (Lora 400,
  400 italic, 500, 700; Nunito 400, 500, 600, 700; `OFL.txt`), not declared
  as package assets. `test/font_bundle_test.dart` reads each file's OS/2
  weight and italic bit and fails if any style names a face with no file.
- **No Lora 300 or 600 and no Nunito italic file exists in the fleet.** The
  two Lora w600 requests are gone; Lilt's local `FontWeight.w300` requests
  (and any app-local w600 on Lora) are app rollout items. Nunito italic is
  not bundled (Trellis).

### OhPage

- A mouse wheel over the side margins now scrolls the content (forwarded to
  the first vertical scrollable in `child`); over the content it scrolls
  once. Trackpad pan over the margins is not forwarded. `OhPage` is now a
  `StatefulWidget`; its constructor is unchanged.

## 0.6.0

Shared widgets for behaviour the fleet audit (2026-09-16) found drifting or
missing across the apps.

- Add `OhErrorState` and `ohFriendlyErrorMessage` (`lib/src/error_state.dart`).
  Fifteen apps rendered raw exceptions as their failure state. The widget
  shows a title, a plain sentence and an optional Retry, and reveals the
  technical error only behind Details. The dart:io exceptions are classified
  behind a conditional import so the package still compiles for web.
- Add the delete policy primitives (`lib/src/delete_policy.dart`):
  `showOhConfirm` for easy-gesture deletes (label must name the act; danger
  styling opt-in) replacing five drifting `showConfirmDialog` copies, and
  `OhUndoController` / `OhUndoBar` for deliberate deletes. The Undo bar has
  no timer, per the operator ruling that an expiring Undo strands people.
  Apps supply the soft delete; the contract is in the README.
- Add `OhThemeModePreference` (system / light / dark, default system) and
  `OhThemeToggle` (`lib/src/theme_mode.dart`). Four apps mapped a bool to
  `ThemeMode.light`/`.dark`, so following the phone was unreachable. The
  toggle is icon plus short label for the app bar and either opens a
  three-choice menu or cycles. Storage stays in the apps. The README's
  "Use the theme" now wires `darkTheme` + `themeMode`, superseding the
  single-theme-no-themeMode advice.
- Add `OhPage` (`lib/src/page.dart`), the centred live area. Ten apps
  stretched their phone layout edge to edge at 1024 px and seven reached
  for `ConstrainedBox` ad hoc. Default cap 640 dp for phone-shaped screens,
  configurable, with safe area and a 16 dp gutter.

## 0.5.0

Add `OhIconButton.filled` / `OhIconButton.filledTonal` (`lib/src/icon_buttons.dart`).
`OhTheme`'s app-wide `iconTheme.color = primary` collides with Flutter
3.38.7's `IconButton.filled`/`.filledTonal`: the ambient color resolves
above the button's own default foreground, so an unstyled filled icon
button paints its glyph in `primary` — the same color as its own fill,
i.e. invisible (reported as "blank circles" from a Trellis device test).
`OhIconButton` pins the correct foreground (`onPrimary` /
`onSecondaryContainer`) at the widget level, the one style layer that
outranks the ambient theme, while passing every other parameter through
and letting a caller-supplied `style` still win. Dropping the app-wide
`iconTheme` instead would be the tidier fix but restyles every plain icon
in every consuming app, so it's deferred as its own decision, not folded
into this one.

## 0.4.0

Add `OhTypography.materialTextTheme` — the Material-scale `TextTheme` ladder
(Lora display/headline 57/45/36/32/28/24, Nunito title/body/label 22–11) that
Sundial, Furrow, Glass, and Bulwark each hand-rolled as a byte-identical
`const TextTheme` in their own `app_theme.dart`. Moving the block into the
package verbatim lets the four copies die with zero visual change: it must
stay byte-equal to what those apps rendered before adoption, so their goldens
stay green when they switch to importing it. It is deliberately distinct from
the role-method ladder (`display`/`headline1`/…), which carries different
sizes plus letterSpacing/height — the two must not be unified.

## 0.3.0

Initial open-source release: colors, spacing, radii, typography roles,
elevation, motion, and the tri-theme (light / hearthDark / night).
