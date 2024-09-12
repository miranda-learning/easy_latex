import 'dart:math';

import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

enum BottomDecoration {
  underbrace,
  underline;
}

class BottomDecorationNode extends LatexRenderNode {
  final LatexRenderNode child;
  final BottomDecoration decoration;

  BottomDecorationNode(this.child, this.decoration);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    child.performLayout(renderContext);

    baselineOffset = max(child.baselineOffset, baselineToTop);
    spacingRequired = child.spacingRequired;

    double width = child.size.width;
    double height = child.size.height - child.baselineOffset + baselineOffset;

    if (decoration == BottomDecoration.underbrace) {
      height += fontSize * 0.25;
      if (child.hasDescender && !child.isMultiline) height += fontSize * 0.15;
    } else {
      height += fontSize * 0.1;
    }

    size = Size(width, height);
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    drawPaths(canvas, start, baseline);
    if (child.size.width < size.width)
      start += (size.width - child.size.width) / 2;
    child.paint(canvas, start, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    child.computeCursorPositions(start, baseline, offsets, fontSizes);
  }

  @override
  double get topCenterOffset => child.topCenterOffset;

  @override
  double get topRightOffset => child.topRightOffset;

  @override
  bool get isMultiline => child.isMultiline;

  @override
  double get baselineToTop => child.baselineToTop;

  void drawPaths(Canvas canvas, double start, double baseline) {
    if (decoration == BottomDecoration.underbrace) {
      Path path = BracketPainter.getCurlyBracketPath(
          fontSize * 0.4, child.size.width, fontSize);
      path = LPainter.rotatePath(path, 270);

      double y = fontSize * 1.4;
      if (child.hasDescender && !child.isMultiline) y += fontSize * 0.15;
      path = LPainter.translatePath(path, start + child.size.width / 2, y);
      canvas.drawPath(path, Paint()..color = renderContext!.color);
    } else if (decoration == BottomDecoration.underline) {
      Paint paint = Paint()
        ..color = renderContext!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = renderContext!.fontSize / 28
        ..strokeCap = StrokeCap.square;

      start += child.topCenterOffset - child.topCenterOffset;
      double end = start + child.size.width;

      double y = baseline - child.baselineOffset + child.size.height;
      if (!child.hasDescender && !child.isMultiline) y -= fontSize * 0.15;

      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType: $decoration, '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

    str += '\n$indent  ${child.toStringWithIndent('$indent  ')}';
    return str;
  }
}
