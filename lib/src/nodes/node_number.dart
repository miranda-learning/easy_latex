import 'package:flutter/widgets.dart';

import '../util/formatter_number.dart';
import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

class NumberNode extends LatexRenderNode {
  final String text;
  late LatexTextPainter _textPainter;
  String _formattedText = '';

  NumberNode(
    this.text, {
    bool spacingRequired = false,
  }) {
    super.spacingRequired = spacingRequired;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _formattedText =
        NumberFormatter.formattedNumber(text, locale: renderContext.locale) ??
            'Error formatting number';
    _textPainter =
        LatexTextPainter.withRenderContext(_formattedText, renderContext);
    _textPainter.layout();

    size = _textPainter.size;
    baselineOffset = _textPainter.baseline;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _textPainter.paint(canvas, Offset(start, baseline - baselineOffset));
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    for (var i = 0; i < _formattedText.length; i++) {
      offsets.add(Offset(
          start +
              _textPainter
                  .getOffsetForCaret(TextPosition(offset: i), Rect.zero)
                  .dx,
          baseline));
      fontSizes.add(fontSize);
    }
  }

  @override
  double get baselineToTop => (renderContext?.font?.isSansSerif ?? false)
      ? fontSize * 0.8
      : fontSize * 0.72;

  @override
  double get topRightOffset => fontSize * 0.01;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) =>
      '$indent$runtimeType: text: $text, formatted: $_formattedText, '
      'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
}
