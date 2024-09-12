import 'dart:math';

import 'package:flutter/widgets.dart';

import '../nodes/__export.dart';
import 'painter.dart';


class BracketPainter extends LPainter {

  final double height;
  final BracketType bracketType;
  final BracketOrientation bracketOrientation;


  BracketPainter(
    super.renderContext,
    this.height,
    this.bracketType,
    this.bracketOrientation,
  );


  @override
  Size get size {
    switch (bracketType) {
      case BracketType.none:          return const Size(0, 0);
      case BracketType.curly:         return Size(min(fontSize*0.5, height/4), height);
      case BracketType.square:        return Size(min(fontSize*0.26, height*0.18), height);
      case BracketType.doubleSquare:  return Size(min(fontSize*0.26, height*0.18), height);
      case BracketType.round:         return Size(min(fontSize*0.5, height*0.2), height);
    }
  }

  void paint(Canvas canvas, double start, double baseline) {

    Path path;
    switch (bracketType) {
      case BracketType.none: return;
      case BracketType.curly: path = getCurlyBracketPath(size.width, height, fontSize); break;
      case BracketType.square: path = getSquareBracketPath(size.width, height, fontSize); break;
      case BracketType.doubleSquare: path = getSquareBracketPath(size.width, height, fontSize, isDoubleBracket: true); break;
      case BracketType.round: path = getRoundBracketPath(size.width, height, fontSize); break;
    }

    if (bracketOrientation == BracketOrientation.right) {
      path = LPainter.mirrorXPath(path, size.width);
    }

    canvas.drawPath(
      LPainter.translatePath(path, start, baseline - renderContext.baselineToCenter*0.98),
      Paint()..color = color..style = PaintingStyle.fill,
    );
  }


  // curly brackets
  static Path getCurlyBracketPath(double w, double h, double fontSize) {
    double reducedHeightHalf = (h - fontSize*0.1)/2;
    double strokeWidth = max(w*0.16, fontSize * 0.07);
    double x_center = w*0.6;

    Path path = Path();

    path.moveTo(0, strokeWidth/4);
    path.cubicTo(
      x_center - strokeWidth, strokeWidth/4,
      x_center - strokeWidth, reducedHeightHalf*0.25,
      x_center - strokeWidth, reducedHeightHalf*0.25
    );
    path.lineTo(x_center - strokeWidth, reducedHeightHalf*0.75);
    path.cubicTo(
      x_center - strokeWidth, reducedHeightHalf,
      w, reducedHeightHalf,
      w, reducedHeightHalf,
    );

    path.lineTo(w, reducedHeightHalf - strokeWidth/2);
    path.cubicTo(
      x_center, reducedHeightHalf - strokeWidth/2,
      x_center, reducedHeightHalf*0.75,
      x_center, reducedHeightHalf*0.75,
    );
    path.lineTo(x_center, reducedHeightHalf*0.25);

    path.cubicTo(
      x_center, 0,
      strokeWidth, 0,
      strokeWidth, 0,
    );

    path.cubicTo(
      x_center, 0,
      x_center, -reducedHeightHalf*0.25,
      x_center, -reducedHeightHalf*0.25,
    );
    path.lineTo(x_center, -reducedHeightHalf*0.75);
    path.cubicTo(
      x_center, -reducedHeightHalf + strokeWidth/2,
      w, -reducedHeightHalf + strokeWidth/2,
      w, -reducedHeightHalf + strokeWidth/2,
    );

    path.lineTo(w, -reducedHeightHalf);
    path.cubicTo(
      x_center - strokeWidth, -reducedHeightHalf,
      x_center - strokeWidth, -reducedHeightHalf*0.75,
      x_center - strokeWidth, -reducedHeightHalf*0.75,
    );
    path.lineTo(x_center - strokeWidth, -reducedHeightHalf*0.25);
    path.cubicTo(
      x_center - strokeWidth, -strokeWidth/4,
      0, -strokeWidth/4,
      0, -strokeWidth/4,
    );

    path.close();

    return path;
  }

  // square brackets
  static Path getSquareBracketPath(double w, double h, double fontSize, {bool isDoubleBracket = false}) {
    double reducedHeightHalf = (h - fontSize*0.1)/2;
    double strokeWidth = max(w*0.16, fontSize * 0.07);
    if (isDoubleBracket) strokeWidth /= 2;

    Path path = Path()
      ..moveTo(0, reducedHeightHalf)
      ..lineTo(0, -reducedHeightHalf)
      ..lineTo(w, -reducedHeightHalf)
      ..lineTo(w, -reducedHeightHalf + strokeWidth)
      ..lineTo(strokeWidth, -reducedHeightHalf + strokeWidth)
      ..lineTo(strokeWidth, reducedHeightHalf - strokeWidth)
      ..lineTo(w, reducedHeightHalf - strokeWidth)
      ..lineTo(w, reducedHeightHalf)
      ..lineTo(0, reducedHeightHalf);

    if (isDoubleBracket) {
      double o = 2*strokeWidth;
      path
        ..moveTo(o, reducedHeightHalf)
        ..lineTo(o, -reducedHeightHalf)
        ..lineTo(w, -reducedHeightHalf)
        ..lineTo(w, -reducedHeightHalf + strokeWidth)
        ..lineTo(o+strokeWidth, -reducedHeightHalf + strokeWidth)
        ..lineTo(o+strokeWidth, reducedHeightHalf - strokeWidth)
        ..lineTo(w, reducedHeightHalf - strokeWidth)
        ..lineTo(w, reducedHeightHalf)
        ..lineTo(o, reducedHeightHalf);
    }

    path.close();

    return path;
  }

  // round brackets
  static Path getRoundBracketPath(double w, double h, double fontSize) {
    double reducedHeightHalf = (h - fontSize*0.1)/2;
    double strokeWidth_center = max(w*0.2, fontSize * 0.075);
    double strokeWidth_tip = strokeWidth_center*0.6;
    double curvatureHeight = min(w * 4, reducedHeightHalf*1.1);

    Path path = Path();

    path.moveTo(w - strokeWidth_tip, reducedHeightHalf);

    path.cubicTo(
      0, reducedHeightHalf - curvatureHeight/3,
      0, reducedHeightHalf - curvatureHeight/3*2,
      0, reducedHeightHalf - curvatureHeight
    );

    path.lineTo(
      0, -reducedHeightHalf + curvatureHeight
    );

    path.cubicTo(
      0, -reducedHeightHalf + curvatureHeight/3*2,
      0, -reducedHeightHalf + curvatureHeight/3,
      w - strokeWidth_tip, -reducedHeightHalf
    );


    path.lineTo(w, -reducedHeightHalf + strokeWidth_tip*0.4);

    path.cubicTo(
      strokeWidth_center, -reducedHeightHalf + curvatureHeight/3,
      strokeWidth_center, -reducedHeightHalf + curvatureHeight/3*2,
      strokeWidth_center, -reducedHeightHalf + curvatureHeight
    );

    path.lineTo(
      strokeWidth_center, reducedHeightHalf - curvatureHeight
    );

    path.cubicTo(
      strokeWidth_center, reducedHeightHalf - curvatureHeight/3*2,
      strokeWidth_center, reducedHeightHalf - curvatureHeight/3,
      w, reducedHeightHalf - strokeWidth_tip*0.4
    );

    path.close();

    return path;
  }

}