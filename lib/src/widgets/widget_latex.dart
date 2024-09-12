import 'package:flutter/material.dart';

import '../enums.dart';
import '../font/latex_font.dart';
import '../parser/__export.dart';
import '../render/__export.dart';

/// A Flutter widget that renders LaTeX content.
///
/// This widget takes a LaTeX string and displays it on the screen with various customizable
/// properties to control its appearance and behavior. It provides detailed control over
/// font, color, alignment, and parsing behavior to accommodate different LaTeX rendering needs.
class Latex extends StatelessWidget {
  const Latex(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.color = Colors.black,
    this.backgroundColor,
    this.customFont,
    this.wrapMode = LatexWrapMode.none,
    this.textAlign,
    this.parsing = ParsingMode.minorErrorsAsRedPlaceholders,
    this.allPointsAsDecimalPoints = false,
    this.locale,
  });

  /// The LaTeX text to be rendered.
  final String text;

  /// The font size of the LaTeX text.
  final double fontSize;

  /// The color of the text.
  final Color color;

  /// The background color behind the text. Defaults to transparent if not specified.
  final Color? backgroundColor;

  /// Custom font settings for the LaTeX rendering.
  final LatexFont? customFont;

  /// Specifies how the text should wrap if it exceeds the available space.
  final LatexWrapMode wrapMode;

  /// The alignment of the text if it spans multiple lines.
  final MultiLineTextAlign? textAlign;

  /// The mode of parsing the LaTeX text.
  final ParsingMode parsing;

  /// Whether all points in the text should be considered as decimal points.
  ///
  /// This is particularly useful in languages where the decimal separator differs
  /// from the period (e.g., using a comma as in many European countries).
  final bool allPointsAsDecimalPoints;

  /// The locale to be used for determining the decimal separator in numbers.
  ///
  /// This setting adjusts numerical values in the LaTeX content to reflect the
  /// appropriate decimal separator for the specified locale.
  final String? locale;

  @override
  Widget build(BuildContext context) {
    try {
      return LatexRenderWidget(
        entryNode: LatexParser().parse(
          text,
          parsing: parsing,
          allPointsAsDecimalPoints: allPointsAsDecimalPoints,
        ),
        renderContext: RenderContext(
            font: customFont, fontSize: fontSize, color: color, locale: locale),
        backgroundColor: backgroundColor,
        wrapMode: wrapMode,
        textAlign: textAlign,
      );
    } catch (parsingError) {
      return Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.yellow,
            backgroundColor: Colors.red),
      );
    }
  }
}
