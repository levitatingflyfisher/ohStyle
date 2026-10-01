import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

import 'support/package_fonts.dart';

/// The code face must draw on the web.
///
/// 'monospace' is a platform family. Android resolves it; a Flutter web
/// build has no platform fonts, and once the PWAs stopped loading Roboto
/// from Google's CDN (conformance C13) CanvasKit drew 'monospace' text as
/// nothing at all (seen in Chromium on WeatherGlass). So on the web [code]
/// uses the bundled Nunito, whose digits are all one width (600 units in
/// every weight), and native keeps the platform monospace.
double _width(String text, TextStyle style) {
  final p = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  final w = p.width;
  p.dispose();
  return w;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPackageFontsAsConsumerSees);

  test('native keeps the platform monospace, with no package prefix', () {
    // A package prefix would ask for packages/openhearth_design/monospace,
    // which exists nowhere.
    expect(OhTypography.code(web: false).fontFamily, 'monospace');
    expect(OhTypography.code().fontFamily, 'monospace',
        reason: 'flutter test runs on the VM, so the default is native');
  });

  test('the web draws code in the bundled Nunito', () {
    expect(OhTypography.code(web: true).fontFamily,
        'packages/openhearth_design/Nunito');
  });

  test('web code digits are tabular and really in Nunito', () {
    final style = OhTypography.code(web: true);
    final size = style.fontSize!;
    final w0 = _width('0000', style);
    final w1 = _width('1111', style);
    expect(w0, closeTo(w1, 0.01), reason: 'digits must line up in columns');
    // The test font draws every glyph exactly fontSize wide; Nunito's
    // digits are 0.6 em.
    expect(w0, isNot(closeTo(4 * size, 0.5)),
        reason: 'measured as the test fallback font, not Nunito');
    expect(w0, closeTo(4 * size * 0.6, 0.5));
  });

  test('neither face inherits, so no ambient package can prefix it', () {
    const ambient = TextStyle(
        fontFamily: 'Nunito', package: 'openhearth_design', fontSize: 16);
    expect(OhTypography.code(web: false).inherit, isFalse);
    expect(OhTypography.code(web: true).inherit, isFalse);
    expect(ambient.merge(OhTypography.code(web: false)).fontFamily,
        'monospace');
  });

  test('both faces keep the same size, weight and line height', () {
    final web = OhTypography.code(web: true, color: Colors.red);
    final native = OhTypography.code(web: false, color: Colors.red);
    expect(web.fontSize, native.fontSize);
    expect(web.fontWeight, native.fontWeight);
    expect(web.height, native.height);
    expect(web.color, Colors.red);
  });

  // A themed Text merges its style into the ambient DefaultTextStyle, and
  // every ohStyle theme style carries package: 'openhearth_design'.
  // TextStyle.merge keeps the ambient package when the incoming style has
  // none, so an inheriting 'monospace' became
  // 'packages/openhearth_design/monospace', a family nothing answers to
  // (native fell back to the proportional default face). code() must reach
  // the engine with its own family, and with the colour it was given, in
  // every theme and in both a Text and a TextField.
  for (final (name, theme) in [
    ('light', OhTheme.light()),
    ('hearthDark', OhTheme.hearthDark()),
    ('night', OhTheme.night()),
  ]) {
    for (final web in [false, true]) {
      final want = web ? 'packages/openhearth_design/Nunito' : 'monospace';
      final face = web ? 'web' : 'native';

      testWidgets('$face code() resolves to $want in a themed Text ($name)',
          (tester) async {
        final color = theme.colorScheme.onSurface;
        await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Text('ABC-123',
                style: OhTypography.code(color: color, web: web)),
          ),
        ));
        final drawn = tester
            .widget<RichText>(find.descendant(
                of: find.byType(Text), matching: find.byType(RichText)))
            .text
            .style!;
        expect(drawn.fontFamily, want);
        expect(drawn.color, color);
        expect(drawn.fontSize, 13);
      });

      testWidgets('$face code() resolves to $want in a TextField ($name)',
          (tester) async {
        final color = theme.colorScheme.onSurface;
        await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Scaffold(
            body: TextField(style: OhTypography.code(color: color, web: web)),
          ),
        ));
        final drawn = tester.widget<EditableText>(find.byType(EditableText))
            .style;
        expect(drawn.fontFamily, want);
        expect(drawn.color, color);
      });
    }
  }
}
