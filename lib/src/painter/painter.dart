import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../render/__export.dart';

abstract class LPainter {
  final RenderContext renderContext;

  // getters
  double get fontSize => renderContext.fontSize;
  Color get color => renderContext.color;
  Size get size;

  LPainter(this.renderContext);

  static Path translatePath(Path path, double x, double y) {
    List<double> translationMatrix = [
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      x,
      y,
      0,
      1
    ];
    return path.transform(Float64List.fromList(translationMatrix));
  }

  static Path mirrorXPath(Path path, double width) {
    // rotate along y-axis by pi
    List<double> rotationMatrix = [
      -1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1
    ];
    return translatePath(
        path.transform(Float64List.fromList(rotationMatrix)), width, 0);
  }

  static Path mirrorXYPath(Path path, double width) {
    // rotate along y-axis by pi
    List<double> rotationMatrix = [
      -1,
      0,
      0,
      0,
      0,
      -1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1
    ];
    return translatePath(
        path.transform(Float64List.fromList(rotationMatrix)), width, 0);
  }

  static Path rotatePath(Path path, double deg) {
    double radians = (360 - deg) * pi / 180;
    List<double> rotationMatrix = [
      cos(radians),
      -sin(radians),
      0,
      0,
      sin(radians),
      cos(radians),
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1
    ];
    return path.transform(Float64List.fromList(rotationMatrix));
  }
}
