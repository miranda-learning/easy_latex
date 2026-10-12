import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';

class MathStyleDeclarationNode extends LatexRenderNode {
  final LatexMathStyle mathStyle;

  MathStyleDeclarationNode(this.mathStyle);

  @override
  void paint(Canvas canvas, double start, double baseline) {}

  @override
  String toStringWithIndent(String indent) => '$indent$runtimeType: $mathStyle';
}

class MathStyleNode extends LatexRenderNode {
  final LatexRenderNode child;
  final LatexMathStyle mathStyle;

  MathStyleNode(this.child, this.mathStyle);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    child.performLayout(renderContext.copyWith(mathStyle: mathStyle),
        isDense: isDense);
    size = child.size;
    baselineOffset = child.baselineOffset;
    spacingRequired = child.spacingRequired;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    child.paint(canvas, start, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    child.computeCursorPositions(start, baseline, offsets, fontSizes);
  }

  @override
  double get baselineToTop => child.baselineToTop;

  @override
  double get topCenterOffset => child.topCenterOffset;

  @override
  double get topRightOffset => child.topRightOffset;

  @override
  bool get hasDescender => child.hasDescender;

  @override
  bool get isMultiline => child.isMultiline;

  @override
  String toStringWithIndent(String indent) =>
      '$indent$runtimeType ($mathStyle):\n${child.toStringWithIndent('$indent  ')}';
}
