import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';
import 'node_group.dart';
import 'node_placeholder.dart';

class FracNode extends LatexRenderNode {
  final LatexRenderNode numerator;
  final LatexRenderNode denominator;

  late Paint _linePaint;
  late double _lineWidth;
  late double _lineOffset;

  bool _isDense = false;

  FracNode(this.numerator, this.denominator) {
    spacingRequired = true;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _isDense = isDense;
    // layout children

    double horizontalMultilineOffset = 0;

    if (!numerator.isMultiline) {
      numerator.performLayout(renderContext);
    } else {
      // TODO
      numerator.performLayout(renderContext.copyWith(fontSizeScaling: 0.6));
      horizontalMultilineOffset = renderContext.fontSize * 0.3;
    }

    if (!denominator.isMultiline) {
      denominator.performLayout(renderContext);
    } else {
      // TODO
      denominator.performLayout(renderContext.copyWith(fontSizeScaling: 0.6));
      horizontalMultilineOffset = renderContext.fontSize * 0.3;
    }

    _lineWidth = renderContext.mainFontSize / 26;

    _linePaint = Paint()
      ..color = renderContext.color
      ..strokeWidth = _lineWidth
      ..strokeCap = StrokeCap.square;

    // calc size
    _lineOffset = renderContext.baselineToCenter;

    double denominatorHeight = _isDense
        ? (denominator.size.height -
            denominator.baselineOffset +
            denominator.baselineToTop)
        : denominator.size.height;
    double numeratorHeight = _isDense
        ? (numerator.size.height * 0.86 + _lineWidth)
        : numerator.size.height;

    size = Size(
        max(numerator.size.width, denominator.size.width) +
            _lineWidth +
            horizontalMultilineOffset,
        numeratorHeight + denominatorHeight + _lineWidth);
    baselineOffset = _lineOffset + _lineWidth + numeratorHeight;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    numerator.paint(
        canvas,
        start + size.width / 2 - numerator.size.width / 2,
        baseline -
            baselineOffset -
            _lineWidth * 0.5 +
            numerator.baselineOffset);

    denominator.paint(
        canvas,
        start + size.width / 2 - denominator.size.width / 2,
        baseline -
            _lineOffset +
            _lineWidth * 0.5 +
            (_isDense
                ? (denominator.baselineToTop + _lineWidth)
                : denominator.baselineOffset));

    // draw fraction line
    double yLine = baseline - _lineOffset - _lineWidth * 0.25;
    canvas.drawLine(
      Offset(start + _lineWidth / 2, yLine),
      Offset(start + size.width - _lineWidth / 2, yLine),
      _linePaint,
    );
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    offsets.add(Offset(start - fontSize * 0.1, baseline));
    fontSizes.add(fontSize);

    numerator.computeCursorPositions(
        start + size.width / 2 - numerator.size.width / 2,
        baseline - baselineOffset - _lineWidth * 0.5 + numerator.baselineOffset,
        offsets,
        fontSizes);

    if (!(numerator is PlaceholderNode ||
        numerator is GroupNode &&
            (numerator as GroupNode).children.isNotEmpty &&
            (numerator as GroupNode).children.last is PlaceholderNode)) {
      offsets.add(Offset(
          start + size.width / 2 + numerator.size.width / 2,
          baseline -
              baselineOffset -
              _lineWidth * 0.5 +
              numerator.baselineOffset));
      fontSizes.add(numerator.fontSize);
    }

    denominator.computeCursorPositions(
        start + size.width / 2 - denominator.size.width / 2,
        baseline -
            _lineOffset +
            _lineWidth * 0.5 +
            (_isDense
                ? (denominator.baselineToTop + _lineWidth)
                : denominator.baselineOffset),
        offsets,
        fontSizes);

    if (!(denominator is PlaceholderNode ||
        denominator is GroupNode &&
            (denominator as GroupNode).children.isNotEmpty &&
            (denominator as GroupNode).children.last is PlaceholderNode)) {
      offsets.add(Offset(
        start + size.width / 2 + denominator.size.width / 2,
        baseline -
            _lineOffset +
            _lineWidth * 0.5 +
            (_isDense
                ? (denominator.baselineToTop + _lineWidth)
                : denominator.baselineOffset),
      ));
      fontSizes.add(denominator.fontSize);
    }
  }

  @override
  bool get isMultiline => true;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType: '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

    str += '\n$indent  numerator:';
    str += '\n${numerator.toStringWithIndent('$indent    ')}';
    str += '\n$indent  denominator:';
    str += '\n${denominator.toStringWithIndent('$indent    ')}';
    return str;
  }
}
