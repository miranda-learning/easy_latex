import 'package:flutter/material.dart';

import '../enums.dart';
import '../parser/__export.dart';
import '../render/__export.dart';

/// A widget span that allows LaTeX to be used within text spans.
///
/// This class is used to embed LaTeX rendering within a larger body of text, such as
/// in [RichText] or any other text-displaying widget that supports [InlineSpan].
///
/// ATTENTION: The LatexSpan widget does not inherit fontSize and color (font color)
/// from the parent TextSpan. These attributes must be explicitly defined via the style
/// attribute for each LatexSpan.
class LatexSpan extends WidgetSpan {
  /// Constructs a `LatexSpan` to render LaTeX within text hierarchies.
  ///
  /// The LaTeX content provided in [text] will be rendered according to the styles and
  /// modes specified by the parameters. This class handles both the styling and parsing
  /// nuances required to integrate LaTeX seamlessly with other text content.
  LatexSpan({
    required this.text,
    super.style,
    final Color? backgroundColor,
    LatexWrapMode wrapMode = LatexWrapMode.none,
    ParsingMode parsing = ParsingMode.minorErrorsAsRedPlaceholders,
    bool allPointsAsDecimalPoints = false,
    String? locale,
  }) : super(
          child: _buildChild(text, style, backgroundColor, wrapMode, parsing,
              allPointsAsDecimalPoints, locale),
          baseline: TextBaseline.alphabetic,
          alignment: PlaceholderAlignment.baseline,
        );

  /// The LaTeX text to be rendered.
  final String text;

  static Widget _buildChild(
    String text,
    TextStyle? style,
    Color? backgroundColor,
    LatexWrapMode wrapMode,
    ParsingMode parsing,
    bool allPointsAsDecimalPoints,
    String? locale,
  ) {
    try {
      return LatexRenderWidget(
        entryNode: LatexParser().parse(
          text,
          allPointsAsDecimalPoints: allPointsAsDecimalPoints,
          parsing: parsing,
        ),
        renderContext: RenderContext(
            fontSize: style?.fontSize, color: style?.color, locale: locale),
        backgroundColor: backgroundColor,
        wrapMode: wrapMode,
      );
    } catch (parsingError) {
      return Text(
        text,
        style: TextStyle(
            fontSize: style?.fontSize,
            color: Colors.yellow,
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  void computeToPlainText(
    StringBuffer buffer, {
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    buffer.write(text);
  }
}
