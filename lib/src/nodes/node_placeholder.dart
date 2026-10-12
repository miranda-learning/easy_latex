import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import '../util/__export.dart';
import 'node.dart';

enum PlaceholderType {
  regular,
  red,
  dashed,
  invisible; // used to add cursor positions

  bool get isRegular => this == regular;
  bool get isRed => this == red;
  bool get isDashed => this == dashed;
  bool get isInvisible => this == invisible;
}

enum PlaceholderWidth {
  normal,
  wide,
  extraWide;

  double get factor {
    switch (this) {
      case normal:
        return 1;
      case wide:
        return 2;
      case extraWide:
        return 3;
    }
  }
}

enum PlaceholderHeight {
  normal,
  tall;

  double get factor {
    switch (this) {
      case normal:
        return 1;
      case tall:
        return 1.35;
    }
  }
}

class PlaceholderNode extends LatexRenderNode {
  final PlaceholderType type;
  final PlaceholderWidth width;
  final PlaceholderHeight height;
  final bool showQuestionMark;
  final bool showBorder;

  PlaceholderNode({
    this.type = PlaceholderType.regular,
    this.width = PlaceholderWidth.normal,
    this.height = PlaceholderHeight.normal,
    this.showBorder = false,
    this.showQuestionMark = false,
  });

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    double baseWidth = renderContext.fontSize * 0.68;
    double baseHeight =
        LatexTextPainter.fontSizeToHeight(renderContext.fontSize);
    double extraHeight = baseHeight * height.factor - baseHeight;

    size = Size(
      type.isInvisible ? 0 : baseWidth * width.factor,
      baseHeight * height.factor,
    );

    baselineOffset =
        LatexTextPainter.fontSizeToBaseline(renderContext.fontSize) +
            extraHeight / 2;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    if (type.isInvisible) return;

    double top = baseline - baselineOffset;
    double hPadding = size.width * 0.1;
    double vPadding = size.width * 0.25;
    Rect rect = Rect.fromLTRB(start + hPadding, top + vPadding,
        start + size.width - hPadding, top + size.height - vPadding);

    // dashed placeholder
    if (type.isDashed) {
      double strokeWidth;
      double fontSizeRatio =
          renderContext!.fontSize / renderContext!.mainFontSize;
      if (fontSizeRatio > 0.8) {
        strokeWidth = renderContext!.mainFontSize * 0.08;
      } else if (fontSizeRatio > 0.6) {
        strokeWidth = renderContext!.mainFontSize * 0.072;
      } else {
        strokeWidth = renderContext!.mainFontSize * 0.05;
      }

      double hPadding = size.width * 0.1 + strokeWidth / 2;
      double vPadding = size.width * 0.35 + strokeWidth / 2;
      rect = Rect.fromLTRB(start + hPadding, top + vPadding,
          start + size.width - hPadding, top + size.height - vPadding);

      double lX = rect.left;
      double rX = rect.right;
      double tY = rect.top;
      double bY = rect.bottom;

      Paint linePaint = Paint()
        ..color = renderContext!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawDashedLine(
          Offset(lX - strokeWidth / 2, tY),
          Offset(rX - strokeWidth / 2, tY),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(rX, tY - strokeWidth / 2),
          Offset(rX, bY - strokeWidth / 2),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(rX + strokeWidth / 2, bY),
          Offset(lX + strokeWidth / 2, bY),
          linePaint,
          [strokeWidth, strokeWidth]);
      canvas.drawDashedLine(
          Offset(lX, bY + strokeWidth / 2),
          Offset(lX, tY + strokeWidth / 2),
          linePaint,
          [strokeWidth, strokeWidth]);
    }

    // regular
    if (type.isRegular) {
      canvas.drawRect(
          rect,
          Paint()
            ..color = renderContext!.color.withAlpha(16)
            ..style = PaintingStyle.fill);
    }

    // red
    if (type.isRed) {
      canvas.drawRect(
          rect,
          Paint()
            ..color = const Color(0xFFFFCDD2)
            ..style = PaintingStyle.fill);
    }

    // border
    if (showBorder) {
      Color borderColor = type.isRed ? Color(0xFFF44336) : renderContext!.color;
      double strokeWidth = renderContext!.mainFontSize * 0.04;
      canvas.drawRect(
          rect,
          Paint()
            ..color = borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth);
    }

    // question mark
    if (showQuestionMark) {
      LatexTextPainter? textPainter = LatexTextPainter('?',
          fontSize: fontSize * 0.8,
          color: renderContext!.color,
          isBold: true,
          font: renderContext!.font);
      textPainter.layout();
      Offset offset = Offset(
        rect.left + (rect.width - textPainter.width) * 0.5,
        baseline - textPainter.baseline * 1.05,
      );
      textPainter.paint(canvas, offset);
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
