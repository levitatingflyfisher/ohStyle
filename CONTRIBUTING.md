# Contributing to ohStyle

Thank you for taking the time to contribute! This document explains how to report issues, suggest features, and submit code changes.

---

## Reporting Bugs

Before opening a new issue, search existing issues to avoid duplicates.

When filing a bug report, please include:
- Flutter version (`flutter --version`)
- Device/OS and version (if the issue is rendering-related)
- Steps to reproduce
- Expected behaviour vs. actual behaviour
- Any relevant log output (`flutter logs`)

---

## Suggesting Features

Open an issue with the `enhancement` label. Describe the problem you are trying to solve rather than jumping straight to a solution — this helps discussion stay focused.

For token or theme changes, note which apps would be affected and how the change fits the tri-theme model (light / hearthDark / night).

---

## Development Setup

```bash
git clone <repo-url>
cd ohStyle/openhearth_design
flutter pub get
```

To run the package tests:

```bash
flutter test
```

If you are also working on the CSS/TypeScript tokens:

```bash
cd ohStyle/openhearth_tokens
# No build step required — tokens.css and tokens.ts are hand-maintained
# in lockstep with openhearth_design/lib/src/colors.dart
```

**Important:** If you change a token value, you must update all four places in lockstep:
1. `openHearthStyleGuide.md` — narrative explanation
2. `openhearth_design/lib/src/colors.dart` (or `radii.dart`, etc.) — Dart
3. `openhearth_tokens/tokens.css` — CSS custom property
4. `openhearth_tokens/tokens.ts` — TypeScript constant

---

## Code Style

All contributions must pass the following checks before review:

```bash
# Format
dart format .

# Static analysis (must have zero issues)
flutter analyze

# Tests (must all pass)
flutter test
```

The project uses `package:flutter_lints` with standard rules — no overrides. Do not disable lint rules without a well-reasoned justification in the PR description.

---

## Testing

- Every new token or component must include tests.
- Bug fixes should include a regression test where feasible.
- Tests live in `openhearth_design/test/` and cover color values, theme construction, and any exported widgets.

---

## Pull Request Workflow

1. Fork the repository and create a feature branch from `main`:
   ```bash
   git checkout -b feat/my-feature
   ```
2. Make your changes, following the code style rules above.
3. Open a PR against the `main` branch with a clear description of what changed and why.
4. Link any related issues in the PR description (`Closes #123`).

PRs that fail `flutter analyze` or `flutter test` will not be merged.

---

## Architecture Notes

ohStyle ships three artifacts from one set of design decisions:

- `openhearth_design/` — Flutter package (`OhColors`, `OhTheme`, `OhTypography`, `OhElevation`, `OhMotion`, etc.)
- `openhearth_tokens/tokens.css` — CSS custom properties for React/Astro/Tauri consumers
- `openhearth_tokens/tokens.ts` — TypeScript constants mirroring the CSS tokens
- `openHearthStyleGuide.md` — narrative specification explaining the "why" behind every decision

The package exposes three themes:

| Theme | Dart API | When to use |
|-------|----------|-------------|
| Light | `OhTheme.light()` | Daytime, full ambient light |
| Hearth-dark | `OhTheme.hearthDark()` | Evening / warm-dark sessions |
| Night | `OhTheme.night()` | Deep reading, low ambient light |

When adding a new component, ask whether it is generic enough to live in `openhearth_design/lib/src/components/` (usable in 3+ apps) or whether it belongs in the consuming app. When in doubt, keep it in the app — premature abstraction is worse than duplication.

`openhearth_design` ships with zero runtime dependencies beyond `flutter`. Do not add dependencies without strong justification — every new dep is a supply-chain risk and a version-compatibility matrix for every downstream consumer.

---

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).

---

## Contact

Questions or ideas? Open a GitHub issue.
