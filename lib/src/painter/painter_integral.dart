import 'package:flutter/widgets.dart';

import '../nodes/__export.dart';
import 'painter.dart';

class IntegralPainter extends LPainter {
  final IntegralType type;
  final bool isInline;

  // getters
  double get singleWidth => (isInline ? fontSize * 0.68 : fontSize * 0.9);
  int get numIntegrals => type.isQuad
      ? 4
      : type.isTriple
          ? 3
          : type.isDouble
              ? 2
              : 1;

  IntegralPainter(
    super.renderContext, {
    this.type = IntegralType.regular,
    this.isInline = false,
  });

  @override
  Size get size {
    return Size(singleWidth + (numIntegrals - 1) * fontSize / 2,
        isInline ? fontSize * 1.36 : fontSize * 2.5);
  }

  double get baselineOffset {
    return isInline
        ? size.height / 2 + renderContext.baselineToCenter * 1.2
        : size.height / 2 + renderContext.baselineToCenter * 0.9;
  }

  void paint(Canvas canvas, double start, double baseline) {
    Paint paint = Paint()
      ..color = renderContext.color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    double w = singleWidth * 0.58823529;
    double h = size.height;

    for (var i = 0; i < numIntegrals; i++) {
      canvas.drawPath(
          LPainter.translatePath(
              isInline
                  ? getInlineIntegralPath(w, h / 2)
                  : getIntegralPath(w, h / 2),
              start + i * fontSize / 2 + w * 0.7,
              baseline - baselineOffset + h / 2),
          paint);

      canvas.drawPath(
          LPainter.translatePath(
              isInline
                  ? LPainter.mirrorXYPath(
                      getInlineIntegralPath(w, h / 2), w * 0.30)
                  : LPainter.mirrorXYPath(getIntegralPath(w, h / 2), w * 0.27),
              start + i * fontSize / 2 + w * 0.7,
              baseline - baselineOffset + h / 2),
          paint);
    }

    if (type.isContour) {
      double rW = w * 0.6 + (numIntegrals - 1) * fontSize * 0.25;
      double rH = w * 0.6;
      canvas.drawOval(
          Rect.fromLTWH(start + size.width / 2 - rW,
              baseline - baselineOffset + h / 2 - rH, 2 * rW, 2 * rH),
          Paint()
            ..color = renderContext.color
            ..strokeWidth = fontSize * 0.05
            ..style = PaintingStyle.stroke);
    }
  }

  static Path getIntegralPath(double w, double h) {
    Path path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      w * 0.15,
      -h * 0.4,
      w * 0.4,
      -h * 0.8,
    );

    path.cubicTo(w * 0.525, -h, w * 0.99, -h * 0.96, w, -h * 0.8);
    path.lineTo(w * 0.86, -h * 0.8);

    path.cubicTo(
        w * 0.86, -h * 0.93, w * 0.625, -h * 0.94, w * 0.575, -h * 0.8);

    path.quadraticBezierTo(
      w * 0.42,
      -h / 5 * 2,
      w * 0.27,
      0,
    );

    path.close();

    path.addOval(
        Rect.fromCircle(center: Offset(w * 0.865, -h * 0.8), radius: w * 0.13));

    return path;
  }

  static Path getInlineIntegralPath(double w, double h) {
    Path path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      w * 0.14,
      -h * 0.4,
      w * 0.38,
      -h * 0.8,
    );

    path.cubicTo(w * 0.525, -h, w * 0.99, -h * 0.98, w, -h * 0.76);
    path.lineTo(w * 0.86, -h * 0.76);

    path.cubicTo(
        w * 0.86, -h * 0.88, w * 0.625, -h * 0.92, w * 0.575, -h * 0.76);

    path.quadraticBezierTo(
      w * 0.44,
      -h / 5 * 2,
      w * 0.30,
      0,
    );

    path.close();

    path.addOval(
        Rect.fromCircle(center: Offset(w * 0.84, -h * 0.76), radius: w * 0.16));

    return path;
  }
}
