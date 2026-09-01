import 'package:flutter/material.dart';
import 'bar_action.dart';

/// Light, dark, or follow the phone. The default is [system]: the best first
/// choice is the one the person already made for their whole phone.
///
/// Storage stays in the app. Persist [storageValue] and read it back with
/// [fromStorage]; anything missing or unrecognised falls back to
/// [defaultValue].
///
/// Wire it to `MaterialApp`:
///
/// ```dart
/// MaterialApp(
///   theme: OhTheme.light(appAccent: accent),
///   darkTheme: OhTheme.hearthDark(appAccent: accent), // or OhTheme.night()
///   themeMode: pref.themeMode,
/// )
/// ```
enum OhThemeModePreference {
  system,
  light,
  dark;

  static const defaultValue = OhThemeModePreference.system;

  ThemeMode get themeMode => switch (this) {
        OhThemeModePreference.system => ThemeMode.system,
        OhThemeModePreference.light => ThemeMode.light,
        OhThemeModePreference.dark => ThemeMode.dark,
      };

  /// The full name, for menus and Settings.
  String get label => switch (this) {
        OhThemeModePreference.system => 'Follow phone',
        OhThemeModePreference.light => 'Light',
        OhThemeModePreference.dark => 'Dark',
      };

  /// The app-bar label: short enough to sit beside the icon on a 320dp bar.
  String get shortLabel => switch (this) {
        OhThemeModePreference.system => 'Auto',
        OhThemeModePreference.light => 'Light',
        OhThemeModePreference.dark => 'Dark',
      };

  IconData get icon => switch (this) {
        OhThemeModePreference.system => Icons.brightness_auto_outlined,
        OhThemeModePreference.light => Icons.light_mode_outlined,
        OhThemeModePreference.dark => Icons.dark_mode_outlined,
      };

  /// The next mode in the cycle system → light → dark → system.
  OhThemeModePreference get next => values[(index + 1) % values.length];

  /// Which brightness this preference produces on a phone whose own setting
  /// is [platform]. Use `MediaQuery.platformBrightnessOf(context)`.
  Brightness resolve(Brightness platform) => switch (this) {
        OhThemeModePreference.system => platform,
        OhThemeModePreference.light => Brightness.light,
        OhThemeModePreference.dark => Brightness.dark,
      };

  String get storageValue => name;

  static OhThemeModePreference fromStorage(String? value) {
    for (final p in values) {
      if (p.name == value) return p;
    }
    return defaultValue;
  }
}

/// How [OhThemeToggle] responds to a tap.
enum OhThemeToggleBehavior {
  /// Opens a three-choice menu: two taps to any mode, and every choice is
  /// named before it is picked. The default.
  menu,

  /// Moves to the next mode on each tap: one tap, for bars with no room for
  /// a menu. The label always shows the mode you are in.
  cycle,
}

/// A compact theme control for an app bar: icon plus short label, showing
/// the current mode. Put one in every primary screen's bar so the theme is
/// never more than two taps away.
///
/// It holds no state; pass the app's stored [value] and persist what
/// [onChanged] reports.
///
/// Inside an [OhBarActions] row it folds like an [OhBarAction]: its word
/// stays while it fits beside a whole title, and otherwise it shows its
/// icon alone, with the same "Theme: …" name and a tooltip. Anywhere else
/// (a settings body) its word always shows.
class OhThemeToggle extends StatelessWidget {
  const OhThemeToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.behavior = OhThemeToggleBehavior.menu,
  });

  final OhThemeModePreference value;
  final ValueChanged<OhThemeModePreference> onChanged;
  final OhThemeToggleBehavior behavior;

  @override
  Widget build(BuildContext context) {
    // Follow the surrounding icon colour: inside an AppBar that is the bar's
    // foreground, so label and glyph match the other actions.
    final color = IconTheme.of(context).color ??
        Theme.of(context).colorScheme.onSurface;
    final style = TextButton.styleFrom(
      foregroundColor: color,
      iconColor: color,
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );

    final inRow = OhBarActions.inRow(context);

    Widget button(VoidCallback onPressed) {
      final worded = TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(value.icon),
        label: Text(
          value.shortLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
      return Semantics(
        label: 'Theme: ${value.label}',
        // Excluding the child's semantics drops its tap action too, so
        // hand the action back or a screen reader gets a dead button.
        excludeSemantics: true,
        button: true,
        onTap: onPressed,
        child: !inRow
            ? worded
            : OhBarFoldable(
                worded: worded,
                folded: Tooltip(
                  message: 'Theme: ${value.label}',
                  child: IconButton(
                    onPressed: onPressed,
                    color: color,
                    icon: Icon(value.icon),
                  ),
                ),
              ),
      );
    }

    if (behavior == OhThemeToggleBehavior.cycle) {
      return button(() => onChanged(value.next));
    }

    return MenuAnchor(
      menuChildren: [
        for (final p in OhThemeModePreference.values)
          MenuItemButton(
            leadingIcon: Icon(p.icon),
            trailingIcon: p == value ? const Icon(Icons.check) : null,
            onPressed: () => onChanged(p),
            child: Text(p.label),
          ),
      ],
      builder: (context, controller, _) => button(
        () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
