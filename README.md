# ohStyle — OpenHearth Design System

Shared visual language for the OpenHearth app portfolio. One source of truth, three consuming artifacts.

## What's here

```
ohStyle/
  openHearthStyleGuide.md     ← source of truth — edit this first
  openhearth_design/          ← Flutter/Dart package (all mobile apps)
  openhearth_tokens/          ← CSS + TypeScript tokens (Glean, website)
```

## openhearth_design — Flutter package (v0.4)

Provides `OhColors`, `OhSpacing`, `OhRadii`, `OhTypography`, `OhElevation`,
`OhMotion`, and `OhTheme` as `abstract final` classes with static members.
No instantiation needed.

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

**Required: bundle the fonts.** v0.2 dropped `google_fonts` so the package
never fetches from Google's CDN — that was a privacy-posture concession.
Each consuming app must declare `Lora` and `Nunito` (and optionally
`JetBrains Mono`) in its own `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Lora
      fonts:
        - asset: assets/fonts/Lora-Regular.ttf
        - asset: assets/fonts/Lora-Italic.ttf
          style: italic
        - asset: assets/fonts/Lora-Medium.ttf
          weight: 500
        - asset: assets/fonts/Lora-Bold.ttf
          weight: 700
    - family: Nunito
      fonts:
        - asset: assets/fonts/Nunito-Regular.ttf
        - asset: assets/fonts/Nunito-Medium.ttf
          weight: 500
        - asset: assets/fonts/Nunito-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Nunito-Bold.ttf
          weight: 700
```

Download the OFL-licensed TTFs from Google Fonts once and check them in.
Reckon's `assets/fonts/` is the reference copy.

### Use the theme

```dart
import 'package:openhearth_design/openhearth_design.dart';

// Three themes — user picks in Settings; app persists the choice.
// See CLAUDE.md for how to wire up a ThemePreference provider.
final theme = switch (userThemePreference) {
  ThemePreference.light      => OhTheme.light(),
  ThemePreference.hearthDark => OhTheme.hearthDark(),  // warm dark
  ThemePreference.night      => OhTheme.night(),       // neutral dark
};

MaterialApp(
  theme: theme,
  // ...
)
```

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

### Typography roles

| Method | Font | Size | Weight | Use |
|--------|------|------|--------|-----|
| `display()` | Lora | 48 | 700 | Hero text |
| `headline1()` | Lora | 36 | 700 | Section header |
| `headline2()` | Lora | 30 | 700 | Section header |
| `headline3()` | Lora | 24 | 700 | Section header |
| `headline4()` | Lora | 20 | 700 | Section header |
| `title()` / `titleSm()` | Nunito | 20/18 | 700/600 | Card titles, app bars |
| `bodyLg()` / `body()` / `bodySm()` | Nunito | 18/16/14 | 400 | Content text |
| `label()` / `labelSm()` | Nunito | 14/12 | 500 | Form labels, tags |
| `caption()` | Nunito | 12 | 400 | Annotations |
| `button()` / `buttonSm()` | Nunito | 16/14 | 600 | Button labels |
| `code()` | JetBrains Mono | 14 | 400 | Numeric display (Glean only) |

All methods accept an optional `Color? color` override.

### Material TextTheme ladder (v0.4)

`OhTypography.materialTextTheme` is a `const TextTheme` covering the full
Material scale (Lora display/headline 57–24, Nunito title/body/label 22–11).
It replaces the byte-identical hand-rolled `_textTheme` blocks that Sundial,
Furrow, WeatherGlass, and Bulwark each carried in their own `app_theme.dart`:

```dart
ThemeData(
  textTheme: OhTypography.materialTextTheme,
  // ...
)
```

It is constrained to stay **byte-equal to what those apps rendered before
adoption** (each entry sets only fontFamily/fontSize/fontWeight — no
letterSpacing/height), so the apps' goldens stay green when they delete
their copies. It is deliberately distinct from the role-method ladder
above, which carries different sizes plus letterSpacing/height — the two
must not be unified.

### Run tests

```bash
cd openhearth_design
flutter test
```

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

const primary = OhColors.hearth500; // '#A85040'
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
| Hearth | 50–900 | Primary brand (terracotta). Default interactive color. |
| Linen | 50–900 | Warm neutrals. Backgrounds, text, borders. |
| Sage | 100–600 | Nature/success. Sundial accent. |
| Slate | 100–700 | Informational/calm. |
| Amber | 100/400 | Warning states. |
| Red | 100/500 | Error states. |
| Dark surfaces | 6 tokens | Dark mode backgrounds and borders. |
