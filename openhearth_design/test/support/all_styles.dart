import 'package:flutter/material.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Every TextStyle the package hands out, by name: each role method, every
/// `materialTextTheme` slot, all three themes' text themes, and the
/// component styles the themes set (app bar, buttons, list tiles).
///
/// Shared by the ladder and font-bundle tests so a style added to one
/// enumeration is checked by both. A new role method must be added here.
Map<String, TextStyle?> allOhTextStyles() {
  final styles = <String, TextStyle?>{
    'display': OhTypography.display(),
    'headline1': OhTypography.headline1(),
    'headline2': OhTypography.headline2(),
    'headline3': OhTypography.headline3(),
    'headline4': OhTypography.headline4(),
    'title': OhTypography.title(),
    'titleSm': OhTypography.titleSm(),
    'bodyLg': OhTypography.bodyLg(),
    'body': OhTypography.body(),
    'bodySm': OhTypography.bodySm(),
    'label': OhTypography.label(),
    'labelSm': OhTypography.labelSm(),
    'caption': OhTypography.caption(),
    'button': OhTypography.button(),
    'buttonSm': OhTypography.buttonSm(),
    'listTitle': OhTypography.listTitle(),
    'listSubtitle': OhTypography.listSubtitle(),
    'code': OhTypography.code(),
    'code.web': OhTypography.code(web: true),
  };

  void addTextTheme(String prefix, TextTheme tt) {
    styles.addAll({
      '$prefix.displayLarge': tt.displayLarge,
      '$prefix.displayMedium': tt.displayMedium,
      '$prefix.displaySmall': tt.displaySmall,
      '$prefix.headlineLarge': tt.headlineLarge,
      '$prefix.headlineMedium': tt.headlineMedium,
      '$prefix.headlineSmall': tt.headlineSmall,
      '$prefix.titleLarge': tt.titleLarge,
      '$prefix.titleMedium': tt.titleMedium,
      '$prefix.titleSmall': tt.titleSmall,
      '$prefix.bodyLarge': tt.bodyLarge,
      '$prefix.bodyMedium': tt.bodyMedium,
      '$prefix.bodySmall': tt.bodySmall,
      '$prefix.labelLarge': tt.labelLarge,
      '$prefix.labelMedium': tt.labelMedium,
      '$prefix.labelSmall': tt.labelSmall,
    });
  }

  addTextTheme('materialTextTheme', OhTypography.materialTextTheme);
  final themes = {
    'light': OhTheme.light(),
    'hearthDark': OhTheme.hearthDark(),
    'night': OhTheme.night(),
  };
  for (final MapEntry(key: n, value: t) in themes.entries) {
    addTextTheme('$n.textTheme', t.textTheme);
    styles['$n.appBar.title'] = t.appBarTheme.titleTextStyle;
    styles['$n.elevatedButton'] =
        t.elevatedButtonTheme.style?.textStyle?.resolve({});
    styles['$n.outlinedButton'] =
        t.outlinedButtonTheme.style?.textStyle?.resolve({});
    styles['$n.textButton'] = t.textButtonTheme.style?.textStyle?.resolve({});
    styles['$n.listTile.title'] = t.listTileTheme.titleTextStyle;
    styles['$n.listTile.subtitle'] = t.listTileTheme.subtitleTextStyle;
  }
  return styles;
}
