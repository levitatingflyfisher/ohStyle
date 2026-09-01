import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

/// Ten apps stretched their phone layout edge to edge at 1024 px. `OhPage`
/// is the one centred live area.
void main() {
  const probe = Key('probe');

  Future<void> pumpAt(
    WidgetTester tester,
    Size size,
    Widget page, {
    EdgeInsets viewPadding = EdgeInsets.zero,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = FakeViewPadding(
      left: viewPadding.left,
      top: viewPadding.top,
      right: viewPadding.right,
      bottom: viewPadding.bottom,
    );
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: OhTheme.light(),
      home: Scaffold(body: page),
    ));
  }

  Widget page({double? maxWidth}) => OhPage(
        maxWidth: maxWidth ?? OhPage.phoneMaxWidth,
        child: const SizedBox(key: probe, height: 100, width: double.infinity),
      );

  test('phone-shaped default is 640', () {
    expect(OhPage.phoneMaxWidth, 640);
    expect(const OhPage(child: SizedBox()).maxWidth, 640);
  });

  testWidgets('at 1024 wide the content is capped and centred',
      (tester) async {
    await pumpAt(tester, const Size(1024, 768), page());
    final rect = tester.getRect(find.byKey(probe));
    expect(rect.width, lessThanOrEqualTo(640));
    expect(rect.center.dx, closeTo(512, 0.5));
  });

  testWidgets('on a phone it fills the width less the side gutter',
      (tester) async {
    await pumpAt(tester, const Size(360, 780), page());
    final rect = tester.getRect(find.byKey(probe));
    expect(rect.left, OhSpacing.md);
    expect(rect.right, 360 - OhSpacing.md);
  });

  testWidgets('the cap is configurable', (tester) async {
    await pumpAt(tester, const Size(1400, 900), page(maxWidth: 960));
    final rect = tester.getRect(find.byKey(probe));
    expect(rect.width, lessThanOrEqualTo(960));
    expect(rect.width, greaterThan(640));
    expect(rect.center.dx, closeTo(700, 0.5));
  });

  testWidgets('content is top-aligned, not vertically centred',
      (tester) async {
    await pumpAt(tester, const Size(1024, 768), page());
    expect(tester.getRect(find.byKey(probe)).top, lessThan(100));
  });

  testWidgets('respects the safe area (notch, cut-outs)', (tester) async {
    await pumpAt(
      tester,
      const Size(780, 360),
      page(),
      viewPadding: const EdgeInsets.only(left: 48, top: 24),
    );
    final rect = tester.getRect(find.byKey(probe));
    expect(rect.left, greaterThanOrEqualTo(48));
    expect(rect.top, greaterThanOrEqualTo(24));
  });

  testWidgets('a scrolling child still scrolls', (tester) async {
    await pumpAt(
      tester,
      const Size(1024, 400),
      OhPage(
        child: ListView(
          children: [
            for (var i = 0; i < 40; i++)
              SizedBox(height: 48, child: Text('row $i')),
          ],
        ),
      ),
    );
    expect(find.text('row 30'), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(find.text('row 30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('mouse wheel over the side margins', () {
    // On a 1400 px desktop window the live area is 640 px wide; the other
    // 760 px are margin. A wheel over the margin used to do nothing,
    // because nothing there was scrollable.
    Future<ScrollController> pumpList(WidgetTester tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await pumpAt(
        tester,
        const Size(1400, 600),
        OhPage(
          child: ListView(
            controller: controller,
            children: [
              for (var i = 0; i < 60; i++)
                SizedBox(height: 48, child: Text('row $i')),
            ],
          ),
        ),
      );
      return controller;
    }

    Future<void> wheel(WidgetTester tester, Offset at, double dy) async {
      final pointer = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(pointer.hover(at));
      await tester.sendEventToBinding(pointer.scroll(Offset(0, dy)));
      await tester.pump();
    }

    testWidgets('scrolls the content from the left margin', (tester) async {
      final c = await pumpList(tester);
      await wheel(tester, const Offset(40, 300), 200);
      expect(c.offset, 200);
    });

    testWidgets('scrolls the content from the right margin', (tester) async {
      final c = await pumpList(tester);
      await wheel(tester, const Offset(1360, 300), 150);
      expect(c.offset, 150);
    });

    testWidgets('over the content it scrolls once, not twice',
        (tester) async {
      final c = await pumpList(tester);
      await wheel(tester, const Offset(700, 300), 100);
      expect(c.offset, 100);
    });

    testWidgets('clamps at the ends like the list itself', (tester) async {
      final c = await pumpList(tester);
      await wheel(tester, const Offset(40, 300), -500);
      expect(c.offset, 0);
    });

    Future<ScrollController> pumpVariant(WidgetTester tester,
        {bool reverse = false, ScrollPhysics? physics}) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await pumpAt(
        tester,
        const Size(1400, 600),
        OhPage(
          child: ListView(
            controller: controller,
            reverse: reverse,
            physics: physics,
            children: [
              for (var i = 0; i < 60; i++)
                SizedBox(height: 48, child: Text('row $i')),
            ],
          ),
        ),
      );
      return controller;
    }

    testWidgets('a reversed list moves the same way from the margin as '
        'from the content', (tester) async {
      final c = await pumpVariant(tester, reverse: true);
      await wheel(tester, const Offset(700, 300), -120);
      final fromContent = c.offset;
      expect(fromContent, 120);
      c.jumpTo(0);
      await tester.pump();
      await wheel(tester, const Offset(40, 300), -120);
      expect(c.offset, fromContent);
    });

    testWidgets('a list that refuses user scrolling is left alone',
        (tester) async {
      final c = await pumpVariant(tester,
          physics: const NeverScrollableScrollPhysics());
      await wheel(tester, const Offset(40, 300), 200);
      expect(c.offset, 0);
    });

    testWidgets('a non-scrolling child ignores the wheel', (tester) async {
      await pumpAt(tester, const Size(1400, 600), page());
      await wheel(tester, const Offset(40, 300), 200);
      expect(tester.takeException(), isNull);
    });
  });
}
