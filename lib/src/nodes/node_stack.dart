import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';

enum StackPosition {
  over,
  under,
}

class StackNode extends LatexRenderNode {
  final LatexRenderNode annotation;
  final LatexRenderNode child;
  final StackPosition position;
  final bool isRelation;

  late double _annotationBaselineOffset;
  late double _annotationStartOffset;
  late double _childStartOffset;

  StackNode({
    required this.annotation,
    required this.child,
    required this.position,
    this.isRelation = false,
  });

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    child.performLayout(renderContext, isDense: isDense);
    annotation.performLayout(
      renderContext.copyWith(
          fontSizeScaling: 0.7, mathStyle: LatexMathStyle.text),
      isDense: true,
    );

    double width = max(child.size.width, annotation.size.width);
    _annotationStartOffset = width / 2 - annotation.size.width / 2;
    _childStartOffset = width / 2 - child.size.width / 2;

    if (position == StackPosition.over) {
      _annotationBaselineOffset = -child.baselineToTop +
          renderContext.fontSize * 0.02 -
          (annotation.size.height - annotation.baselineOffset);
      double annotationTop =
          _annotationBaselineOffset - annotation.baselineOffset;
      double top = min(-child.baselineOffset, annotationTop);
      baselineOffset = -top;
      size = Size(width, child.size.height - child.baselineOffset - top);
    } else {
      double gap = -renderContext.fontSize * 0.30;
      _annotationBaselineOffset = child.size.height -
          child.baselineOffset +
          gap +
          annotation.baselineOffset;
      baselineOffset = child.baselineOffset;
      size = Size(width, child.size.height + gap + annotation.size.height);
    }

    spacingRequired = isRelation || child.spacingRequired;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    child.paint(canvas, start + _childStartOffset, baseline);
    annotation.paint(canvas, start + _annotationStartOffset,
        baseline + _annotationBaselineOffset);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    child.computeCursorPositions(
        start + _childStartOffset, baseline, offsets, fontSizes);
    annotation.computeCursorPositions(
      start + _annotationStartOffset,
      baseline + _annotationBaselineOffset,
      offsets,
      fontSizes,
    );
  }

  @override
  double get topCenterOffset => child.topCenterOffset;

  @override
  double get topRightOffset => child.topRightOffset;

  @override
  bool get hasDescender => child.hasDescender;

  @override
  bool get isMultiline => child.isMultiline || annotation.isMultiline;

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType ($position): '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    str +=
        '\n$indent  annotation:\n${annotation.toStringWithIndent('$indent    ')}';
    str += '\n$indent  child:\n${child.toStringWithIndent('$indent    ')}';
    return str;
  }
}
