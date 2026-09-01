# ohStyle — OpenHearth Design System

Shared visual language for the OpenHearth app portfolio. One source of truth, three consuming artifacts.

## What's here

```
ohStyle/
  openHearthStyleGuide.md     ← source of truth — edit this first
  openhearth_design/          ← Flutter/Dart package (all mobile apps)
  openhearth_tokens/          ← CSS + TypeScript tokens (Glean, website)
```

## openhearth_design — Flutter package (v0.9)

Provides `OhColors`, `OhSpacing`, `OhRadii`, `OhTypography`, `OhElevation`,
`OhMotion`, and `OhTheme` as `abstract final` classes with static members.
No instantiation needed. `OhColorRoles` (v0.7) is the colour language as a
`ThemeExtension` — see "Colour roles" below.

`OhTheme` exposes **three** themes — `light()`, `hearthDark()` (warm dark,
evening), and `night()` (neutral high-contrast, deep reading). See
`CLAUDE.md` for the tri-theme rationale and adoption checklist.

### Add to a Flutter app

In your app's `pubspec.yaml`:

```yaml
dependencies:
  openhearth_design:
    path: ../../ohStyle/openhearth_design
```

**Fonts come with the package (v0.7.1).** `openhearth_design` declares the
canonical OFL Lora and Nunito files in `openhearth_design/fonts/` as package
fonts, and every `OhTypography` style (role methods and
`materialTextTheme`) passes `package: 'openhearth_design'`. The path
dependency above is all an app needs: the faces register as
`packages/openhearth_design/Lora` and `packages/openhearth_design/Nunito`,
render offline, and never touch Google's CDN (`google_fonts` stays banned).

The declared faces are exactly the files that exist: Lora 400, 400 italic,
500, 700; Nunito 400, 500, 600, 700. **No Lora 300 or 600 and no Nunito
italic exist in the fleet**, so don't request them.
`test/font_bundle_test.dart` fails if a style asks for a face with no file,
or if a pubspec `weight:`/`style:` line disagrees with the file's own OS/2
table. `test/package_font_render_test.dart` proves the styles lay out in the
package font rather than the test fallback.

#### Migrating an app off its own font copies

An app that still bundles its own `Lora`/`Nunito` keeps building and
rendering. `OhTypography` no longer reads those families, so the copies are
dead weight: about 370 KB shipped twice. To drop them:

1. **Remove the app's `flutter: fonts:` block** for Lora and Nunito from its
   `pubspec.yaml`, and delete the files in `assets/fonts/`.
2. **Find every place the app names a family itself**:
   `grep -rnE "['\"](Lora|Nunito)['\"]" lib test`. That covers
   `TextStyle(fontFamily: 'Lora')`, `ThemeData(fontFamily: 'Nunito')`, and
   families routed through a constant (`static const _serif = 'Lora'`).
   Either use an `OhTypography` style or `copyWith` from one, or add
   `package: 'openhearth_design'` to the `TextStyle`. For `ThemeData`, use
   `fontFamily: 'packages/openhearth_design/Nunito'`. A bare `'Lora'` left
   behind renders in the platform font once the copy is gone.
3. **Update tests that pin the family string.** Expect
   `'packages/openhearth_design/Lora'` wherever `'Lora'` was expected from an
   `OhTypography`/`OhTheme` style. That applies from 0.7.1 whether or not the
   copies are removed.
4. **Goldens need no change.** The canonical `flutter_test_config.dart`
   (`oh_fleet_conformance` C6) loads every FontManifest family under its
   manifest name, and package fonts are listed there already prefixed.
   Removing the app copies doesn't change pixels, because the files are
   byte-identical fleet-wide and every consumer's block declared all eight
   faces at 0.7.1. An app whose block left out a weight would see
   `OhTypography` text move to the true face.
5. **C7 (bundled-font cmap check)** reads only the app's own pubspec today.
   An app that removes its copies will get "no bundled font families
   declared" until C7 learns about package fonts, so hold the removal until
   then.

### Use the theme

The person picks **light, dark, or follow phone**; the default is follow
phone. `OhThemeModePreference` is the value type, `OhThemeToggle` the
app-bar control. The app stores the choice (see
[Theme control](#theme-control--ohthememodepreference-ohthemetoggle)).

```dart
import 'package:openhearth_design/openhearth_design.dart';

MaterialApp(
  theme: OhTheme.light(),
  darkTheme: OhTheme.hearthDark(),   // or OhTheme.night(): the app's pick
  themeMode: pref.themeMode,         // OhThemeModePreference, default system
  // ...
)
```

Each app chooses which of the two dark themes is its "Dark": `hearthDark()`
(warm, evening) or `night()` (neutral, deep reading). Apps that already
offer all three as a Settings picker (Reckon, Glean) keep that picker; the
toggle covers the light/dark/phone axis.

Per-app accent color (every app in the portfolio gets one dominant accent):

```dart
// Lullaby uses sage; all other tokens stay hearth-palette
theme: OhTheme.light(appAccent: OhColors.sage500),
// Accent flows through all three themes:
theme: OhTheme.hearthDark(appAccent: OhColors.sage500),
theme: OhTheme.night(appAccent: OhColors.sage500),
```

### Use tokens directly

```dart
Container(
  color: OhColors.linen50,
  padding: OhSpacing.insetMd,
  decoration: BoxDecoration(borderRadius: OhRadii.lg),
  child: Text('Hello', style: OhTypography.body()),
)
```

### Elevation

Four shadow ramps (light + dark variants) for cards, FABs, dialogs, and overlays:

```dart
Container(decoration: BoxDecoration(
  boxShadow: OhElevation.raised,     // resting cards
  // OhElevation.floating             // FABs, toasts
  // OhElevation.modal                // bottom sheets, dialogs
  // OhElevation.overlay              // menus, tooltips
));
```

Shadows are warm-tinted (linen-900) in light mode, pure black in dark mode.

### Motion

Durations and easings:

```dart
AnimatedContainer(
  duration: OhMotion.standard,      // 240ms — route/card transitions
  curve: OhMotion.standardCurve,
  ...
)
```

`instant` (80ms) · `fast` (160ms) · `standard` (240ms) · `deliberate` (400ms).

### Colour roles (v0.7)

The colour language (style guide §2.3): **warmth** (brand, the one primary
action), **urgency** (error, destructive — always colour + icon + word),
**warning**, **attention** (selection, focus, links — always with a shape),
**success**, and neutral chrome. Every `OhTheme` builder attaches the
matching `OhColorRoles`:

```dart
final roles = OhColorRoles.of(context);
Row(children: [
  Icon(Icons.report_outlined, color: roles.urgency),
  Text("Couldn't save", style: TextStyle(color: roles.urgency)),
]);
```

Apps that build their own `ThemeData` (Sundial, Furrow, Glass, Bulwark)
should attach the roles themselves: `ThemeData(extensions: [OhColorRoles.light])`
and the dark instance on their dark theme. Without one, `of` picks
`hearthDark` for a dark theme and `light` otherwise.

Warmth never paints anything destructive or failed; icons and chrome are
neutral (`iconTheme` is `onSurfaceVariant` since v0.7). Every role clears
4.5:1 (text) or 3:1 (marks) on its theme's grounds; `test/contrast_test.dart`
measures every pair.

### Typography roles

One ladder, `OhTypography.ladder`: 13 / 16 / 19 / 23 / 28 / 33 / 40 / 48 /
57, a ~1.2 step from a 16 px body, no two sizes within 2 px. Roles that
share 13 px differ by weight.

Every Lora/Nunito style resolves to the package font
(`packages/openhearth_design/<Family>`).

| Method | Font | Size | Weight | Use |
|--------|------|------|--------|-----|
| `display()` | Lora | 48 | 700 | Hero text |
| `headline1()` | Lora | 40 | 700 | Section header |
| `headline2()` | Lora | 33 | 700 | Section header |
| `headline3()` | Lora | 28 | 700 | Section header |
| `headline4()` | Lora | 23 | 700 | Section header |
| `title()` / `titleSm()` | Nunito | 23/19 | 700/600 | Card titles / app bars |
| `bodyLg()` / `body()` / `bodySm()` | Nunito | 19/16/13 | 400 | Content text |
| `label()` / `labelSm()` | Nunito | 13 | 600/700 | Form labels, tags / section labels |
| `caption()` | Nunito | 13 | 400 | Annotations |
| `button()` / `buttonSm()` | Nunito | 16/13 | 600 | Button labels |
| `listTitle()` / `listSubtitle()` | Nunito | 16/13 | 600/400 | List rows (wired into `listTileTheme`) |
| `code()` | platform `monospace` | 13 | 400 | Code, numeric display |

All methods accept an optional `Color? color` override. Body leading is 1.4.

### Material TextTheme (v0.7: on the ladder)

`OhTypography.materialTextTheme` is the `const TextTheme` Sundial, Furrow,
WeatherGlass and Bulwark build their own `ThemeData` from:

```dart
ThemeData(
  textTheme: OhTypography.materialTextTheme,
  // ...
)
```

Each entry still sets only fontFamily/fontSize/fontWeight (no
letterSpacing/height). Since v0.7 each Material slot takes the nearest
ladder step instead of the stock Material size, and the headlines ask for
Lora 700 instead of the unbundled 600. That changes those four apps'
rendering (notably `bodyMedium` 14 → 16); see the CHANGELOG mapping.

### Shared widgets (v0.6)

Behaviour every app needs the same way, so it lives here once instead of
drifting in fourteen copies.

#### Error state — `OhErrorState`

Never put a raw exception on screen (`Text('Error: $e')`, `'$e'` in a
SnackBar). Show a friendly title, one plain sentence, a Retry when the app
can recover, and keep the technical error behind **Details**, where it is
selectable so a person can paste it into a bug report. Log it as well.

```dart
asyncValue.when(
  data: (items) => ItemList(items),
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => OhErrorState.fromError(
    e,
    stackTrace: st,
    title: "Couldn't load your pantry",
    onRetry: () => ref.invalidate(pantryProvider),
  ),
);
```

`ohFriendlyErrorMessage(e)` maps common exceptions to a sentence
(timeouts, network, file, malformed data; anything else gets a generic
line) and never returns the exception text. Use it for SnackBars too. The
sentences are constants on `OhErrorMessages`.

#### Delete policy — `showOhConfirm`, `OhUndoBar`

One rule for the fleet:

- **An easy gesture asks first.** A swipe or long-press that deletes is
  easy to do by accident, so it confirms with `showOhConfirm`.
- **A deliberate delete gets Undo, not a question.** A Delete button or menu
  item the person chose acts at once and offers Undo in an `OhUndoBar`.
  That Undo **never expires on a timer**: it stays until the person taps
  Undo, closes it, deletes something else, or leaves the screen. Do not use
  a SnackBar for this; SnackBars time out and strand the person.

```dart
// Easy gesture: Dismissible's confirmDismiss.
confirmDismiss: (_) => showOhConfirm(
  context,
  title: 'Delete "Soup"?',
  message: 'It moves to Recently deleted.',
  confirmLabel: 'Delete recipe',   // names the act; "OK"/"Delete" assert
  destructive: true,               // danger styling is opt-in
),

// Deliberate delete: act, then offer Undo.
await repo.softDelete(ids);
undo.show(
  message: 'Deleted ${ids.length} items',
  onUndo: () => repo.restore(ids),
);
// ...and somewhere at the bottom of the screen:
OhUndoBar(controller: undo),
```

`showOhConfirm` keeps the parameter names of the five `showConfirmDialog`
copies it replaces (`title`, `message`, `confirmLabel`, `confirmColor`), so
migration is a rename plus a real label. The differences: `confirmLabel` is
required and must name the act ("Delete 3 items", not "Delete"); the button
is neutral unless `destructive: true`; `confirmColor` still overrides the
danger colour for apps whose palette forbids red (Peckish, Bulwark). It
returns `false` for Cancel, the barrier and back. It is deliberately not
exported as `showConfirmDialog`, so apps can import the package before
deleting their own copy.

**The soft-delete contract an app must implement** (the widgets cannot do
it for you):

1. Every deletable table has a nullable `deletedAt` timestamp. Delete sets
   it; nothing is removed from disk.
2. Every normal query filters `deletedAt IS NULL`.
3. `restore` clears `deletedAt` (and, in a synced app, bumps the row's
   modified time / HLC so the restore wins last-writer-wins merge instead
   of losing to the tombstone).
4. There is a lasting way back after the bar is gone: a **Recently deleted**
   list per app, reachable from Settings or the list's overflow menu, with
   Restore and "Delete forever". Deleting forever is the one hard delete; it
   goes through `showOhConfirm(destructive: true)`.
5. If the app purges old tombstones automatically, the Recently deleted
   screen says when ("Items are removed after 30 days"). Copy never claims
   "this can't be undone" over a soft delete.
6. `onCommit` is optional. With a soft delete it is usually empty: the offer
   lapsing does not mean the data goes.

#### Theme control — `OhThemeModePreference`, `OhThemeToggle`

Theme is light, dark, or follow phone, and must be one tap (at most two)
from anywhere, so the control lives in each primary screen's app bar as an
icon plus a short label. Settings may repeat it; it must not be the only
home.

```dart
AppBar(
  title: const Text('Pantry'),
  actions: [
    OhThemeToggle(
      value: pref,                                  // from the app's store
      onChanged: (p) => ref.read(themePrefProvider.notifier).set(p),
    ),
  ],
)
```

The default behaviour opens a three-choice menu (two taps, every choice
named). `behavior: OhThemeToggleBehavior.cycle` steps system, light, dark on
each tap for bars with no room for a menu. Persist `pref.storageValue` and
read it with `OhThemeModePreference.fromStorage(stored)`, which returns the
default (follow phone) for anything missing or unknown. Apps migrating
from an `isDarkMode` bool decide for themselves whether a stored `false`
meant "light" or "never chosen".

#### Page width — `OhPage`

Phone-shaped layouts stretched across a tablet or a 1024 px browser read as
broken. Wrap each screen's body in `OhPage`: content capped at 640 dp by
default, centred, top-aligned, inside the safe area, with a 16 dp side
gutter. App bars, bottom bars and backgrounds stay full width.

```dart
Scaffold(
  appBar: AppBar(title: const Text('Pantry')),
  body: OhPage(child: ListView(children: rows)),
)
```

`OhPage.proseMaxWidth` (720) suits reading pages and `OhPage.wideMaxWidth`
(960) charts, matching style guide §4.3; pass any `maxWidth` you need.

On desktop and web a mouse wheel over the side margins scrolls the content:
`OhPage` forwards it to the first vertical scrollable inside `child`. Over
the content the child's own scrollable takes the wheel, so nothing scrolls
twice. Trackpad pan over the margins is not forwarded.

#### Top-bar commands — `OhBarAction`, `OhBarActions`, `OhBarOverflow` (v0.8)

The fleet ruling on top bars: **icon plus a short visible label; rare
actions in a worded menu; a tooltip is never a command's only name.**

```dart
AppBar(
  title: const Text('Library'),
  actions: [
    OhBarActions(children: [
      OhBarAction(icon: Icons.filter_alt_outlined, label: 'Filter',
          onPressed: openFilter),
      OhThemeToggle(value: theme, onChanged: setTheme),
      OhBarOverflow<String>(
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'import', child: Text('Import a book')),
        ],
        onSelected: onMore,
      ),
    ]),
  ],
)
```

**The fold rule (v0.9: by space).** Inside `OhBarActions`, words stay on
screen whenever they fit beside a whole title. When the row would squeeze
the title, commands fold one at a time, rightmost first: the word moves
into the tooltip and the screen-reader name and the command shows as its
48 dp icon. The row measures the room the title needs from the enclosing
`AppBar`: the title `Text` in its own style at the bar's 1.34x title-scale
cap, the leading/back button, and the title spacing. So "Lilt" plus a lone
"Undo" keeps the word at 320 dp × 3.0, and a busy bar folds its More menu
before its Filter. `OhThemeToggle`, `OhBarOverflow` and custom faces built
with `OhBarFoldable(worded:, folded:)` fold by the same rule; other words in
the row stop growing at 2x.

- **Long titles** (a book's name) that cannot be whole even with every
  command folded ellipsize whatever the row does, so the row folds only to
  keep the title `OhBarActions.minTitleShare` (30%) of the bar.
- **One row per bar.** Put every action in a single `OhBarActions`; the
  row cannot see siblings outside it.
- **Titles that are not a plain `Text`** (a search field): pass
  `titleReserve:` (the width the title needs), or the row falls back to the
  fixed rule below.
- **The fixed rule (fallback).** Outside a row, or when the title cannot be
  measured, the word shows up to and including 1.5x and folds above it
  (`OhBarAction.collapsesAt`, `OhBarAction.collapsed(context)`).
- **Name.** A screen reader hears one button named `label` (or
  `semanticLabel`, when the short word is ambiguous out of context) in both
  modes, with its enabled state and tap action.
- **Target.** At least 48 × 48 dp in both modes.
- **Ink.** Neutral: the bar's icon colour, the same as `OhThemeToggle`.
  Warmth is for the screen's one primary action.
- **Room.** Folding keeps the title whole, but a folded command is only a
  glyph and a tooltip. Keep bars to two or three commands and put rare ones
  in `OhBarOverflow`.
- **Ink contrast** is tested: the word and glyph clear 4.5:1 on the bar in
  all three themes, at rest and scrolled under (`test/contrast_test.dart`).
- `OhBarOverflow<T>` takes `PopupMenuButton`'s `itemBuilder` and
  `onSelected`; its face reads "More" (`label:` to change it).

### Run tests

```bash
cd openhearth_design
flutter test
```

`contrast_test.dart`, `type_ladder_test.dart` and `font_bundle_test.dart`
are the token checks: WCAG ratios for every themed pair, the ladder's
steps, and a bundled file for every requested face.

## openhearth_tokens — CSS & TypeScript

Static token files for non-Flutter consumers. No build step required — reference in place.

### Glean (React + TypeScript)

In `src/index.css`:
```css
@import '../../../ohStyle/openhearth_tokens/tokens.css';
```

In components:
```ts
import { OhColors, OhSpacing, OhRadii, OhFonts } from '../../../ohStyle/openhearth_tokens/tokens';

const primary = OhColors.hearth500; // '#9E4D2C'
```

### Astro website

In your global stylesheet:
```css
@import '../../ohStyle/openhearth_tokens/tokens.css';
```

CSS custom properties are available everywhere:
```css
.card {
  background: var(--oh-color-surface);
  color: var(--oh-color-text-primary);
  border-radius: var(--oh-radius-lg);
  padding: var(--oh-space-md);
}
```

Dark mode is handled automatically via `@media (prefers-color-scheme: dark)`.

## Keeping tokens in sync

When a token value changes, update **all four places** in this order:

1. `openHearthStyleGuide.md` — source of truth
2. `openhearth_design/lib/src/colors.dart` — Dart (`OhColors`)
3. `openhearth_tokens/tokens.css` — CSS custom properties
4. `openhearth_tokens/tokens.ts` — TypeScript constants

## Color palette reference

| Family | Range | Purpose |
|--------|-------|---------|
| Hearth | 50–900 | Warmth (brand terracotta, OKLCH hue 42). The one primary action. |
| Linen | 50–900 | Warm neutrals. Backgrounds, text, borders, icons. |
| Sage | 100–700 | Nature/success. Sundial accent; night's accent. |
| Slate | 100–700 | Info (500/700) and attention (600 light, 200 dark). |
| Amber | 100–700 | Warning: 700 text, 500 icon (light); 300 on dark. 400 is legacy. |
| Red | 100/300/500 | Urgency: 500 light, 300 dark/night, 100 surface. |
| Status surfaces | 10 tokens | Tinted containers behind status lines, per theme. |
| Dark surfaces | 6 tokens | Dark mode backgrounds and borders. |
