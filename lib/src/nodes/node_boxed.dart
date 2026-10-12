import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';

class BoxedNode extends LatexRenderNode {
  final LatexRenderNode child;

  double _horizontalPadding = 0;
  double _verticalPadding = 0;
  double _strokeWidth = 0;

  BoxedNode(this.child);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    child.performLayout(renderContext, isDense: isDense);

    _horizontalPadding = renderContext.fontSize * 0.2;
    _verticalPadding = renderContext.fontSize * 0.12;
    _strokeWidth = renderContext.fontSize * 0.04;

    size = Size(
      child.size.width + 2 * _horizontalPadding,
      child.size.height + 2 * _verticalPadding,
    );
    baselineOffset = child.baselineOffset + _verticalPadding;
    spacingRequired = child.spacingRequired;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    double inset = _strokeWidth / 2;
    Rect rect = Rect.fromLTWH(
      start + inset,
      baseline - baselineOffset + inset,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );

    canvas.drawRect(
      rect,
      Paint()
        ..color = renderContext!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth,
    );
    child.paint(canvas, start + _horizontalPadding, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    child.computeCursorPositions(
        start + _horizontalPadding, baseline, offsets, fontSizes);
  }

  @override
  double get baselineToTop => child.baselineToTop + _verticalPadding;

  @override
  bool get hasDescender => child.hasDescender;

  @override
  bool get isMultiline => child.isMultiline;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str =
        '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    str += '\n$indent  ${child.toStringWithIndent('$indent  ')}';
    return str;
  }
}
