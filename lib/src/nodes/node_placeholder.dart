import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import '../util/__export.dart';
import 'node.dart';

enum PlaceholderType {
  regular,
  lightRed,
  red,
  dashed,
}

class PlaceholderNode extends LatexRenderNode {
  final PlaceholderType type;

  PlaceholderNode({
    this.type = PlaceholderType.regular,
  });

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    size = Size(
      renderContext.fontSize * 0.68,
      LatexTextPainter.fontSizeToHeight(renderContext.fontSize),
    );
    baselineOffset =
        LatexTextPainter.fontSizeToBaseline(renderContext.fontSize);
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    double top = baseline - baselineOffset;

    // filled placeholder
    if (type != PlaceholderType.dashed) {
      double horizontalPadding = size.width * 0.1;
      double verticalPadding = size.width * 0.25;

      Rect rect = Rect.fromLTRB(
          start + horizontalPadding,
          top + verticalPadding,
          start + size.width - horizontalPadding,
          top + size.height - verticalPadding);

      Paint paint = Paint()
        ..color =
            type == PlaceholderType.lightRed || type == PlaceholderType.red
                ? const Color(0xFFFFCDD2)
                : renderContext!.color.withAlpha(16)
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);
      if (type == PlaceholderType.red) {
        canvas.drawRect(
            rect,
            Paint()
              ..color = const Color(0xFFF44336)
              ..style = PaintingStyle.stroke);
      }

      // dashed placeholder
    } else {
      double fontSizeRatio =
          renderContext!.fontSize / renderContext!.mainFontSize;
      double strokeWidth;
      if (fontSizeRatio > 0.8) {
        strokeWidth = renderContext!.mainFontSize * 0.08;
      } else if (fontSizeRatio > 0.6) {
        strokeWidth = renderContext!.mainFontSize * 0.072;
      } else {
        strokeWidth = renderContext!.mainFontSize * 0.05;
      }

      double horizontalPadding = size.width * 0.1 + strokeWidth / 2;
      double verticalPadding = size.width * 0.35 + strokeWidth / 2;

      double l_x = start + horizontalPadding;
      double r_x = start + size.width - horizontalPadding;
      double t_y = top + verticalPadding;
      double b_y = top + size.height - verticalPadding;

      Paint linePaint = Paint()
        ..color = renderContext!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawDashedLine(
          Offset(l_x - strokeWidth / 2, t_y),
          Offset(r_x - strokeWidth / 2, t_y),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(r_x, t_y - strokeWidth / 2),
          Offset(r_x, b_y - strokeWidth / 2),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(r_x + strokeWidth / 2, b_y),
          Offset(l_x + strokeWidth / 2, b_y),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(l_x, b_y + strokeWidth / 2),
          Offset(l_x, t_y + strokeWidth / 2),
          linePaint,
          [strokeWidth, strokeWidth]);
    }
  }

  @override
  double get baselineToTop => baselineOffset * 0.85;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str =
        '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    return str;
  }
}
