import 'package:flutter/widgets.dart';

import '../font/__export.dart';
import '../render/__export.dart';


class LatexTextPainter extends TextPainter {

  static double fontSizeToHeight(double fontSize) => (fontSize*1.173).roundToDouble();
  static double fontSizeToBaseline(double fontSize) => fontSize * 0.9003906;

  final String rawText;
  final double fontSize;
  final bool isBold;


  LatexTextPainter(this.rawText, {
    required this.fontSize,
    LatexFont? font,
    this.isBold = false,
    required Color color,
    Color? bgColor,
  }) :
    super(
      text: _buildTextSpan(rawText, fontSize, font, isBold, color, bgColor),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      enableRoundingHack: false,
    );

  factory LatexTextPainter.withRenderContext(String text, RenderContext renderContext) {
    return LatexTextPainter(text,
      fontSize: renderContext.fontSize,
      font: renderContext.font,
      isBold: renderContext.isBold,
      color: renderContext.color,
    );
  }

  static TextSpan _buildTextSpan(String text, double fontSize, LatexFont? font, bool isBold, Color color, Color? bgColor) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: font?.fontFamily ?? MainLatexFont().fontFamily,
        fontFamilyFallback: [MainLatexFont().fontFamily],
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.w700 : null,
        color: color,
        backgroundColor: bgColor,
      ),
    );
  }


  @override
  Size get size {

    double w = super.size.width;
    double wR = w.roundToDouble();
    double width = wR < w && (w - wR) < w*0.00042 ? w.floorToDouble() : w.ceilToDouble();

    return Size(
      width,
      super.size.height.ceilToDouble(),
    );
  }

  double get baseline {
    return super.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  }

}