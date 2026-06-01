// packages/openhearth_tokens/tokens.ts
// OpenHearth design tokens — TypeScript constants.
// Source of truth: openHearthStyleGuide.md
// Keep in sync with: OhColors in packages/openhearth_design/lib/src/colors.dart

export const OhColors = {
  // Hearth — primary brand (terracotta)
  hearth50:  '#FDF5F3',
  hearth100: '#F8E8E3',
  hearth200: '#EDCDC5',
  hearth300: '#D9A99E',
  hearth400: '#C47B6A',
  hearth500: '#A85040', // primary interactive
  hearth600: '#8B3E2F',
  hearth700: '#6E2F22',
  hearth800: '#511F15',
  hearth900: '#370F09',

  // Linen — neutrals
  linen50:  '#FBF8F4',
  linen100: '#F5EFE6',
  linen200: '#EAE1D4',
  linen300: '#C7B9A0',
  linen400: '#B3A08A',
  linen500: '#8C7B65',
  linen600: '#6E5F4C',
  linen700: '#4D3E2E',
  linen800: '#35281C',
  linen900: '#2C1810',

  // Sage — nature/success
  sage100: '#E0EFEA',
  sage200: '#BED8CE',
  sage400: '#7BAF96',
  sage500: '#5E9478',
  sage600: '#4A7B65',

  // Slate — informational/calm
  slate100: '#DDE5F1',
  slate300: '#97ACCA',
  slate500: '#5C7599',
  slate700: '#3A5070',

  // Semantic accents
  amber100: '#F5E9C8',
  amber400: '#C49A3C',
  red100:   '#F5DDD9',
  red500:   '#B0382A',

  // Hearth-dark surfaces (evening theme — warm brown-black)
  darkSurfaceBase:     '#1C1007',
  darkSurfaceCard:     '#2A1A0D',
  darkSurfaceElevated: '#3A2215',
  darkSurfaceHigh:     '#4A2E1F',
  darkBorderSubtle:    '#5A3A28',
  darkBorderDefault:   '#6B4A34',

  // Night surfaces (deep-reading theme — neutral, leaves the warm family)
  nightSurfaceBase:     '#0A0A0C',
  nightSurfaceCard:     '#141418',
  nightSurfaceElevated: '#1F1F25',
  nightBorder:          '#2A2A32',
  nightTextPrimary:     '#EDEDF0',
  nightTextDim:         '#A0A0AC',
} as const;

export type OhColorKey = keyof typeof OhColors;

export const OhSpacing = {
  xs: 4, sm: 8, md: 16, lg: 24, xl: 40, xxl: 64,
} as const;

export const OhRadii = {
  sm: 4, md: 8, lg: 12, xl: 16, full: 9999,
} as const;

export const OhFonts = {
  heading: "'Lora', Georgia, serif",
  ui:      "'Nunito', system-ui, sans-serif",
  mono:    "'JetBrains Mono', 'Consolas', monospace",
} as const;

export const OhElevation = {
  raised:   '0 1px 2px rgba(44,24,16,0.06), 0 2px 4px rgba(44,24,16,0.04)',
  floating: '0 4px 8px rgba(44,24,16,0.10), 0 8px 20px rgba(44,24,16,0.08)',
  modal:    '0 12px 28px rgba(44,24,16,0.14), 0 24px 48px -8px rgba(44,24,16,0.10)',
  overlay:  '0 2px 6px rgba(44,24,16,0.16), 0 6px 14px -4px rgba(44,24,16,0.10)',
} as const;

export const OhElevationDark = {
  raised:   '0 1px 3px rgba(0,0,0,0.4)',
  floating: '0 4px 12px rgba(0,0,0,0.5)',
  modal:    '0 12px 32px rgba(0,0,0,0.6)',
  overlay:  '0 4px 10px rgba(0,0,0,0.55)',
} as const;

/** Durations are in milliseconds. */
export const OhMotion = {
  instantMs:    80,
  fastMs:      160,
  standardMs:  240,
  deliberateMs: 400,
  easeStandard:    'cubic-bezier(0.2, 0.0, 0, 1.0)',
  easeEmphasized:  'cubic-bezier(0.2, 0.0, 0, 1.0)',
  easeDecelerated: 'cubic-bezier(0.0, 0.0, 0.2, 1.0)',
} as const;
