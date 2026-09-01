# OpenHearth Design System
## Style Guide & Component Library PRD

**Package:** `openhearth_design` (pub.dev) / `@openhearth/design` (npm)  
**Status:** Pre-v1, foundational  
**Owner:** ISS / OpenHearth  
**Applies to:** Lullaby · Porch · StillLife · Sundial · Baby Names · Garner · Glean · future apps

---

## 0. Purpose & Scope

This document is the single source of truth for visual and interaction design across all OpenHearth apps. It is not a Figma spec or a Storybook — it is a PRD for a shared design system library. Every decision here has a "why" attached, because the next developer should be able to re-derive the rules, not just memorize them.

**What this document covers:**
- Design principles
- Color system (primitive palette + semantic tokens + dark mode)
- Typography system (typefaces, scale, usage rules)
- Spacing and sizing
- Elevation and shadow
- Shape and border radius
- Motion and animation
- Iconography
- Core component anatomy
- Platform-specific implementation notes (Flutter, React/PWA, Tauri)
- Voice and microcopy
- Accessibility floor

**What this document does not cover:**
- App-specific layouts or information architecture
- Illustration or photography style (TBD separately)
- Marketing site design (follows same tokens but has more expressive latitude)

---

## 1. Design Principles

These are not aspirational adjectives. They are constraints that resolve real design decisions.

### 1.1 Home-cooked, not mass-produced

Silicon Valley defaults — cold whites, hairline type, flat geometric icons — signal that a product was made at scale for nobody in particular. OpenHearth apps are made for families by people who care about families. The visual language should feel like something a skilled craftsperson made for their household, not something optimized for DAU.

*In practice:* warmer colors than you'd default to, slightly heavier type than you'd default to, illustrations that feel handmade, transitions that feel considered.

### 1.2 Calm over stimulating

Social media apps are engineered to create arousal — variable-reward notifications, aggressive color contrasts, fast transitions, infinite scroll. Our apps live in family life, not instead of it. They should feel like a well-bound journal, not a slot machine.

*In practice:* no red badges except genuine errors, slow deliberate motion, avoid pure black or pure white, no aggressive notification patterns.

### 1.3 Privacy is architecture, not policy

Our security posture (local-first, E2EE, ghost-mode by default) must be visible in the design. The UI should not feel like it's asking for more than it needs. Onboarding should never feel like a data-extraction process.

*In practice:* no "sign up to continue" walls for core features, permission requests always contextual (ask at moment of use), visible indicators of what is and isn't leaving the device.

### 1.4 Accessible by default, not by audit

WCAG AA is a floor, not a destination. Every interactive element needs a clear focus state. Every text element must pass contrast. Touch targets are never smaller than 44×44dp.

### 1.5 One shared grammar, per-app personality

All OpenHearth apps share tokens, type scale, and component anatomy. Individual apps can lean into sub-palettes — Lullaby might be softer and cooler, Sundial greener, Garner more authoritative — but they all speak the same underlying design language. A user who downloads a second OpenHearth app should feel instant familiarity.

---

## 2. Color System

### 2.1 Primitive Palette

These are the raw named colors. They should never appear directly in component code — always reference semantic tokens (section 2.3). But every designer and developer should know these exist.

#### Hearth (Primary Brand — Terracotta/Clay)

| Token | Hex | Usage |
|-------|-----|-------|
| `hearth-50` | `#FDF5F3` | Tinted surface, hover backgrounds |
| `hearth-100` | `#F8E8E3` | Badge backgrounds, input fill |
| `hearth-200` | `#EDCDC5` | Borders, dividers on light surface |
| `hearth-300` | `#D9A99E` | Disabled state |
| `hearth-400` | `#CD8366` | Warmth on hearthDark (primary there) |
| `hearth-500` | `#9E4D2C` | Warmth on light — the one primary action |
| `hearth-600` | `#893F21` | Warmth pressed (light) |
| `hearth-700` | `#6E2F22` | Dark surface text on primary |
| `hearth-800` | `#511F15` | Rarely used — max emphasis on light |
| `hearth-900` | `#370F09` | Approximate only |

*Rationale:* A grounded terracotta — not the trendy 2020 coral, not orange. Think old brick or a well-used cast iron skillet. Something that has lived in a kitchen, not a gallery. Since 0.7.0 the 400–600 steps sit at OKLCH hue 42 (clay), moved off hue 32 so warmth no longer shares a grey with the error red (see §2.3).

#### Linen (Neutrals — Warm Whites & Browns)

| Token | Hex | Usage |
|-------|-----|-------|
| `linen-50` | `#FBF8F4` | App background — never pure white |
| `linen-100` | `#F5EFE6` | Card surface, input background |
| `linen-200` | `#EAE1D4` | Subtle dividers |
| `linen-300` | `#C7B9A0` | Decorative borders; secondary text on dark |
| `linen-400` | `#B3A08A` | Hint text on dark. **Never text on light** (2.21:1) |
| `linen-500` | `#8C7B65` | Control borders (3:1). **Not text on light** (3.58:1) |
| `linen-600` | `#6E5F4C` | Secondary text and input hints on light (5.40:1) |
| `linen-700` | `#4D3E2E` | Labels, neutral icons, body text |
| `linen-800` | `#35281C` | Headings |
| `linen-900` | `#2C1810` | Primary text — never pure black |

*Rationale:* Pure white is clinical. Pure black is harsh. Linen-50 is what a quality paperback book looks like in afternoon light. Linen-900 is what a pencil drawing looks like, not a laser print.

#### Sage (Secondary — Nature/Success)

| Token | Hex | Usage |
|-------|-----|-------|
| `sage-100` | `#E0EFEA` | Success backgrounds |
| `sage-200` | `#BED8CE` | Success borders |
| `sage-300` | `#7DBB9A` | Success on dark and night |
| `sage-400` | `#7BAF96` | Icons, secondary accents |
| `sage-500` | `#5E9478` | Success state, nature-oriented apps (Sundial) |
| `sage-600` | `#4A7B65` | Pressed success, strong accent |
| `sage-700` | `#386D54` | Success text on light (5.27:1) |

*Rationale:* Sage reads "nature and health" without the fluorescent-green danger of Material success colors. Used for outdoor tracking (Sundial), feeding/sleep indicators (Lullaby), positive achievements.

#### Slate (Tertiary — Informational/Calm)

| Token | Hex | Usage |
|-------|-----|-------|
| `slate-100` | `#DDE5F1` | Info backgrounds |
| `slate-200` | `#8FB4E4` | Attention on dark and night |
| `slate-300` | `#97ACCA` | Info borders, secondary UI |
| `slate-500` | `#5C7599` | Informational state (icons) |
| `slate-600` | `#39659B` | Attention on light: selection, focus, "new", links |
| `slate-700` | `#3A5070` | Strong info emphasis |

*Rationale:* A grey-blue that reads "informational" without the clinical coldness of pure grey or the alertness of a bright blue. Used for Porch's availability states, info callouts, read-only data.

#### Semantic Accent Colors (Sparingly)

| Token | Hex | Usage |
|-------|-----|-------|
| `amber-700` | `#805307` | Warning text on light |
| `amber-500` | `#A0701A` | Warning icon on light (marks only, 3:1) |
| `amber-300` | `#E7B551` | Warning text and icon on dark and night |
| `amber-100` | `#FCEDCD` | Warning surface (light) |
| `amber-400` | `#C49A3C` | Legacy. 2.29:1 on linen — not for text or icons |
| `red-500` | `#9B1D29` | Urgency on light: destructive actions, errors |
| `red-300` | `#FF939C` | Urgency on dark and night |
| `red-100` | `#FFE7E6` | Urgency surface (light) |
| `success-surface` | `#E1F4E9` | Success surface (light) |
| `attention-surface` | `#E4F0FF` | Attention surface (light) |

Dark status surfaces: hearthDark `dark-urgency-surface #4B1D1F`, `dark-warning-surface #3E2D10`, `dark-success-surface #1B3427`, `dark-attention-surface #202F42`; night `night-urgency-surface #421B1C`, `night-warning-surface #37290F`, `night-success-surface #192E23`, `night-attention-surface #1D2A3A`.

---

### 2.2 Dark Mode Primitives — Two Palettes, Three Themes

We ship **three** user-selectable themes, not two. The dark-mode story splits
into a "warm dark" palette and a "neutral dark" palette because the two serve
different moments in a user's day.

#### Hearth-dark surface palette — for `OhTheme.hearthDark()`

Warm brown-black, stays inside the hearth/linen family. The "evening"
theme: brief check-ins after dinner, reflective reading, times when the
warmth of the daytime palette still feels right but the brightness is wrong.

| Token | Hex | Corresponds to |
|-------|-----|----------------|
| `dark-surface-base` | `#1C1007` | App background (very dark warm brown) |
| `dark-surface-card` | `#2A1A0D` | Card surfaces |
| `dark-surface-elevated` | `#3A2215` | Modals, sheets, elevated content |
| `dark-surface-high` | `#4A2E1F` | Tooltips, top-layer items |
| `dark-border-subtle` | `#5A3A28` | Subtle borders |
| `dark-border-default` | `#6B4A34` | Default borders |

#### Night surface palette — for `OhTheme.night()`

Neutral high-contrast dark. **Intentionally outside the hearth/linen family** —
warmth is atmospheric but tiring over 20+ minutes of focused reading. The
"deep work" theme: 2am re-polls, sustained budgeting sessions, long glossary
entries, serious low-ambient-light use.

| Token | Hex | Corresponds to |
|-------|-----|----------------|
| `night-surface-base` | `#0A0A0C` | App background (near-black neutral) |
| `night-surface-card` | `#141418` | Card surfaces |
| `night-surface-elevated` | `#1F1F25` | Modals, sheets, elevated content |
| `night-border` | `#2A2A32` | Decorative borders and dividers |
| `night-border-control` | `#76767F` | A field's only edge (3.64:1 on elevated) |
| `night-text-primary` | `#EDEDF0` | Primary text (near-white, slight cool cast) |
| `night-text-dim` | `#A0A0AC` | Secondary text |

#### Picking between the two

| User signal | Theme to prefer |
|---|---|
| Daytime, full ambient light | **Light** |
| Evening, reading casually, hearth palette still feels good | **Hearth-dark** |
| Long uninterrupted reading, low-ambient-light, or the user explicitly wants "true" dark | **Night** |
| User hasn't picked | **Light** (do not auto-switch from system — ask once, let them pick) |

#### Accent in each theme

| Theme | Default accent | Why |
|---|---|---|
| Light | `hearth-500` | Brand anchor, excellent contrast on linen |
| Hearth-dark | `hearth-400` (`#CD8366`) | Lighter clay for dark-mode contrast (4.96:1 on elevated); still warm |
| Night | `sage-400` | Softer than hearth-on-near-black; easier on the eyes at low ambient light; reinforces the "deliberate deep work" register |

All three accept `appAccent:` to override (Lullaby uses `sage-500` across all
three; Garner might use a more authoritative slate).

---

### 2.3 The Colour Language and Semantic Tokens

Red does two jobs in this fleet, and the system keeps them apart. Three roles, five families (research note `2026-09-26-colour-language.md`; references: MIL-STD-2525, 14 CFR 25.1322, IBM Carbon, Apple HIG):

| Family | Role | Carried by |
|---|---|---|
| **Warmth** (clay, OKLCH hue 42) | Who we are: the one primary action per screen, identity moments | Fill or large type; never alone on anything that can fail |
| **Urgency** (crimson, hue 22) | Error, destructive | Hue **plus** an icon **plus** a word, always |
| **Warning** (ochre) | "Check this" | Hue plus a triangle icon plus a word |
| **Attention** (slate blue) | Pointing-out: selection, focus, "new", links | Hue plus a shape: ring, check, dot, underline |
| **Success** (sage) | Done, safe | Hue plus a check or a word |
| **Neutral** (linen; grey on night) | Surfaces, text, borders, **icons and chrome** | — |

**The rule for red.**
1. Urgency never relies on hue. Take the colour away and an error still reads as an error (icon + word). `showOhConfirm(destructive: true)` carries the octagon icon for this reason.
2. Warmth never appears on danger — not on a destructive button, a failed state or a validation message.
3. Warmth and urgency never share a container as fills. A destructive confirm has one urgency button and a neutral Cancel.
4. Chrome is neutral. Icons, app-bar glyphs, dividers and inactive slider tracks take neutral tones (`OhTheme`'s `iconTheme` is `onSurfaceVariant` since 0.7.0).
5. Attention always has a shape; blue and warmth share a grey (1.08:1 on light).
6. An `appAccent` must stay clear of urgency and attention in its theme (≥ 0.08 ΔE_ok). Lilt's `hearth-300` is 0.010 from dark urgency under deuteranopia and needs a different accent or heavier marks.

In Flutter the roles are `OhColorRoles` (a `ThemeExtension` every `OhTheme` builder attaches; read it with `OhColorRoles.of(context)`). `test/contrast_test.dart` computes WCAG ratios for every pair the themes wire: 4.5:1 for text, 3:1 for icons and control borders.

**Measured on three grounds.** The note sized warmth and the light warning icon on the app and card grounds only. On light's raised container (`linen-200`) its values fell short (warmth 4.27:1, warning icon 2.86:1), so 0.7.0 darkened both within their hue bands: warmth `#A4512E` → `#9E4D2C` (4.57:1 on `linen-200`, still OKLCH hue 42) and warning icon `#AD7C1D` → `#A0701A` (3.36:1, hue 76). The cost: warmth and urgency separate by 1.37:1 luminance and 0.090 ΔE_ok instead of the note's 1.46 and 0.102 (the old pair was 1.13 and 0.045). Rule 1 carries the separation, as the note intended.

```
-- Surface --
color-surface-app          light: linen-50      dark: dark-surface-base      night: night-surface-base
color-surface-card         light: linen-100     dark: dark-surface-card      night: night-surface-card
color-surface-elevated     light: linen-100     dark: dark-surface-elevated  night: night-surface-elevated
color-surface-overlay      light: linen-900/40% dark: #000000/50%
color-surface-tinted       light: hearth-50     dark: dark-surface-high

-- Text --
color-text-primary         light: linen-900     dark: linen-100   night: night-text-primary
color-text-secondary       light: linen-700     dark: linen-300   night: night-text-dim
color-text-tertiary        light: linen-600     dark: linen-400   night: night-text-dim
color-text-on-primary      light: white         dark: linen-900   night: night-surface-base
color-text-placeholder     light: linen-600     dark: linen-400   night: night-text-dim
color-text-link            light: slate-600     dark: slate-200   night: slate-200
color-text-disabled        light: linen-300     dark: linen-700   (exempt from contrast)

-- Warmth (brand interactive) --
color-interactive-primary  light: hearth-500    dark: hearth-400  night: sage-400
color-interactive-hover    light: hearth-600    dark: hearth-300
color-interactive-focus    use attention + a 2px ring, not warmth

-- Chrome --
color-icon                 light: linen-700     dark: linen-300   night: night-text-dim

-- Borders --
color-border-subtle        light: linen-200     dark: dark-border-subtle   night: night-border
color-border-default       light: linen-300     dark: dark-border-default  night: night-border
color-border-control       light: linen-500     dark: linen-500            night: night-border-control

-- Status (dark and night share values; surfaces differ) --
color-error                light: red-500       dark: red-300     on-error: white / linen-900 / night-surface-base
color-error-surface        light: red-100       dark: dark-urgency-surface   night: night-urgency-surface
color-warning-text         light: amber-700     dark: amber-300
color-warning-icon         light: amber-500     dark: amber-300
color-warning-surface      light: amber-100     dark: dark-warning-surface   night: night-warning-surface
color-success              light: sage-700      dark: sage-300
color-success-surface      light: success-surface  dark: dark-success-surface  night: night-success-surface
color-attention            light: slate-600     dark: slate-200
color-attention-surface    light: attention-surface  dark: dark-attention-surface  night: night-attention-surface
color-info-text            light: slate-700     dark: slate-300
```

---

### 2.4 App Sub-Palette Notes

Apps may lean into specific primitives while staying within the system:

| App | Dominant accent | Rationale |
|-----|-----------------|-----------|
| Lullaby | sage-400 (soft), slate-300 (cool) | Calm, nighttime-safe |
| Porch | hearth-500 (warm, social) | Warmth and availability |
| Sundial | sage-500 (nature) | Outside, growth |
| Baby Names | hearth-400/300 (celebratory) | Joy, parenting milestone |
| StillLife | linen-heavy, low chroma | Neutral, inventory |
| Garner | linen-800/700 (authoritative) | Finance, precision |
| Glean (dev) | slate-600 (technical) | Code, information |

---

## 3. Typography

### 3.1 Typefaces

**Heading / Display:** [Lora](https://fonts.google.com/specimen/Lora)  
A contemporary serif with calligraphic roots. Well-spaced, warm, works beautifully at display sizes and holds up at H2/H3. The "this was written by a person" signal.

*Use for:* App name/logo, hero headings (H1/H2), pull quotes, marketing copy, achievement badges at large size.

**Body / UI:** [Nunito](https://fonts.google.com/specimen/Nunito)  
A rounded humanist sans. The roundedness contributes to the warmth; the sans-ness keeps it legible in dense UI. More inviting than Inter, more disciplined than Rounded Mplus.

*Use for:* All UI text, body paragraphs, labels, captions, buttons, navigation.

**Mono:** the platform's `monospace`. No monospace file is bundled anywhere in the fleet, so `OhTypography.code()` asks for the generic family rather than a face that is not there. (`tokens.css` still names JetBrains Mono for Glean's web frontend.)

Lora and Nunito are OFL-licensed. The canonical files live in `openhearth_design/fonts/` (Lora 400, 400 italic, 500, 700; Nunito 400, 500, 600, 700; `OFL.txt`). Since 0.7.1 `openhearth_design` declares them as package fonts and every `OhTypography` style names them with `package: 'openhearth_design'`, so apps get them without copies; nothing fetches from `fonts.google.com` at runtime. **There is no Lora 300 or 600 and no Nunito italic file anywhere in the fleet** — do not request those weights; Flutter would silently substitute a neighbour or synthesise a fake.

*Why Nunito below 30 px:* Kadavy's rule is to keep custom faces above 30 px on 100–150 ppi screens. Phones render at 300–450 ppi, where Nunito's open, rounded forms hold up at 13–16 px, and the fleet is offline by construction so a system font would mean a different face on every device. The 30 px rule is honoured for Lora, which only sets headings (23 px and up).

---

### 3.2 Type Scale — the ladder

One ladder for every role and every Material slot: a 16 px body stepped by about 1.2 (a minor third) and rounded. `OhTypography.ladder`:

| Step | Size | ×prev | Roles (family, weight) |
|------|------|-------|------------------------|
| −1 | 13 | 1.23 | bodySm / caption (N400), label / buttonSm (N600), labelSm (N700), listSubtitle (N400), code (mono) |
| 0 | 16 | — | body (N400), button (N600), listTitle (N600) |
| 1 | 19 | 1.19 | bodyLg (N400), titleSm (N600) |
| 2 | 23 | 1.21 | headline4 (L700), title (N700) |
| 3 | 28 | 1.22 | headline3 (L700) |
| 4 | 33 | 1.18 | headline2 (L700) |
| 5 | 40 | 1.21 | headline1 (L700) |
| 6 | 48 | 1.20 | display (L700) |
| 7 | 57 | 1.19 | materialTextTheme displayLarge only |

No two sizes in use are within 2 px (the old 11/12/14 and 22/24 steps read as mistakes, not levels). Below 16 there is exactly one step; roles that share 13 px differ by weight. Body and list leading is 1.4 (Kadavy's 120–140 percent); headings 1.15–1.3. `test/type_ladder_test.dart` enforces all of this.

### 3.3 Font Weights

| Token | Nunito | Lora | Use |
|-------|--------|------|-----|
| `weight-regular` | 400 | 400 | Body, paragraph text |
| `weight-medium` | 500 | 500 (file exists, unused by roles) | Material labelSmall |
| `weight-semibold` | 600 | **none — no file** | Button labels, labels, list titles |
| `weight-bold` | 700 | 700 | Strong emphasis, headings |

### 3.4 Semantic Text Roles

Rather than hardcoding size/weight in components, use these role tokens:

```
type-display:        Lora 700, 48, h1.15
type-headline-1:     Lora 700, 40, h1.2
type-headline-2:     Lora 700, 33, h1.2
type-headline-3:     Lora 700, 28, h1.25
type-headline-4:     Lora 700, 23, h1.3
type-title:          Nunito 700, 23, h1.3
type-title-sm:       Nunito 600, 19, h1.3   (app bar)
type-body-lg:        Nunito 400, 19, h1.4   (prose)
type-body:           Nunito 400, 16, h1.4
type-body-sm:        Nunito 400, 13, h1.4, +0.2px
type-label:          Nunito 600, 13, +0.2px
type-label-sm:       Nunito 700, 13, +0.4px (section labels, sentence case)
type-caption:        Nunito 400, 13, +0.3px
type-button:         Nunito 600, 16
type-button-sm:      Nunito 600, 13, +0.2px
type-list-title:     Nunito 600, 16         (ListTile title)
type-list-subtitle:  Nunito 400, 13         (ListTile subtitle)
type-code:           monospace 400, 13
```

### 3.5 Typography Rules

1. **Never use pure black for text.** Always linen-900 or semantic `color-text-primary`.
2. **Avoid more than two type sizes in a single component.** If you need three, reconsider the component structure.
3. **Body text is 16 px; the only smaller step is 13 px**, for secondary text, labels and captions. Nothing goes below 13.
4. **Lora sets headings only, 23 px and up.** Nunito handles midrange well. Don't force the serif where it won't render well.
5. **Long-form text (Lullaby feeding notes, Garner transaction history) uses text-base/Nunito/linen-700.** Serif is for headings, not paragraphs.
6. **Respect system font size preferences.** In Flutter, use `sp` not `dp` for text. In CSS, use `rem` not `px`.

---

## 4. Spacing & Sizing

### 4.1 Spacing Scale

Base unit: 4px. All spacing tokens are multiples.

| Token | Value | Common Use |
|-------|-------|------------|
| `space-0.5` | 2px | Micro-nudges, rarely used |
| `space-1` | 4px | Icon-to-label gaps, tight list padding |
| `space-2` | 8px | Compact padding, between related items |
| `space-3` | 12px | Comfortable inline padding |
| `space-4` | 16px | Default element padding, standard gap |
| `space-5` | 20px | Slightly generous padding |
| `space-6` | 24px | Section padding, card internal padding |
| `space-8` | 32px | Between sections |
| `space-10` | 40px | Large section gaps |
| `space-12` | 48px | Page-level vertical spacing |
| `space-16` | 64px | Hero spacing, generous breathing room |
| `space-24` | 96px | Marketing/landing contexts only |

### 4.2 Touch Targets

Minimum interactive target: **44×44dp** (follows Apple HIG and Android Material guidelines). Applies to all buttons, links, toggles, and icon buttons. The visible element may be smaller; invisible padding fills the touch zone.

### 4.3 Layout Containers

| Context | Max width | Padding (mobile) | Padding (tablet+) |
|---------|-----------|------------------|--------------------|
| Phone-shaped app screens (lists, forms, trackers) | 640px | space-4 (16px) horizontal | space-4 (16px) |
| Standard page content (reading, prose) | 720px | space-4 (16px) horizontal | space-8 (32px) |
| Wide content (Garner charts) | 960px | space-4 | space-12 |
| Full bleed | none | 0 | 0 |

In Flutter these are `OhPage` (`maxWidth` defaults to `OhPage.phoneMaxWidth`, 640; `proseMaxWidth` 720 and `wideMaxWidth` 960 match the rows above). Content is centred and top-aligned on wide screens and sits inside the safe area; app bars and backgrounds stay full width. A mouse wheel over the side margins scrolls the content (forwarded to the first vertical scrollable inside); trackpad pan over the margins is not forwarded.

### 4.4 Grid

Mobile-first. Base grid is an 8-column layout on phones (not 12 — these are family apps, not dashboards). Tablet bumps to 12. Most screens will use 1 or 2 columns at mobile, 2-3 at tablet.

---

## 5. Elevation & Shadow

Shadows are warm-tinted, not cold grey. The shadow color is always derived from `linen-900` at low opacity, which gives a brown warmth rather than a blue-grey detachment.

| Token | Value | Use |
|-------|-------|-----|
| `shadow-none` | none | Flat items, inline elements |
| `shadow-xs` | `0 1px 2px rgba(44, 24, 16, 0.06)` | Subtle lift, text inputs on linen bg |
| `shadow-sm` | `0 1px 4px rgba(44, 24, 16, 0.09)` | Cards on linen surface |
| `shadow-md` | `0 4px 12px rgba(44, 24, 16, 0.10)` | Raised cards, dropdowns |
| `shadow-lg` | `0 8px 24px rgba(44, 24, 16, 0.12)` | Modal dialogs, popovers |
| `shadow-xl` | `0 16px 40px rgba(44, 24, 16, 0.14)` | Full-screen sheets |

In dark mode, replace with inset highlights rather than shadows (dark material can't cast visible dark shadows). Use `box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.07)` for subtle elevated-card edges in dark mode.

---

## 6. Shape & Border Radius

| Token | Value | Use |
|-------|-------|-----|
| `radius-none` | 0 | Intentional full-bleed items |
| `radius-xs` | 2px | Tags, very tight badges |
| `radius-sm` | 4px | Buttons with text only, inline code |
| `radius-md` | 8px | Inputs, small cards, chips |
| `radius-lg` | 12px | Cards, standard components |
| `radius-xl` | 16px | Sheets (bottom edge), large cards |
| `radius-2xl` | 24px | Modals, prominent feature cards |
| `radius-full` | 9999px | Pills, avatar rings, toggle tracks |

**Rule:** Bottom sheets have `radius-xl` or `radius-2xl` on the top corners only. Full-screen modals should feel like pages, not floating boxes — use minimal radius or none on corners that meet screen edges.

---

## 7. Motion & Animation

### 7.1 Principles

**Slow down by default.** Our instinct will be to match iOS/Material defaults, which are tuned for productivity apps with high interaction frequency. Our apps are calmer. Default durations should be 1.5× to 2× slower than you'd reach for first.

**Motion should mean something.** Transitions explain spatial relationships or state changes. They are not decoration. A loading spinner that spins for 3 seconds is a failure of UX, not an opportunity for animation artistry.

**Nothing should feel frantic.** No bounce-in animations, no rapid sequence animations, no elements flying in from multiple directions.

### 7.2 Duration Tokens

| Token | Duration | Use |
|-------|----------|-----|
| `duration-instant` | 0ms | State changes with no spatial component (toggle text) |
| `duration-fast` | 100ms | Micro-interactions (press ripple, hover bg change) |
| `duration-normal` | 200ms | Button state changes, icon swaps |
| `duration-slow` | 350ms | Card expand/collapse, drawer open |
| `duration-deliberate` | 500ms | Page transitions, modal open, celebration |
| `duration-stately` | 700ms | Onboarding reveal, achievement unlock |

### 7.3 Easing Tokens

| Token | Curve | Use |
|-------|-------|-----|
| `ease-linear` | `linear` | Progress bars |
| `ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | Exit animations (element leaving) |
| `ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | Enter animations (element arriving) |
| `ease-standard` | `cubic-bezier(0.4, 0, 0.2, 1)` | Standard transitions |
| `ease-spring` | Spring physics (Flutter: `SpringSimulation`) | Celebration animations, achievement badges |
| `ease-settle` | `cubic-bezier(0.34, 1.36, 0.64, 1)` | Confirmatory actions (saved, toggled) — very subtle overshoot |

### 7.4 Standard Motion Patterns

**Page transitions:** Shared axis transition (horizontal for drill-down, vertical for modal-like screens). Duration: `duration-deliberate` / `ease-standard`.

**Bottom sheet:** Slides up from bottom. Duration: `duration-deliberate` / `ease-out` on open, `ease-in` on close.

**Achievement / badge unlock:** Scale from 0.6→1 with `ease-settle`, slight overshoot. Confetti if milestone-level (Sundial first 100 hours, Lullaby first month). Duration: `duration-stately`.

**List item entry (new item added):** Fade + translate from `space-4` below. Stagger 50ms per additional item if multiple. Duration: `duration-slow`.

**Deletion / dismissal:** Swipe or fade + scale to 0.8. Duration: `duration-normal`. Do not animate the reflow of remaining items — it's disorienting.

**Loading states:** Skeleton screens, not spinners. Skeleton uses `linen-200` animated shimmer in light mode, `dark-surface-elevated` in dark mode.

---

## 8. Iconography

### 8.1 Icon Library

**Primary:** [Lucide Icons](https://lucide.dev) — open source, MIT licensed, consistent 24px base grid, 2px rounded stroke, works across all platforms.

Lucide is the correct choice because:
- Consistent visual grammar (all icons designed together)
- Rounded style matches our soft aesthetic
- Actively maintained, large set
- Available for Flutter (`lucide_flutter`), React (`lucide-react`), and SVG export for Tauri

**Do not mix icon families.** No mixing Lucide with Material Icons, Heroicons, or custom SVGs that don't follow the same visual grammar.

### 8.2 Custom Icons

When a custom icon is needed (app-specific metaphors not in Lucide), it must:
- Use 24px base grid
- Use 2px stroke weight, rounded linecaps and joins
- Use no more filled fills than Lucide does for similar icons (prefer stroke-first)
- Be delivered as SVG with viewBox="0 0 24 24"
- Be reviewed against adjacent Lucide icons to verify visual weight matches

### 8.3 Icon Sizes

| Token | Size | Context |
|-------|------|---------|
| `icon-xs` | 14px | Inline with text-xs labels |
| `icon-sm` | 16px | Dense UI, captions, compact lists |
| `icon-md` | 20px | Default UI icon size |
| `icon-lg` | 24px | Standard button icons, nav icons |
| `icon-xl` | 32px | Feature icons, empty state illustrations |
| `icon-2xl` | 48px | App icon-scale, onboarding |

### 8.4 Icon Color

Icons inherit the semantic color of their context. The exception: decorative/illustrative icons can use brand accent colors for warmth. Never use multiple colors in a single icon unless it is an explicitly illustrative asset (not a UI affordance icon).

**Chrome icons are neutral.** Since 0.7.0 `OhTheme` sets `ThemeData.iconTheme.color = onSurfaceVariant` (it was `primary`): warmth is kept for the one primary action, and an icon in the accent no longer competes with it (colour language rule 4, §2.3).

**Filled icon buttons — use `OhIconButton`, not the plain Material widget.** The ambient `iconTheme` collides with Flutter's `IconButton.filled` and `IconButton.filledTonal`: on Flutter 3.38.7, the ambient color resolves above the button's own default foreground, so an unstyled `IconButton.filled` paints its glyph in the neutral icon color over its primary fill instead of `onPrimary` (before 0.7.0, in `primary` itself — invisible). `IconButton.filledTonal` has the same problem against `onSecondaryContainer`.

`openhearth_design` ships `OhIconButton.filled` / `OhIconButton.filledTonal` (`lib/src/icon_buttons.dart`) as replacements for those two variants specifically. They cover the parameters real call sites in this fleet use — `icon`, `onPressed`, `tooltip`, `iconSize`, `constraints`, `padding`, `autofocus`, `focusNode`, `style` — and pin the correct foreground (`onPrimary` / `onSecondaryContainer`) at the widget level, which outranks the ambient theme. A caller-supplied `style` still wins over the built-in foreground. They do not cover every `IconButton.filled` parameter: `isSelected`/`selectedIcon`, `color`, `visualDensity`, `alignment`, `mouseCursor`, `onLongPress`, `enableFeedback`, and `statesController` aren't exposed. A call site that needs one of those should build the plain `IconButton.filled`/`.filledTonal` directly and pass `style: IconButton.styleFrom(foregroundColor: ...)` itself, matching the pattern `OhIconButton` wraps.

Plain (non-filled, non-tonal) icon buttons are unaffected and need no wrapper — the ambient `iconTheme` is exactly what they're supposed to inherit.

*Known, deliberate deferral:* the tidier long-term fix is dropping the app-wide `iconTheme` entirely and letting every Material widget resolve its own per-variant default. 0.7.0 made it neutral instead, which is the colour-language change the operator approved; dropping it remains a separate decision.

---

## 9. Component Anatomy

This section defines the design rules for core shared components. It is not a full component library spec — it defines the visual grammar each platform implementation must honor.

### 9.1 Buttons

Three variants:

**Primary**
- Background: `color-interactive-primary` (hearth-500)
- Text: `color-text-on-primary` (white on light, 5.91:1)
- Radius: `radius-lg` (12px)
- Padding: `space-3` top/bottom, `space-6` left/right
- Font: `type-button`
- Hover: background → `color-interactive-hover`
- Pressed: background → `color-interactive-pressed`, slight scale (0.98)
- Disabled: background → linen-300, text → linen-400, no pointer events
- Focus ring: 2px offset, `color-interactive-focus`, visible on keyboard nav

**Secondary (Outlined)**
- Background: transparent
- Border: 1.5px `color-interactive-primary`
- Text: `color-interactive-primary`
- Radius: `radius-lg`
- Hover: background → hearth-50
- All other states: mirror Primary

**Ghost**
- Background: transparent
- Text: `color-interactive-primary`
- No border
- Hover: background → hearth-50
- Use for: in-context actions, destructive confirmation cancel buttons

**Destructive variant:** applies to any button type, uses `color-error` (red-500 light, red-300 dark) in place of warmth **and** carries the urgency icon and a verb ("Delete 3 items"). Paired with a neutral Cancel, never with a warmth-filled button.

**Size variants:**
- Default (above): most contexts
- Small: `space-2`/`space-4` padding, `type-button-sm`, `radius-md`
- Large: `space-4`/`space-8` padding, `text-lg` font, `radius-xl`

### 9.2 Text Inputs

- Background: `color-surface-card` (linen-100 / dark-surface-card / night-surface-elevated)
- Border: 1px `color-border-control` — on a filled field the border is its only edge, so it must reach 3:1
- Border radius: `radius-md` (8px)
- Padding: `space-3` top/bottom, `space-4` left/right
- Text: `type-body`, `color-text-primary`
- Placeholder: `color-text-placeholder`
- Focus border: `color-interactive-primary`, 2px
- Error border: `color-error`, error message below in `type-caption` / `color-error`, led by the urgency icon
- Helper text: `type-caption` / `color-text-tertiary` below field
- Labels: `type-label` above field, `color-text-secondary`

### 9.3 Cards

Standard surface for grouping related content.

- Background: `color-surface-card`
- Border: 1px `color-border-subtle`
- Shadow: `shadow-sm`
- Radius: `radius-lg` (12px)
- Internal padding: `space-4` default, `space-6` for prominent cards
- On press (if interactive): background → `hearth-50` in light / `dark-surface-high` in dark, scale 0.995 over `duration-fast`

### 9.4 List Items

For scrollable lists (feed history, contacts, etc.):

- Min height: 56dp (48dp content + `space-2` top/bottom padding)
- Leading: icon (icon-lg) or avatar
- Title: `type-list-title` (16 w600) — `OhTheme` wires it into `listTileTheme`
- Subtitle/metadata: `type-list-subtitle` (13 w400), `color-text-secondary`
- Trailing: icon or label
- Separator: 1px `color-border-subtle` at 50% opacity, inset from left at leading item right edge
- No separator on last item or after section headers

### 9.5 Bottom Sheet

Used for actions, pickers, and confirmations. Replaces most dialogs on mobile.

- Radius: `radius-xl` on top corners only
- Background: `color-surface-elevated`
- Handle bar: 4px × 36px, `color-border-default`, centered, `space-2` from top
- Max height: 85% of viewport (scrollable inside)
- Overlay: `color-surface-overlay`
- Animation: slide up from bottom, `duration-deliberate`/`ease-out`
- Dismiss: swipe down or tap overlay

### 9.6 Navigation

**Mobile (bottom tab bar):**
- Background: `color-surface-elevated` with top border `color-border-subtle`
- Active tab: icon in `color-interactive-primary`, label in `type-label`/`color-interactive-primary`
- Inactive tab: icon in `color-text-tertiary`, label in `type-label-sm`/`color-text-tertiary`
- Max 5 tabs. Prefer 3-4.
- Never use badge counts except for genuine unread/action-required states

**Tablet/Desktop (sidebar):**
- Width: 240-280px
- Background: `color-surface-card`
- Section headers: `type-label`, `color-text-tertiary`
- Active item: `hearth-50` background, `color-interactive-primary` text and icon

### 9.7 Status / Achievement Badges

Used for milestones, streaks, confirmations.

- Background: `hearth-100` (default) or `sage-100` (nature/achievement)
- Text: `hearth-600` or `sage-600`
- Radius: `radius-full`
- Padding: `space-1`/`space-3`
- Font: `type-label-sm`, weight-bold
- For milestone badges: icon + text, `icon-sm` leading

**Achievement unlock animation sequence:**
1. Small pulse `scale(1.08)`, `duration-fast`, `ease-settle`
2. Badge reveals with `scale(0.6)→scale(1)`, `duration-stately`, `ease-settle`
3. If milestone-level: confetti (`duration-stately`, hearth/sage/linen color particles)

### 9.8 Empty States

Every list, feed, or data view needs an empty state. It should never be a blank screen.

Structure:
- Illustration or icon: `icon-2xl` (48px) in `hearth-200` or a bespoke illustration
- Headline: `type-headline-4` / `color-text-secondary`
- Body: `type-body-sm` / `color-text-tertiary`, 2 lines max
- CTA (optional): Primary or Secondary button

Tone: Warm, not apologetic. "Nothing here yet — add your first entry" not "No data found."

### 9.9 Error States

Shipped as `OhErrorState` in `openhearth_design`. A failure is a state with a way out, never a code.

- Title: short and human, naming what did not happen ("Couldn't load your list").
- Body: one plain sentence, what happened and what to do next (`ohFriendlyErrorMessage` supplies it for common exceptions).
- Action: a Retry button (48dp minimum) whenever the app can recover.
- Details: the technical error, hidden until asked for, selectable for bug reports. The raw exception is never the main text.

### 9.10 Deleting: Confirm or Undo

Shipped as `showOhConfirm`, `OhUndoController` and `OhUndoBar` in `openhearth_design`.

- **Easy gesture** (swipe, long-press shortcut): confirm first. The confirm button names the act ("Delete 3 items"); "OK", "Yes" or a bare "Delete" are not labels. The button is neutral unless the act is destructive.
- **Deliberate delete** (a Delete button or menu item): act at once, soft-deleted, and offer Undo in a persistent bar. The bar has no timer. It ends when the person taps Undo, closes it, deletes something else, or leaves the screen.
- **A lasting way back**: every app with deletes has a Recently deleted list. "Delete forever" there is the only hard delete, and it confirms.

### 9.11 Theme Control

Shipped as `OhThemeModePreference` and `OhThemeToggle` in `openhearth_design`.

- Three choices: **Light**, **Dark**, **Follow phone**. Follow phone is the default.
- Reachable in one tap, at most two, from every primary screen: the toggle sits in the app bar as an icon plus a short label ("Auto", "Light", "Dark"). Settings may repeat it.
- Each app picks which dark theme is its Dark (`hearthDark` or `night`). Apps offering all three themes by name keep that picker in Settings.

---

## 10. Platform Implementation

### 10.1 Flutter

**Package:** `openhearth_design` on pub.dev

```dart
// Theme setup
MaterialApp(
  theme: OpenHearthTheme.light(),
  darkTheme: OpenHearthTheme.dark(),
  ...
)
```

Implementation notes:
- Use `ColorScheme.fromSeed(seedColor: OpenHearthColors.hearth500)` as the base, then override with semantic tokens
- Typography from bundled assets only (the package fonts `openhearth_design` declares); never `google_fonts`
- Respect `MediaQuery.textScaleFactor` — never override system font scaling
- Elevation via custom `BoxDecoration` using `OpenHearthShadows` tokens (Flutter's built-in elevation uses cold grey)
- All motion uses `OpenHearthDurations` and `OpenHearthEasing` constants
- Icons via `lucide_flutter` package

**Directory structure:**
```
openhearth_design/
  lib/
    src/
      colors.dart        -- primitives + semantic tokens, light/dark
      typography.dart    -- TextStyle constants
      spacing.dart       -- EdgeInsets and SizedBox helpers
      radius.dart        -- BorderRadius constants
      shadows.dart       -- BoxDecoration/BoxShadow constants
      motion.dart        -- Duration and Curve constants
      theme.dart         -- ThemeData builder (light + dark)
    components/
      oh_button.dart
      oh_text_input.dart
      oh_card.dart
      oh_list_tile.dart
      oh_bottom_sheet.dart
      oh_badge.dart
      oh_empty_state.dart
    openhearth_design.dart  -- barrel export
```

### 10.2 React / PWA

**Package:** `@openhearth/design` on npm

Implemented as CSS custom properties (CSS variables) loaded in `:root`. Works with any React component approach — Tailwind extension, CSS Modules, or Styled Components.

```css
:root {
  --oh-color-interactive-primary: #9E4D2C;
  --oh-color-surface-app: #FBF8F4;
  --oh-color-text-primary: #2C1810;
  /* ... all semantic tokens */

  --oh-font-heading: 'Lora', Georgia, serif;
  --oh-font-body: 'Nunito', system-ui, sans-serif;

  --oh-space-4: 16px;
  /* ... */

  --oh-radius-lg: 12px;
  /* ... */

  --oh-duration-slow: 350ms;
  --oh-ease-out: cubic-bezier(0, 0, 0.2, 1);
  /* ... */
}

[data-theme="dark"] {
  --oh-color-surface-app: #1C1007;
  --oh-color-text-primary: #F5EFE6;
  /* ... dark mode overrides */
}
```

Tailwind users: a `tailwind.config.js` preset is provided that extends Tailwind with `oh-*` class prefixes backed by the CSS variables.

React components mirror the Flutter component set (`OhButton`, `OhCard`, etc.) using the same token names.

### 10.3 Tauri (Glean)

Tauri uses a web frontend, so the React/PWA implementation applies directly. No separate package needed — Glean imports `@openhearth/design`. The only Glean-specific note: the `slate-*` palette is more dominant (technical, developer-tool feel), and `JetBrains Mono` is loaded for code rendering.

---

## 11. Voice & Microcopy

This section is brief — a full copy guide is out of scope here. But because microcopy and design are inseparable, these rules belong in the style guide.

### 11.1 Principles

**Direct without being terse.** "Start timer" not "Initiate outdoor session." "Save" not "Commit changes."

**Warm without being saccharine.** "Nice work!" once at a milestone is appropriate. "Amazing! You're a superstar! 🌟🎉" is noise.

**No dark patterns.** No "Are you sure you want to stop improving your child's development?" No guilt-tripping on cancel/skip.

**Respect autonomy.** "You can always change this later" on optional settings. "This stays on your device" on privacy-relevant features.

### 11.2 Standard Copy Patterns

| Context | Pattern | Example |
|---------|---------|---------|
| Empty state headline | Positive potential, not absence | "Your first adventure starts here" |
| Empty state body | Brief, actionable | "Tap + to add a session" |
| Easy-gesture confirm | State the consequence truthfully | "Delete this entry? It moves to Recently deleted." ("can't be undone" only for Delete forever) |
| Confirm button | Specific verb and object; danger colour only when destructive | "Delete entry" not "Delete" or "OK" |
| Deliberate delete | Act, then offer Undo that stays until the next action | "Deleted 3 items  [Undo]" |
| Loading | Active verb or none | "Saving..." or skeleton only |
| Error | What happened + what to do | "Couldn't save. Check your connection and try again." |
| Success | Brief, specific | "Saved" or "1h 45m recorded" |
| Permission request | Value-first, contextual | "To show your outdoor time on a map, allow location access." |
| Onboarding skip | Non-punitive | "Skip for now" not "No thanks, I don't want to improve my family's health" |

---

## 12. Accessibility

### 12.1 Contrast Requirements

All text must meet WCAG 2.1 AA minimum:
- Normal text (below 18px bold / 24px regular): 4.5:1 minimum contrast ratio
- Large text (18px+ bold or 24px+ regular): 3:1 minimum
- UI components and icons: 3:1 against adjacent color

**Measured, not spot-checked.** `openhearth_design/test/contrast_test.dart` computes the WCAG 2.x ratio for every text/background and mark/background pair the three built themes wire — every text-theme slot, the colour-scheme `on*` pairs, input hint/label/border, list tiles, icons, and every `OhColorRoles` role and status surface — against the scaffold, card and raised container, and fails under 4.5:1 for text or 3:1 for marks. A few measured values (light unless noted):

| Foreground | Background | Ratio |
|------------|------------|-------|
| linen-900 `#2C1810` | linen-100 `#F5EFE6` | 14.75:1 |
| linen-600 `#6E5F4C` (secondary, hint) | linen-100 | 5.40:1 |
| hearth-500 `#9E4D2C` (warmth) | linen-100 | 5.17:1 |
| white | hearth-500 | 5.91:1 |
| red-500 `#9B1D29` (urgency) | linen-100 | 7.06:1 |
| linen-500 `#8C7B65` (control border) | linen-100 | 3.58:1 |
| red-300 `#FF939C` (dark urgency) | dark-surface-elevated `#3A2215` | 6.98:1 |
| night-border-control `#76767F` | night-surface-elevated `#1F1F25` | 3.64:1 |

### 12.2 Focus Visibility

Every interactive element must have a visible focus ring in keyboard navigation mode. Ring spec: 2px solid `color-interactive-focus`, 2px offset. Do not suppress focus outlines with `outline: none` without providing an alternative.

### 12.3 Touch Target Size

Minimum 44×44dp. Applies to all interactive elements including icon buttons with visible size smaller than 44dp (pad with invisible tap area).

### 12.4 Motion / Reduced Motion

Respect `prefers-reduced-motion` in CSS and Flutter's `MediaQuery.disableAnimations`. When reduced motion is active:
- Replace sliding transitions with fade-only
- Remove confetti
- Suppress celebratory animations (show the badge without the motion)
- Keep `duration-fast` micro-interactions (they serve function, not decoration)

### 12.5 Screen Reader Semantics

- All icons that convey meaning must have accessible labels
- Decorative icons must be hidden from screen readers (`aria-hidden` / `ExcludeSemantics` in Flutter)
- Bottom navigation items must announce their role and selected state
- Dynamic content updates (timer counting up, loading complete) must use appropriate ARIA live regions or Flutter semantics

---

## 13. Non-Goals (What This System Does Not Prescribe)

- **Illustration style.** The apps will eventually have custom illustrations. When that work happens, it should respect the color tokens and the "woodcut-as-vector" aesthetic note, but a full illustration guide is a separate document.
- **Photography.** No opinion on photography style yet.
- **Marketing site.** The site follows these tokens but has more expressive latitude (larger type, more dramatic use of Lora, more white space). Treat this guide as the floor for the site, not the ceiling.
- **Animations beyond the patterns described.** Lottie files, game-style animations for Baby Names, etc. — fine to add, must follow the motion principles, not specified here.
- **Third-party component customization.** Some apps (Glean, Garner) may need specialized charts, code editors, or map views. Style those with semantic tokens as much as possible; document deviations in the app's own CONTEXT.md.

---

## 14. Versioning & Change Process

**v0 (this document):** Design principles, color system, typography, spacing, core component anatomy. No published packages yet.

**v1:** First published packages (`openhearth_design` on pub.dev, `@openhearth/design` on npm). Full token set implemented. Core components (Button, Input, Card, ListTile, BottomSheet, Badge, EmptyState) implemented for Flutter.

**v2:** React component set matches Flutter. Full dark mode verified. Accessibility audit complete.

**Change process:**
1. Proposed changes go in a GitHub Discussion on `github.com/openhearth/design-system`
2. Breaking token changes (renames, removals) require a version bump and migration guide
3. No "temporary exceptions" — if an app needs something the system doesn't provide, add it to the system rather than hardcoding it in the app

---

*Last updated: March 2026*  
*Next review: Before v1 package publication*
