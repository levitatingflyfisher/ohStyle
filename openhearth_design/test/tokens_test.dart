// packages/openhearth_design/test/tokens_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openhearth_design/openhearth_design.dart';

void main() {
  group('OhColors — hearth palette', () {
    test('hearth50  is #FDF5F3', () => expect(OhColors.hearth50,  const Color(0xFFFDF5F3)));
    test('hearth100 is #F8E8E3', () => expect(OhColors.hearth100, const Color(0xFFF8E8E3)));
    test('hearth200 is #EDCDC5', () => expect(OhColors.hearth200, const Color(0xFFEDCDC5)));
    test('hearth300 is #D9A99E', () => expect(OhColors.hearth300, const Color(0xFFD9A99E)));
    test('hearth400 is #C47B6A', () => expect(OhColors.hearth400, const Color(0xFFC47B6A)));
    test('hearth500 is #A85040', () => expect(OhColors.hearth500, const Color(0xFFA85040)));
    test('hearth600 is #8B3E2F', () => expect(OhColors.hearth600, const Color(0xFF8B3E2F)));
    test('hearth700 is #6E2F22', () => expect(OhColors.hearth700, const Color(0xFF6E2F22)));
    test('hearth800 is #511F15', () => expect(OhColors.hearth800, const Color(0xFF511F15)));
    test('hearth900 is #370F09', () => expect(OhColors.hearth900, const Color(0xFF370F09)));
  });

  group('OhColors — linen palette', () {
    test('linen50  is #FBF8F4', () => expect(OhColors.linen50,  const Color(0xFFFBF8F4)));
    test('linen100 is #F5EFE6', () => expect(OhColors.linen100, const Color(0xFFF5EFE6)));
    test('linen200 is #EAE1D4', () => expect(OhColors.linen200, const Color(0xFFEAE1D4)));
    test('linen300 is #C7B9A0', () => expect(OhColors.linen300, const Color(0xFFC7B9A0)));
    test('linen400 is #B3A08A', () => expect(OhColors.linen400, const Color(0xFFB3A08A)));
    test('linen500 is #8C7B65', () => expect(OhColors.linen500, const Color(0xFF8C7B65)));
    test('linen600 is #6E5F4C', () => expect(OhColors.linen600, const Color(0xFF6E5F4C)));
    test('linen700 is #4D3E2E', () => expect(OhColors.linen700, const Color(0xFF4D3E2E)));
    test('linen800 is #35281C', () => expect(OhColors.linen800, const Color(0xFF35281C)));
    test('linen900 is #2C1810', () => expect(OhColors.linen900, const Color(0xFF2C1810)));
  });

  group('OhColors — sage, slate, accents, dark surfaces', () {
    test('sage100 is #E0EFEA', () => expect(OhColors.sage100, const Color(0xFFE0EFEA)));
    test('sage500 is #5E9478', () => expect(OhColors.sage500, const Color(0xFF5E9478)));
    test('slate500 is #5C7599', () => expect(OhColors.slate500, const Color(0xFF5C7599)));
    test('amber400 is #C49A3C', () => expect(OhColors.amber400, const Color(0xFFC49A3C)));
    test('red500 is #B0382A',   () => expect(OhColors.red500,   const Color(0xFFB0382A)));
    test('darkSurfaceBase     is #1C1007', () => expect(OhColors.darkSurfaceBase,     const Color(0xFF1C1007)));
    test('darkSurfaceCard     is #2A1A0D', () => expect(OhColors.darkSurfaceCard,     const Color(0xFF2A1A0D)));
    test('darkSurfaceElevated is #3A2215', () => expect(OhColors.darkSurfaceElevated, const Color(0xFF3A2215)));
    test('darkBorderDefault   is #6B4A34', () => expect(OhColors.darkBorderDefault,   const Color(0xFF6B4A34)));
  });

  group('OhSpacing — scale', () {
    test('xs=4, sm=8, md=16, lg=24, xl=40, xxl=64', () {
      expect(OhSpacing.xs,  4.0);
      expect(OhSpacing.sm,  8.0);
      expect(OhSpacing.md,  16.0);
      expect(OhSpacing.lg,  24.0);
      expect(OhSpacing.xl,  40.0);
      expect(OhSpacing.xxl, 64.0);
    });
  });

  group('OhSpacing — EdgeInsets', () {
    test('insetSm  is all(8)',                          () => expect(OhSpacing.insetSm,  const EdgeInsets.all(8)));
    test('insetMd  is all(16)',                         () => expect(OhSpacing.insetMd,  const EdgeInsets.all(16)));
    test('insetLg  is all(24)',                         () => expect(OhSpacing.insetLg,  const EdgeInsets.all(24)));
    test('insetHMd is symmetric(horizontal:16)',        () => expect(OhSpacing.insetHMd, const EdgeInsets.symmetric(horizontal: 16)));
    test('insetHLg is symmetric(horizontal:24)',        () => expect(OhSpacing.insetHLg, const EdgeInsets.symmetric(horizontal: 24)));
    test('insetVMd is symmetric(vertical:16)',          () => expect(OhSpacing.insetVMd, const EdgeInsets.symmetric(vertical: 16)));
    test('insetPage is symmetric(h:24,v:16)',           () => expect(OhSpacing.insetPage, const EdgeInsets.symmetric(horizontal: 24, vertical: 16)));
  });

  group('OhRadii', () {
    test('sm   is circular(4)',   () => expect(OhRadii.sm,   const BorderRadius.all(Radius.circular(4))));
    test('md   is circular(8)',   () => expect(OhRadii.md,   const BorderRadius.all(Radius.circular(8))));
    test('lg   is circular(12)',  () => expect(OhRadii.lg,   const BorderRadius.all(Radius.circular(12))));
    test('xl   is circular(16)',  () => expect(OhRadii.xl,   const BorderRadius.all(Radius.circular(16))));
    test('full is circular(999)', () => expect(OhRadii.full, const BorderRadius.all(Radius.circular(999))));
  });

  group('OhElevation', () {
    test('raised yields two warm shadow layers', () {
      final s = OhElevation.raised;
      expect(s, hasLength(2));
      expect(s.first.offset, const Offset(0, 1));
    });
    test('floating is stronger than raised', () {
      expect(OhElevation.floating.first.blurRadius,
          greaterThan(OhElevation.raised.first.blurRadius));
    });
    test('dark variants use pure-black shadow', () {
      expect(OhElevation.raisedDark.first.color.r, 0);
      expect(OhElevation.raisedDark.first.color.g, 0);
      expect(OhElevation.raisedDark.first.color.b, 0);
    });
  });

  group('OhMotion', () {
    test('durations are ordered ascending', () {
      expect(OhMotion.instant, lessThan(OhMotion.fast));
      expect(OhMotion.fast, lessThan(OhMotion.standard));
      expect(OhMotion.standard, lessThan(OhMotion.deliberate));
    });
    test('standard duration is 240ms', () {
      expect(OhMotion.standard, const Duration(milliseconds: 240));
    });
    test('decelerated curve is distinct from standard', () {
      expect(OhMotion.decelerated, isNot(equals(OhMotion.standardCurve)));
    });
  });
}
