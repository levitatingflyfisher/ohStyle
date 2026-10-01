import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A [Text] whose words never break mid-word.
///
/// For headlines and short labels where a big style meets a narrow line
/// (first seen in Reckon's empty Home: "de / cisions" at 320 dp x 3.0).
///
/// At large text sizes a big style can't fit its longest word on one line
/// (a 28 pt headline at 3x on a 320 dp phone breaks "de / cisions"). Then
/// this widget lowers the text scale just enough for that word to fit, and
/// no further: the text still grows with the reader's setting, only less.
class OhWholeWordsText extends StatelessWidget {
  const OhWholeWordsText(this.data, {super.key, this.style, this.textAlign});

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final scaler = MediaQuery.textScalerOf(context);
      final fitted = fittingScaler(
        context,
        data,
        DefaultTextStyle.of(context).style.merge(style),
        constraints.maxWidth,
        scaler,
      );
      final text = Text(data, style: style, textAlign: textAlign);
      if (identical(fitted, scaler)) return text;
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: fitted),
        child: text,
      );
    });
  }

  /// The largest scaler, no larger than [scaler], at which the longest word
  /// of [data] fits in [maxWidth]. Returns [scaler] itself when it already
  /// fits, and never goes below 1x.
  static TextScaler fittingScaler(BuildContext context, String data,
      TextStyle style, double maxWidth, TextScaler scaler) {
    if (!maxWidth.isFinite) return scaler;
    final words = data.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    double widest(TextScaler s) {
      var w = 0.0;
      for (final word in words) {
        final tp = TextPainter(
          text: TextSpan(text: word, style: style),
          textDirection: Directionality.of(context),
          textScaler: s,
          maxLines: 1,
        )..layout();
        w = math.max(w, tp.width);
        tp.dispose();
      }
      return w;
    }

    if (widest(scaler) <= maxWidth) return scaler;
    final size = style.fontSize ?? 14.0;
    final factor = scaler.scale(size) / size;
    // Glyph widths scale linearly with the font size, so one division
    // finds the factor; the loop absorbs rounding.
    var f = math.max(1.0, factor * maxWidth / widest(scaler));
    while (f > 1.0 && widest(TextScaler.linear(f)) > maxWidth) {
      f = math.max(1.0, f - 0.05);
    }
    return TextScaler.linear(f);
  }
}
