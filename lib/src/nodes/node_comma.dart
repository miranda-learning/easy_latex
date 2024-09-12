import 'package:flutter/widgets.dart';

import '../util/__export.dart';
import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

class CommaNode extends LatexRenderNode {
  final bool isListSeparator;
  String comma = '';
  late LatexTextPainter _textPainter;

  CommaNode({
    this.isListSeparator = false,
    bool spacingRequired = false,
  }) {
    super.spacingRequired = spacingRequired;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    comma = NumberFormatter.commaSeparator(locale: renderContext.locale);
    comma += '\u200A';

    _textPainter = LatexTextPainter.withRenderContext(comma, renderContext);
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
      '$indent$runtimeType: formatted: $comma, '
      'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
}
