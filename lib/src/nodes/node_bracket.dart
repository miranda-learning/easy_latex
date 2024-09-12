import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';

enum BracketType {
  none,
  curly,
  square,
  doubleSquare,
  round;

  bool get isNone => this == none;
  bool get isCurly => this == curly;
  bool get isSquare => this == square;
  bool get isDoubleSquare => this == doubleSquare;
  bool get isRound => this == round;
}

enum BracketOrientation {
  left,
  right;

  bool get isLeft => this == left;
  bool get isRight => this == right;
}

class BracketNode extends LatexRenderNode {
  final BracketType bracketType;
  final BracketOrientation bracketOrientation;

  late BracketPainter _bracketPainter;
  double _startOffset = 0;

  BracketNode(this.bracketType, this.bracketOrientation);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _bracketPainter = BracketPainter(
        renderContext, renderContext.fontSize, bracketType, bracketOrientation);

    double innerSpacing = renderContext.fontSize * 0.1;
    double outerSpacing = renderContext.fontSize * 0.1;

    if (bracketOrientation == BracketOrientation.right) {
      _startOffset = innerSpacing;
    } else {
      _startOffset = outerSpacing;
    }

    // if height == fontSize means no multiline bracket, in this case we want to align the bracket with the text
    // (same height and same baseline as text)
    if (_bracketPainter.size.height == renderContext.fontSize) {
      size = Size(
        _bracketPainter.size.width + innerSpacing + outerSpacing,
        LatexTextPainter.fontSizeToHeight(renderContext.fontSize),
      );
      baselineOffset =
          LatexTextPainter.fontSizeToBaseline(renderContext.fontSize);
    } else {
      size = Size(_bracketPainter.size.width + innerSpacing + outerSpacing,
          _bracketPainter.size.height);
      baselineOffset = renderContext.baselineToCenter + size.height / 2;
    }
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _bracketPainter.paint(canvas, start + _startOffset, baseline);
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    return '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}, '
        'bracketType: $bracketType, bracketOrientation: $bracketOrientation';
  }
}
