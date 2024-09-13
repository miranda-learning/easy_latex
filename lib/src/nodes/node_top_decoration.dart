import 'dart:math';

import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

enum TopDecoration {
  bar,
  dot,
  ddot,
  dddot,
  hat,
  overbrace,
  overline,
  overleftarrow,
  overleftrightarrow,
  overrightarrow,
  tilde,
  vec,
  widehat,
  widetilde;

  String? get decorationChar {
    switch (this) {
      case bar:
        return '\u02c9';
      case dot:
        return '\u02d9';
      case ddot:
        return '\u02d9\u02d9';
      case dddot:
        return '\u02d9\u02d9\u02d9';
      case hat:
        return '\u005e';
      case overbrace:
        return null;
      case overline:
        return null;
      case overleftarrow:
        return null;
      case overleftrightarrow:
        return null;
      case overrightarrow:
        return null;
      case tilde:
        return '\u02dc';
      case vec:
        return '\u20d7';
      case widehat:
        return null;
      case widetilde:
        return null;
    }
  }
}

class TopDecorationNode extends LatexRenderNode {
  final LatexRenderNode child;
  final TopDecoration decoration;

  late LatexTextPainter _textPainter;

  TopDecorationNode(this.child, this.decoration);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    child.performLayout(renderContext);

    if (decoration.decorationChar != null) {
      _textPainter = LatexTextPainter(
        decoration.decorationChar!,
        fontSize: renderContext.fontSize,
        color: renderContext.color,
      );
      _textPainter.layout();
    }

    spacingRequired = child.spacingRequired;
    baselineOffset = max(child.baselineOffset, baselineToTop);

    double width = child.size.width;
    if (decoration == TopDecoration.dddot) width = max(width, fontSize * 0.8);
    double height = child.size.height - child.baselineOffset + baselineOffset;
    size = Size(width, height);
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    double offset = 0;
    if (child.size.width < size.width) {
      offset += (size.width - child.size.width) / 2;
    }
    child.paint(canvas, start + offset, baseline);

    if (decoration.decorationChar != null) {
      _drawTextDecoration(canvas, start, baseline);
    } else {
      _drawPathDecoration(canvas, start, baseline);
    }
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
  double get baselineToTop =>
      child.baselineToTop +
      (decoration == TopDecoration.overbrace
          ? fontSize * 0.4
          : fontSize * 0.24);

  void _drawTextDecoration(Canvas canvas, double start, double baseline) {
    double x = start +
        size.width / 2 -
        _textPainter.size.width / 2 +
        child.topCenterOffset;
    double y = baseline - child.baselineToTop - fontSize * 0.4;

    if (decoration == TopDecoration.bar) {
      y -= _textPainter.size.height * 0.03;
    } else if (decoration == TopDecoration.vec) {
      x += _textPainter.size.height / 4.8;
    }

    _textPainter.paint(canvas, Offset(x, y));
  }

  void _drawPathDecoration(Canvas canvas, double start, double baseline) {
    if (decoration == TopDecoration.overline ||
        decoration == TopDecoration.overleftarrow ||
        decoration == TopDecoration.overleftrightarrow ||
        decoration == TopDecoration.overrightarrow) {
      // overline, overleftarrow, overleftrightarrow, overrightarrow
      double x = start + child.topCenterOffset + fontSize * 0.08;
      double y = baseline - child.baselineToTop - fontSize * 0.12;
      double w = child.size.width - 2 * fontSize * 0.08;

      Paint paint = Paint()
        ..color = renderContext!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = renderContext!.fontSize / 28
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(Offset(x, y), Offset(x + w, y), paint);

      double arrowOffset = fontSize * 0.1;
      if (decoration == TopDecoration.overleftarrow ||
          decoration == TopDecoration.overleftrightarrow) {
        double t = x - fontSize * 0.04;
        canvas.drawLine(
            Offset(t + arrowOffset, y - arrowOffset), Offset(t, y), paint);
        canvas.drawLine(
            Offset(t + arrowOffset, y + arrowOffset), Offset(t, y), paint);
      }

      if (decoration == TopDecoration.overrightarrow ||
          decoration == TopDecoration.overleftrightarrow) {
        double t = x + w + fontSize * 0.04;
        canvas.drawLine(
            Offset(t - arrowOffset, y - arrowOffset), Offset(t, y), paint);
        canvas.drawLine(
            Offset(t - arrowOffset, y + arrowOffset), Offset(t, y), paint);
      }
    } else if (decoration == TopDecoration.overbrace) {
      // overbrace
      Path path = BracketPainter.getCurlyBracketPath(
          fontSize * 0.4, child.size.width, fontSize);
      path = LPainter.rotatePath(path, 90);
      path = LPainter.translatePath(path, start + child.size.width / 2, 0);
      canvas.drawPath(path, Paint()..color = renderContext!.color);
    } else if (decoration == TopDecoration.widehat) {
      // widehat
      double x = start + fontSize * 0.04;
      double y = baseline - child.baselineToTop - fontSize * 0.12;
      double w = child.size.width - 2 * fontSize * 0.04;
      Path path = Path()
        ..moveTo(0, fontSize * 0.04)
        ..lineTo(0, 0)
        ..lineTo(w / 2, -fontSize * 0.12)
        ..lineTo(w, 0)
        ..lineTo(w, fontSize * 0.04)
        ..lineTo(w / 2, -fontSize * 0.06)
        ..close();
      path = LPainter.translatePath(path, x, y);
      canvas.drawPath(path, Paint()..color = renderContext!.color);
    } else if (decoration == TopDecoration.widetilde) {
      // widetilde
      double x = start + fontSize * 0.04;
      double y = baseline - child.baselineToTop - fontSize * 0.17;
      double w = child.size.width - 2 * fontSize * 0.04;
      double h = fontSize * 0.28;
      Path path = Path()
        ..moveTo(0, 0.10 * h)
        ..lineTo(0, -0.0 * h)
        ..cubicTo(0.5 * w, -h, 0.5 * w, h, w, -0.15 * h)
        ..lineTo(w, -0.0 * h)
        ..cubicTo(0.5 * w, 1.3 * h, 0.5 * w, -0.7 * h, 0, 0.1 * h);
      path = LPainter.translatePath(path, x, y);
      canvas.drawPath(path, Paint()..color = renderContext!.color);
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
