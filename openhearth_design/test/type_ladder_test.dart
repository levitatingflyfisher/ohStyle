import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

import 'support/all_styles.dart';

/// The type ladder, as checks.
///
/// The audit found one-pixel steps (11/12/14, 22/24, 56/57), a 0.88 step at
/// the head, two Material slots mapped to one role, and body leading at 150
/// to 160 percent. A level the eye cannot tell from its neighbour is not a
/// level; these tests make the ladder's promises fail loudly.
void main() {
  const ladder = OhTypography.ladder;
  final styles = allOhTextStyles();

  test('the ladder is ascending and at least 3 px per step', () {
    for (var i = 1; i < ladder.length; i++) {
      expect(ladder[i] - ladder[i - 1], greaterThanOrEqualTo(3),
          reason: '${ladder[i - 1]} → ${ladder[i]} is within 2 px');
    }
  });

  test('each step is a ~1.2 ratio (1.15 to 1.25)', () {
    for (var i = 1; i < ladder.length; i++) {
      final r = ladder[i] / ladder[i - 1];
      expect(r, inInclusiveRange(1.15, 1.25),
          reason: '${ladder[i - 1]} → ${ladder[i]} is ×${r.toStringAsFixed(3)}');
    }
  });

  test('nothing below 13 px', () {
    expect(ladder.first, 13);
  });

  for (final MapEntry(key: name, value: s) in styles.entries) {
    test('$name sits on the ladder', () {
      expect(s?.fontSize, isNotNull, reason: '$name sets no size');
      expect(ladder, contains(s!.fontSize),
          reason: '$name is ${s.fontSize} px, off the ladder $ladder');
    });
  }

  test('no two sizes in use are within 2 px of each other', () {
    final sizes = {for (final s in styles.values) s!.fontSize!}.toList()
      ..sort();
    for (var i = 1; i < sizes.length; i++) {
      expect(sizes[i] - sizes[i - 1], greaterThan(2),
          reason: '${sizes[i - 1]} and ${sizes[i]} are both in use');
    }
  });

  test('body and list leading is 120 to 140 percent', () {
    for (final s in [
      OhTypography.bodyLg(),
      OhTypography.body(),
      OhTypography.bodySm(),
      OhTypography.caption(),
      OhTypography.listTitle(),
      OhTypography.listSubtitle(),
    ]) {
      expect(s.height, inInclusiveRange(1.2, 1.4));
    }
  });

  for (final MapEntry(key: n, value: t) in {
    'light': OhTheme.light(),
    'hearthDark': OhTheme.hearthDark(),
    'night': OhTheme.night(),
  }.entries) {
    test('$n: labelMedium and labelSmall are different roles', () {
      final a = t.textTheme.labelMedium!, b = t.textTheme.labelSmall!;
      expect(
        (a.fontSize, a.fontWeight) == (b.fontSize, b.fontWeight),
        isFalse,
        reason: 'both slots render the same style',
      );
    });

    test('$n: a list row is title over detail, one step apart', () {
      final title = t.listTileTheme.titleTextStyle!;
      final sub = t.listTileTheme.subtitleTextStyle!;
      expect(title.fontSize! > sub.fontSize!, isTrue);
      expect(title.fontWeight!.value > sub.fontWeight!.value, isTrue);
    });
  }

  test('materialTextTheme labelMedium and labelSmall differ', () {
    const t = OhTypography.materialTextTheme;
    expect(t.labelMedium, isNot(t.labelSmall));
  });

  test('the headlines never ask for an unbundled Lora weight', () {
    final lora = styles.values
        .where((s) => s!.fontFamily == 'packages/openhearth_design/Lora')
        .toList();
    // Cannot pass by matching nothing: the five headline roles and six
    // materialTextTheme slots set Lora, plus the themes' copies of them.
    expect(lora.length, greaterThanOrEqualTo(11));
    for (final s in lora) {
      expect([FontWeight.w400, FontWeight.w500, FontWeight.w700],
          contains(s!.fontWeight ?? FontWeight.w400));
    }
  });
}
