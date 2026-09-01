import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Operator ruling (2026-09-26): theme is light / dark / follow phone,
/// reachable in one tap (at most two) from anywhere, and the default is
/// follow phone. Top-bar actions are icon plus a short label.
void main() {
  group('OhThemeModePreference', () {
    test('defaults to following the phone', () {
      expect(OhThemeModePreference.defaultValue, OhThemeModePreference.system);
      expect(OhThemeModePreference.defaultValue.themeMode, ThemeMode.system);
    });

    test('maps to ThemeMode', () {
      expect(OhThemeModePreference.light.themeMode, ThemeMode.light);
      expect(OhThemeModePreference.dark.themeMode, ThemeMode.dark);
    });

    test('round-trips through storage; unknown or missing is the default',
        () {
      for (final p in OhThemeModePreference.values) {
        expect(OhThemeModePreference.fromStorage(p.storageValue), p);
      }
      expect(OhThemeModePreference.fromStorage(null),
          OhThemeModePreference.system);
      expect(OhThemeModePreference.fromStorage('hearthDark'),
          OhThemeModePreference.system);
    });

    test('resolves against the platform brightness', () {
      expect(OhThemeModePreference.system.resolve(Brightness.dark),
          Brightness.dark);
      expect(OhThemeModePreference.system.resolve(Brightness.light),
          Brightness.light);
      expect(OhThemeModePreference.light.resolve(Brightness.dark),
          Brightness.light);
      expect(OhThemeModePreference.dark.resolve(Brightness.light),
          Brightness.dark);
    });

    test('cycles through all three', () {
      var p = OhThemeModePreference.system;
      final seen = <OhThemeModePreference>{};
      for (var i = 0; i < 3; i++) {
        seen.add(p);
        p = p.next;
      }
      expect(seen, OhThemeModePreference.values.toSet());
      expect(p, OhThemeModePreference.system);
    });

    test('has plain labels', () {
      expect(OhThemeModePreference.system.label, 'Follow phone');
      expect(OhThemeModePreference.light.label, 'Light');
      expect(OhThemeModePreference.dark.label, 'Dark');
    });
  });

  group('OhThemeToggle', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required OhThemeModePreference value,
      required ValueChanged<OhThemeModePreference> onChanged,
      OhThemeToggleBehavior behavior = OhThemeToggleBehavior.menu,
      ThemeData? theme,
      Size size = const Size(400, 800),
      double textScale = 1.0,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: theme ?? OhTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Pantry'),
              actions: [
                OhThemeToggle(
                  value: value,
                  onChanged: onChanged,
                  behavior: behavior,
                ),
              ],
            ),
          ),
        ),
      ));
    }

    testWidgets('shows an icon and a short label for the current mode',
        (tester) async {
      await pumpBar(tester,
          value: OhThemeModePreference.system, onChanged: (_) {});
      expect(find.byIcon(OhThemeModePreference.system.icon), findsOneWidget);
      expect(find.text(OhThemeModePreference.system.shortLabel),
          findsOneWidget);
    });

    testWidgets('menu: two taps reach any of the three choices',
        (tester) async {
      OhThemeModePreference? picked;
      await pumpBar(tester,
          value: OhThemeModePreference.system, onChanged: (p) => picked = p);
      await tester.tap(find.byType(OhThemeToggle));
      await tester.pumpAndSettle();
      for (final p in OhThemeModePreference.values) {
        expect(find.text(p.label), findsOneWidget);
      }
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(picked, OhThemeModePreference.dark);
    });

    testWidgets('cycle: one tap moves to the next mode', (tester) async {
      OhThemeModePreference? picked;
      await pumpBar(tester,
          value: OhThemeModePreference.light,
          onChanged: (p) => picked = p,
          behavior: OhThemeToggleBehavior.cycle);
      await tester.tap(find.byType(OhThemeToggle));
      await tester.pump();
      expect(picked, OhThemeModePreference.light.next);
    });

    for (final behavior in OhThemeToggleBehavior.values) {
      testWidgets('screen readers get a named, tappable button (${behavior.name})',
          (tester) async {
        final handle = tester.ensureSemantics();
        OhThemeModePreference? picked;
        await pumpBar(tester,
            value: OhThemeModePreference.system,
            onChanged: (p) => picked = p,
            behavior: behavior);
        expect(
          tester.getSemantics(find.bySemanticsLabel('Theme: Follow phone')),
          matchesSemantics(
            isButton: true,
            hasTapAction: true,
            label: 'Theme: Follow phone',
          ),
        );
        if (behavior == OhThemeToggleBehavior.cycle) {
          tester.semantics.tap(find.semantics.byLabel('Theme: Follow phone'));
          await tester.pump();
          expect(picked, OhThemeModePreference.light);
        }
        handle.dispose();
      });
    }

    testWidgets('is at least 48dp tall', (tester) async {
      await pumpBar(tester,
          value: OhThemeModePreference.dark, onChanged: (_) {});
      expect(tester.getSize(find.byType(OhThemeToggle)).height,
          greaterThanOrEqualTo(48));
    });

    testWidgets('fits an app bar at 320dp and 2.0 text scale',
        (tester) async {
      await pumpBar(tester,
          value: OhThemeModePreference.system,
          onChanged: (_) {},
          size: const Size(320, 640),
          textScale: 2.0);
      expect(tester.takeException(), isNull);
    });

    double luminance(Color c) => c.computeLuminance();
    double contrast(Color a, Color b) {
      final la = luminance(a), lb = luminance(b);
      return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
    }

    for (final entry in <String, ThemeData Function()>{
      'light': OhTheme.light,
      'hearthDark': OhTheme.hearthDark,
      'night': OhTheme.night,
    }.entries) {
      testWidgets('label and icon are legible in the app bar under '
          '${entry.key}', (tester) async {
        final theme = entry.value();
        await pumpBar(tester,
            value: OhThemeModePreference.system,
            onChanged: (_) {},
            theme: theme);
        // OhTheme's AppBar is transparent, so the scaffold shows through.
        final bg = theme.scaffoldBackgroundColor;
        final iconCtx = tester
            .element(find.byIcon(OhThemeModePreference.system.icon));
        final iconColor = IconTheme.of(iconCtx).color!;
        final labelColor = tester
            .renderObject<RenderParagraph>(
                find.text(OhThemeModePreference.system.shortLabel))
            .text
            .style!
            .color!;
        expect(contrast(iconColor, bg), greaterThanOrEqualTo(3.0));
        expect(contrast(labelColor, bg), greaterThanOrEqualTo(4.5));
      });
    }
  });
}
