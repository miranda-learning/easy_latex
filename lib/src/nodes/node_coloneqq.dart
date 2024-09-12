import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

class ColonEqqNode extends LatexRenderNode {
  ColonEqqNode({bool spacingRequired = false}) {
    super.spacingRequired = spacingRequired;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    size = Size(
      renderContext.fontSize * 0.7,
      LatexTextPainter.fontSizeToHeight(renderContext.fontSize),
    );
    baselineOffset =
        LatexTextPainter.fontSizeToBaseline(renderContext.fontSize);
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = renderContext?.color ?? const Color(0xFF000000);

    bool isSansSerif = renderContext?.font?.isSansSerif ?? false;

    double radius = isSansSerif ? fontSize * 0.064 : fontSize * 0.06;
    double lineHeight = isSansSerif ? fontSize * 0.08 : fontSize * 0.04;
    double horizontalPadding = fontSize * 0.06;
    double lineOffset = isSansSerif ? fontSize * 0.01 : lineHeight;

    canvas.drawCircle(
        Offset(start + radius + horizontalPadding, baseline - fontSize * 0.09),
        radius,
        paint);
    canvas.drawCircle(
        Offset(start + radius + horizontalPadding, baseline - fontSize * 0.39),
        radius,
        paint);

    canvas.drawRect(
        Rect.fromLTWH(
            start + radius * 3 + horizontalPadding,
            baseline - fontSize * 0.09 - lineOffset - lineHeight,
            size.width - 3 * radius - 2 * horizontalPadding,
            lineHeight),
        paint);

    canvas.drawRect(
        Rect.fromLTWH(
            start + radius * 3 + horizontalPadding,
            baseline - fontSize * 0.39 + lineOffset,
            size.width - 3 * radius - 2 * horizontalPadding,
            lineHeight),
        paint);
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    return '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
  }
}
