import 'dart:math';

import 'package:flutter/widgets.dart';

import 'painter.dart';


class SqrtPainter extends LPainter {

  final Size childSize;
  final bool isMultiline;

  // getters
  double get rootWidth => isMultiline ? fontSize * 0.8 : min(childSize.height * 0.8, fontSize * 0.6); //0.8


  SqrtPainter(
    super.renderContext,
    this.childSize,
    this.isMultiline,
  );


  @override
  Size get size => Size(
    rootWidth + childSize.width,
    isMultiline ? childSize.height : childSize.height*1.10
  );

  void paint(Canvas canvas, double start, double top, double baseline) {
    Paint paint = Paint()..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    bool isSansSerif = renderContext.font?.isSansSerif ?? false;

    canvas.drawPath(
      LPainter.translatePath(
        isSansSerif ? _getSqrtPathSansSerif() : _getSqrtPath(), start,
        isMultiline ? top + size.height : baseline + fontSize*0.05
      ),
      paint
    );
  }


  Path _getSqrtPath() {
    double h = size.height;
    double childWidth = childSize.width + rootWidth * 0.04;
    double modifiedRootWidth = rootWidth * 0.9;

    double longArmWidth = modifiedRootWidth * (isMultiline ? 0.55 : 0.6);
    double lineWidth = fontSize*0.05;

    double hookWidth = modifiedRootWidth * 0.2;
    double hookLineWidth = lineWidth;

    double shortArmTop = isMultiline ? h*0.55 : max(h*0.5, fontSize*0.4);
    double shortArmWidth = modifiedRootWidth - longArmWidth - hookWidth;
    double shortArmLineWidth = lineWidth * (isMultiline ? 10 : 4);


    Path path = Path();

    path.moveTo(modifiedRootWidth - longArmWidth, 0);

    // top
    path.lineTo(modifiedRootWidth, -h);
    path.lineTo(rootWidth + childWidth, -h);
    path.lineTo(rootWidth + childWidth, -h + lineWidth);

    double ds = longArmWidth/h * lineWidth;
    path.lineTo(modifiedRootWidth + lineWidth - ds, -h + lineWidth);

    // bottom
    path.lineTo(modifiedRootWidth - longArmWidth + lineWidth, 0);
    path.lineTo(modifiedRootWidth - longArmWidth, 0);

    // hook
    double x = modifiedRootWidth - longArmWidth - hookWidth;
    double y = shortArmTop - shortArmLineWidth;
    double hookRatio = (shortArmLineWidth - hookLineWidth) / (x + y);

    double dx = x * hookRatio;
    double dy = y * hookRatio;
    path.lineTo(hookWidth - dx, -shortArmTop + shortArmLineWidth - dy);

    path.lineTo(0, -shortArmTop + shortArmLineWidth + hookWidth - dx - dy);
    path.lineTo(0, -shortArmTop + hookWidth);
    path.lineTo(hookWidth, -shortArmTop);

    double dh = shortArmTop - (shortArmTop - shortArmLineWidth) / (shortArmWidth) * (shortArmWidth + lineWidth);
    path.lineTo(modifiedRootWidth - longArmWidth + lineWidth, -dh);

    path.close();

    return path;
  }

  Path _getSqrtPathSansSerif() {
    double h = size.height;
    double childWidth = childSize.width + rootWidth * 0.04;
    double modifiedRootWidth = rootWidth * 0.9;

    double longArmWidth = modifiedRootWidth * (isMultiline ? 0.55 : 0.6);
    double lineWidth = fontSize*0.06;

    double hookWidth = modifiedRootWidth * 0.20;
    double hookLineWidth = lineWidth;

    double shortArmTop = isMultiline ? h*0.55 : max(h*0.5, fontSize*0.4);
    double shortArmWidth = modifiedRootWidth - longArmWidth - hookWidth;
    double shortArmLineWidth = lineWidth * (isMultiline ? 10 : 3.5);


    Path path = Path();

    path.moveTo(modifiedRootWidth - longArmWidth, 0);

    // top
    path.lineTo(modifiedRootWidth, -h);
    path.lineTo(rootWidth + childWidth, -h);
    path.lineTo(rootWidth + childWidth, -h + lineWidth);

    double ds = longArmWidth/h * lineWidth;
    path.lineTo(modifiedRootWidth + lineWidth - ds, -h + lineWidth);

    // bottom
    path.lineTo(modifiedRootWidth - longArmWidth + lineWidth, 0);
    path.lineTo(modifiedRootWidth - longArmWidth, 0);

    // hook
    double x = modifiedRootWidth - longArmWidth - hookWidth;
    double y = shortArmTop - shortArmLineWidth;
    double hookRatio = (shortArmLineWidth - hookLineWidth) / (x + y);

    double dx = x * hookRatio;
    double dy = y * hookRatio;
    path.lineTo(hookWidth - dx, -shortArmTop + shortArmLineWidth - dy);

    path.lineTo(0, -shortArmTop + shortArmLineWidth - dy);
    path.lineTo(0, -shortArmTop);
    path.lineTo(hookWidth, -shortArmTop);

    double dh = shortArmTop - (shortArmTop - shortArmLineWidth) / (shortArmWidth) * (shortArmWidth + lineWidth);
    path.lineTo(modifiedRootWidth - longArmWidth + lineWidth, -dh);

    path.close();

    return path;
  }

}