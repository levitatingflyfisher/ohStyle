# Changelog

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
