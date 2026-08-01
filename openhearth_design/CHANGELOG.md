# Changelog

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
