import 'package:flutter/widgets.dart';

import '../util/__export.dart';
import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

class DecimalPointNode extends LatexRenderNode {
  late LatexTextPainter _textPainter;
  String point = '';

  DecimalPointNode();

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    point = NumberFormatter.decimalSeparator(locale: renderContext.locale);

    _textPainter = LatexTextPainter.withRenderContext(point, renderContext);
    _textPainter.layout();

    size = _textPainter.size;
    baselineOffset = _textPainter.baseline;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _textPainter.paint(canvas, Offset(start, baseline - baselineOffset));
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) =>
      '$indent$runtimeType: formatted: $point, '
      'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
}
