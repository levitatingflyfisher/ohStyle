import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

import 'support/package_fonts.dart';

/// A big style at large text cannot fit its longest word on a narrow line,
/// so it broke mid-word ("de / cisions": Reckon's empty Home at 320 dp x
/// 3.0). `OhWholeWordsText` lowers the text scale just enough for the
/// longest word to fit, never below 1x.
void main() {
  setUpAll(loadPackageFontsAsConsumerSees);

  void expectWordsWhole(WidgetTester tester, String text) {
    final para = tester.renderObject<RenderParagraph>(
        find.descendant(of: find.text(text), matching: find.byType(RichText)));
    for (final m in RegExp(r'\S+').allMatches(text)) {
      final tops = para
          .getBoxesForSelection(
              TextSelection(baseOffset: m.start, extentOffset: m.end))
          .map((b) => b.top.round())
          .toSet();
      expect(tops, hasLength(1), reason: '"${m.group(0)}" breaks');
    }
  }

  Future<void> pump(WidgetTester tester, double width, double scale,
      Widget child) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: OhTheme.light(),
      builder: (c, w) => MediaQuery(
          data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
          child: w!),
      home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(32), child: child)),
    ));
  }

  const text = 'No open decisions yet.';
  for (final scale in [1.0, 2.0, 3.0]) {
    testWidgets('words stay whole at 320 dp x $scale', (tester) async {
      await pump(
          tester,
          320,
          scale,
          Builder(
              builder: (c) => OhWholeWordsText(text,
                  style: Theme.of(c).textTheme.headlineMedium)));
      expectWordsWhole(tester, text);
      final para = tester.renderObject<RenderParagraph>(find.descendant(
          of: find.text(text), matching: find.byType(RichText)));
      final factor = para.textScaler.scale(10) / 10;
      expect(factor, greaterThanOrEqualTo(1.0));
      expect(factor, lessThanOrEqualTo(scale + 1e-9));
      if (scale > 1) expect(factor, greaterThan(1.0), reason: 'still grows');
    });
  }

  testWidgets('a line that already fits keeps the reader\'s scale',
      (tester) async {
    await pump(tester, 360, 2.0, const OhWholeWordsText('Hi there'));
    final para = tester.renderObject<RenderParagraph>(find.descendant(
        of: find.text('Hi there'), matching: find.byType(RichText)));
    expect(para.textScaler.scale(10) / 10, closeTo(2.0, 1e-9));
  });
}
