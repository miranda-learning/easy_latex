import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';

enum ExtendedArrowDirection {
  left,
  right,
}

class ExtendedArrowNode extends LatexRenderNode {
  final LatexRenderNode label;
  final ExtendedArrowDirection direction;

  late double _labelBaselineOffset;
  late double _labelStartOffset;
  late double _arrowY;
  late Paint _paint;

  ExtendedArrowNode(this.label, this.direction) {
    spacingRequired = true;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    label.performLayout(
      renderContext.copyWith(
          fontSizeScaling: 0.7, mathStyle: LatexMathStyle.text),
      isDense: true,
    );

    double horizontalPadding = renderContext.fontSize * 0.3;
    double width = max(
        renderContext.fontSize * 1.5, label.size.width + 2 * horizontalPadding);
    double arrowHalfHeight = renderContext.fontSize * 0.13;
    double gap = renderContext.fontSize * 0.08;

    _arrowY = -renderContext.baselineToCenter;
    _labelBaselineOffset =
        _arrowY - gap - (label.size.height - label.baselineOffset);
    _labelStartOffset = width / 2 - label.size.width / 2;

    double top = min(
        _arrowY - arrowHalfHeight, _labelBaselineOffset - label.baselineOffset);
    double bottom = _arrowY + arrowHalfHeight;
    size = Size(width, bottom - top);
    baselineOffset = -top;

    _paint = Paint()
      ..color = renderContext.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = renderContext.mainFontSize / 28
      ..strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    label.paint(
        canvas, start + _labelStartOffset, baseline + _labelBaselineOffset);

    double edgePadding = fontSize * 0.08;
    double arrowHeadSize = fontSize * 0.13;
    double left = start + edgePadding;
    double right = start + size.width - edgePadding;
    double y = baseline + _arrowY;
    canvas.drawLine(Offset(left, y), Offset(right, y), _paint);

    if (direction == ExtendedArrowDirection.left) {
      canvas.drawLine(Offset(left + arrowHeadSize, y - arrowHeadSize),
          Offset(left, y), _paint);
      canvas.drawLine(Offset(left + arrowHeadSize, y + arrowHeadSize),
          Offset(left, y), _paint);
    } else {
      canvas.drawLine(Offset(right - arrowHeadSize, y - arrowHeadSize),
          Offset(right, y), _paint);
      canvas.drawLine(Offset(right - arrowHeadSize, y + arrowHeadSize),
          Offset(right, y), _paint);
    }
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    label.computeCursorPositions(start + _labelStartOffset,
        baseline + _labelBaselineOffset, offsets, fontSizes);
  }

  @override
  bool get isMultiline => false;

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType ($direction): '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    str += '\n${label.toStringWithIndent('$indent  ')}';
    return str;
  }
}
