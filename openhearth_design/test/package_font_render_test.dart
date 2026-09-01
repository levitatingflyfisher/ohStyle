import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

import 'support/package_fonts.dart';

/// The package's styles must render in the package's own fonts, so an app
/// that ships no Lora/Nunito of its own still draws the real type offline.
///
/// The check is metric, not only visual: the test font draws every glyph
/// exactly `fontSize` wide, so text that silently fell back to it measures
/// `chars × fontSize`. Real Nunito/Lora is proportional and never does.
const _sample = 'Hearth and home, illuminated';

double _width(TextStyle style) {
  final p = TextPainter(
    text: TextSpan(text: _sample, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  final w = p.width;
  p.dispose();
  return w;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPackageFontsAsConsumerSees);

  test('role styles name the package-prefixed families', () {
    expect(OhTypography.body().fontFamily, 'packages/openhearth_design/Nunito');
    expect(OhTypography.display().fontFamily, 'packages/openhearth_design/Lora');
    expect(OhTypography.materialTextTheme.bodyMedium!.fontFamily,
        'packages/openhearth_design/Nunito');
  });

  for (final (name, style, family) in [
    ('body', OhTypography.body(), 'packages/openhearth_design/Nunito'),
    ('display', OhTypography.display(), 'packages/openhearth_design/Lora'),
  ]) {
    test('$name lays out in the package font, not the test fallback', () {
      final size = style.fontSize!;
      final fallback = _sample.length * (size + (style.letterSpacing ?? 0));
      final w = _width(style);
      expect(w, isNot(closeTo(fallback, 0.5)),
          reason: '$name measured as the monospace test font');
      expect(
          w,
          closeTo(
              _width(TextStyle(
                  fontFamily: family,
                  fontSize: size,
                  fontWeight: style.fontWeight,
                  letterSpacing: style.letterSpacing)),
              0.01));
    });
  }

  testWidgets('a themed app paints Text in the package font', (tester) async {
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OhTheme.light(),
      home: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Headline(),
              SizedBox(height: 8),
              Text(_sample, key: Key('body')),
            ],
          ),
        ),
      ),
    ));

    final para = tester.renderObject<RenderParagraph>(
        find.descendant(of: find.byKey(const Key('body')), matching: find.byType(RichText)));
    final style = para.text.style!;
    // Through ThemeData.merge/copyWith the prefix survives, once.
    expect(style.fontFamily, 'packages/openhearth_design/Nunito');
    expect(para.size.width, isNot(closeTo(_sample.length * style.fontSize!, 0.5)));

    await expectLater(find.byType(Scaffold),
        matchesGoldenFile('goldens/package_font_render.png'));
  });
}

class _Headline extends StatelessWidget {
  const _Headline();
  @override
  Widget build(BuildContext context) =>
      Text('OpenHearth', style: Theme.of(context).textTheme.headlineMedium);
}
