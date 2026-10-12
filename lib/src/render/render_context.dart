import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../font/__export.dart';
import 'math_style.dart';

class RenderContext {
  final LatexFont? font;
  final double fontSize; // font size of current node
  final double mainFontSize; // font size of initial node
  final bool isBold;
  final Color color;
  final String? locale;
  final LatexMathStyle mathStyle;

  // getters
  double get baselineToCenter => fontSize * 0.3;

  RenderContext({
    this.font,
    double? fontSize,
    double? mainFontSize,
    this.isBold = false,
    Color? color,
    this.locale,
    this.mathStyle = LatexMathStyle.display,
  })  : fontSize = fontSize ?? 16,
        mainFontSize = mainFontSize ?? fontSize ?? 16,
        color = color ?? const Color.fromRGBO(0, 0, 0, 1);

  RenderContext copyWith({
    LatexFont? font,
    double? fontSize,
    double? parentFontSize,
    double fontSizeScaling = 1,
    bool? isBold,
    Color? color,
    LatexMathStyle? mathStyle,
  }) {
    return RenderContext(
      font: font ?? this.font,
      fontSize: (fontSize ?? this.fontSize) * fontSizeScaling,
      mainFontSize: mainFontSize,
      isBold: isBold ?? this.isBold,
      color: color ?? this.color,
      locale: locale,
      mathStyle: mathStyle ?? this.mathStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RenderContext &&
            font == other.font &&
            fontSize == other.fontSize &&
            mainFontSize == other.mainFontSize &&
            isBold == other.isBold &&
            color == other.color &&
            locale == other.locale &&
            mathStyle == other.mathStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
        font, fontSize, mainFontSize, isBold, color, locale, mathStyle);
  }
}
