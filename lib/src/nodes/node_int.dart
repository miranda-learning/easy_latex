import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';
import 'operator_limits_placement.dart';

enum IntegralType {
  regular,
  double,
  triple,
  quad,
  contour,
  contourDouble,
  contourTriple,
  contourQuad;

  bool get isDouble => this == double || this == contourDouble;
  bool get isTriple => this == triple || this == contourTriple;
  bool get isQuad => this == quad || this == contourQuad;
  bool get isContour =>
      this == contour ||
      this == contourDouble ||
      this == contourTriple ||
      this == contourQuad;
}

class IntNode extends LatexRenderNode {
  final IntegralType type;
  final bool isInline;
  OperatorLimitsPlacement limitsPlacement;
  late IntegralPainter _integralPainter;

  IntNode({
    this.type = IntegralType.regular,
    this.isInline = false,
    this.limitsPlacement = OperatorLimitsPlacement.automatic,
  });

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    bool useInlineStyle =
        isInline || renderContext.mathStyle == LatexMathStyle.text;
    _integralPainter =
        IntegralPainter(renderContext, type: type, isInline: useInlineStyle);

    size = _integralPainter.size;
    baselineOffset = _integralPainter.baselineOffset;
    spacingRequired = true;
  }

  bool get usesInlineStyle =>
      isInline || renderContext?.mathStyle == LatexMathStyle.text;

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    offsets.add(Offset(start, baseline));
    fontSizes.add(fontSize);
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _integralPainter.paint(canvas, start, baseline);
  }

  @override
  double get topRightOffset => fontSize * 0.02;

  @override
  bool get isMultiline => !usesInlineStyle;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) => '$indent$runtimeType: '
      'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
}
