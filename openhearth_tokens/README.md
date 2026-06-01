# openhearth_tokens

Cross-platform design token files for the OpenHearth portfolio.

These files mirror the token values defined in `openHearthStyleGuide.md` and the Dart package `openhearth_design`. They exist so non-Flutter projects (Glean's React frontend, the Astro website) can consume the same tokens without depending on Dart tooling.

## Files

| File | Purpose |
|------|---------|
| `tokens.css` | CSS custom properties (`--oh-*`) for Astro and Glean's `index.css` |
| `tokens.ts` | TypeScript `const` objects for type-safe references in React components |

## Usage

**Astro site** — in your global stylesheet:
```css
@import '../../packages/openhearth_tokens/tokens.css';
```

**Glean (React)** — in `src/index.css`:
```css
import '../../packages/openhearth_tokens/tokens.css';
```

**Glean (TypeScript)** — in components:
```ts
import { OhColors, OhSpacing } from '../../packages/openhearth_tokens/tokens';
```

Both projects reference the files in-place via relative path — no build step, no copy, no symlink needed.

## Sync discipline

These files are maintained manually. When tokens change, update all four places:
1. `openHearthStyleGuide.md` — source of truth
2. `packages/openhearth_design/lib/src/colors.dart` — Dart/Flutter
3. `packages/openhearth_tokens/tokens.css` — CSS
4. `packages/openhearth_tokens/tokens.ts` — TypeScript
