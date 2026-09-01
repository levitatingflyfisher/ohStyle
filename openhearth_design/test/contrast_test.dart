import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// WCAG 2.x contrast for every text/background and mark/background pair the
/// three built themes actually wire.
///
/// It reads the `ThemeData` each builder returns, not a table of constants:
/// a role table can be perfect while `theme.dart` still hands the input hint
/// a 2.2:1 grey. Floors (WCAG 2.2 AA):
///
/// - 4.5:1 for body and secondary text (SC 1.4.3);
/// - 3:1 for UI marks — icons, rings, the border that is a field's only
///   sign (SC 1.4.11).
///
/// Every theme is measured against every ground a text can land on in it:
/// the scaffold, the card (`colorScheme.surface`) and the raised container
/// (`surfaceContainerHighest`).

double _channel(double c) =>
    c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color c) =>
    0.2126 * _channel(c.r) + 0.7152 * _channel(c.g) + 0.0722 * _channel(c.b);

double contrast(Color a, Color b) {
  final la = _luminance(a), lb = _luminance(b);
  final hi = math.max(la, lb), lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

const _text = 4.5;
const _mark = 3.0;


void main() {
  test('the contrast helper matches WCAG reference values', () {
    expect(contrast(Colors.black, Colors.white), closeTo(21.0, 0.01));
    expect(contrast(const Color(0xFF777777), Colors.white), closeTo(4.48, 0.01));
  });

  final themes = <String, ThemeData>{
    'light': OhTheme.light(),
    'hearthDark': OhTheme.hearthDark(),
    'night': OhTheme.night(),
  };

  for (final MapEntry(key: name, value: t) in themes.entries) {
    group('$name contrast', () {
      final cs = t.colorScheme;
      final grounds = <String, Color>{
        'scaffold': t.scaffoldBackgroundColor,
        'surface': cs.surface,
        'surfaceContainerHighest': cs.surfaceContainerHighest,
      };

      // (label, foreground, background, floor)
      final pairs = <(String, Color, Color, double)>[
        ('onPrimary on primary', cs.onPrimary, cs.primary, _text),
        ('onError on error', cs.onError, cs.error, _text),
        ('onErrorContainer on errorContainer', cs.onErrorContainer,
            cs.errorContainer, _text),
      ];

      for (final g in grounds.entries) {
        pairs.addAll([
          ('onSurface on ${g.key}', cs.onSurface, g.value, _text),
          ('onSurfaceVariant on ${g.key}', cs.onSurfaceVariant, g.value, _text),
          ('error on ${g.key}', cs.error, g.value, _text),
          ('primary (text button) on ${g.key}', cs.primary, g.value, _text),
          ('iconTheme on ${g.key}', t.iconTheme.color!, g.value, _mark),
          ('listTile title on ${g.key}',
              t.listTileTheme.titleTextStyle!.color!, g.value, _text),
          ('listTile subtitle on ${g.key}',
              t.listTileTheme.subtitleTextStyle!.color!, g.value, _text),
        ]);
        final tt = t.textTheme;
        final slots = <String, TextStyle?>{
          'displayLarge': tt.displayLarge,
          'displayMedium': tt.displayMedium,
          'displaySmall': tt.displaySmall,
          'headlineLarge': tt.headlineLarge,
          'headlineMedium': tt.headlineMedium,
          'headlineSmall': tt.headlineSmall,
          'titleLarge': tt.titleLarge,
          'titleMedium': tt.titleMedium,
          'titleSmall': tt.titleSmall,
          'bodyLarge': tt.bodyLarge,
          'bodyMedium': tt.bodyMedium,
          'bodySmall': tt.bodySmall,
          'labelLarge': tt.labelLarge,
          'labelMedium': tt.labelMedium,
          'labelSmall': tt.labelSmall,
        };
        for (final s in slots.entries) {
          pairs.add(('textTheme.${s.key} on ${g.key}', s.value!.color!,
              g.value, _text));
        }
      }

      final input = t.inputDecorationTheme;
      final fill = input.fillColor!;
      pairs.addAll([
        ('input hint on fill', input.hintStyle!.color!, fill, _text),
        ('input label on fill', input.labelStyle!.color!, fill, _text),
        ('input enabledBorder on fill',
            (input.enabledBorder! as OutlineInputBorder).borderSide.color,
            fill, _mark),
        ('input enabledBorder on scaffold',
            (input.enabledBorder! as OutlineInputBorder).borderSide.color,
            t.scaffoldBackgroundColor, _mark),
      ]);

      // The colour-language roles the theme carries (OhColorRoles).
      final r = t.extension<OhColorRoles>()!;
      for (final g in grounds.entries) {
        final texts = <String, Color>{
          'textPrimary': r.textPrimary,
          'textSecondary': r.textSecondary,
          'textLabel': r.textLabel,
          'warmth': r.warmth,
          'urgency': r.urgency,
          'warningText': r.warningText,
          'success': r.success,
          'attention': r.attention,
          'info': r.info,
        };
        for (final e in texts.entries) {
          pairs.add(('roles.${e.key} on ${g.key}', e.value, g.value, _text));
        }
        final marks = <String, Color>{
          'warningIcon': r.warningIcon,
          'icon': r.icon,
          'controlBorder': r.controlBorder,
        };
        for (final e in marks.entries) {
          pairs.add(('roles.${e.key} on ${g.key}', e.value, g.value, _mark));
        }
      }
      final raised = cs.surfaceContainerHighest;
      pairs.addAll([
        ('roles.warmthPressed on surfaceContainerHighest', r.warmthPressed,
            raised, _text),
        ('roles.onWarmth on warmth', r.onWarmth, r.warmth, _text),
        ('roles.onWarmth on warmthPressed', r.onWarmth, r.warmthPressed, _text),
        ('roles.onUrgency on urgency', r.onUrgency, r.urgency, _text),
        ('roles.onAttention on attention', r.onAttention, r.attention, _text),
        ('roles.urgency on urgencySurface', r.urgency, r.urgencySurface, _text),
        ('roles.textPrimary on urgencySurface', r.textPrimary,
            r.urgencySurface, _text),
        ('roles.warningText on warningSurface', r.warningText,
            r.warningSurface, _text),
        ('roles.warningIcon on warningSurface', r.warningIcon,
            r.warningSurface, _mark),
        ('roles.success on successSurface', r.success, r.successSurface, _text),
        ('roles.attention on attentionSurface', r.attention,
            r.attentionSurface, _text),
      ]);

      for (final (label, fg, bg, floor) in pairs) {
        test('$label clears $floor:1', () {
          final r = contrast(fg, bg);
          expect(r, greaterThanOrEqualTo(floor),
              reason: '$name: $label is ${r.toStringAsFixed(2)}:1 '
                  '(${_hex(fg)} on ${_hex(bg)}), floor $floor:1');
        });
      }
    });
  }

  // Top-bar ink, as rendered: the word and glyph of an OhBarAction and the
  // theme toggle inside a real AppBar, against what the bar actually shows
  // (its Material colour composited over the scaffold, since OhTheme's bar
  // is transparent), at rest and scrolled under.
  for (final MapEntry(key: name, value: t) in themes.entries) {
    for (final scrolled in [false, true]) {
      testWidgets('$name bar ink clears $_text:1'
          '${scrolled ? ' when scrolled under' : ''}', (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: t,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Bar'),
              actions: [
                OhBarActions(children: [
                  OhBarAction(
                      icon: Icons.refresh, label: 'Refresh', onPressed: () {}),
                  OhThemeToggle(
                      value: OhThemeModePreference.system,
                      onChanged: (_) {}),
                ]),
              ],
            ),
            body: ListView(children: [
              for (var i = 0; i < 60; i++)
                SizedBox(height: 40, child: Text('$i')),
            ]),
          ),
        ));
        if (scrolled) {
          await tester.drag(find.byType(ListView), const Offset(0, -400));
          await tester.pumpAndSettle();
        }
        final material = tester.widget<Material>(find
            .descendant(of: find.byType(AppBar), matching: find.byType(Material))
            .first);
        var bg = Color.alphaBlend(
            material.color ?? Colors.transparent, t.scaffoldBackgroundColor);
        final tint = material.surfaceTintColor;
        if (tint != null && material.elevation > 0) {
          bg = ElevationOverlay.applySurfaceTint(bg, tint, material.elevation);
        }
        Color colorOf(Finder f) => tester
            .widget<RichText>(
                find.descendant(of: f, matching: find.byType(RichText)).first)
            .text
            .style!
            .color!;
        for (final (what, finder) in [
          ('word "Refresh"', find.text('Refresh')),
          ('word "Auto"', find.text('Auto')),
          ('glyph', find.byIcon(Icons.refresh)),
        ]) {
          final fg = colorOf(finder);
          final r = contrast(fg, bg);
          expect(r, greaterThanOrEqualTo(_text),
              reason: '$name bar $what is ${r.toStringAsFixed(2)}:1 '
                  '(${_hex(fg)} on ${_hex(bg)})');
        }
      });
    }
  }
}
