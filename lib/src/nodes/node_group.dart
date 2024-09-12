import 'dart:math';

import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';
import 'node_bracket.dart';
import 'node_number.dart';
import 'node_placeholder.dart';
import 'node_top_decoration.dart';

class GroupNode extends LatexRenderNode {
  final List<LatexRenderNode> children;
  BracketType bracketType;
  Color? color;

  BracketPainter? _leftBracket;
  BracketPainter? _rightBracket;
  double _bracketSpacing = 0;

  late List<double> spacings;

  GroupNode(this.children, this.bracketType, {this.color});

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    RenderContext context =
        color != null ? renderContext.copyWith(color: color) : renderContext;
    for (var child in children) {
      child.performLayout(context, isDense: isDense);
    }

    spacings = [];

    double groupWidth = 0;
    double groupBaselineToTop = 0;
    double groupBaselineToBottom = 0;

    for (var i = 0; i < children.length; i++) {
      groupWidth += children[i].size.width;
      groupBaselineToTop = max(groupBaselineToTop, children[i].baselineOffset);
      groupBaselineToBottom = max(groupBaselineToBottom,
          children[i].size.height - children[i].baselineOffset);

      // spacing
      if (i == children.length - 1 ||
          (children[i] is NumberNode && children[i + 1] is TopDecorationNode)) {
        // second part required for 1.\dot9 (1.9 periodic)
        spacings.add(0);
      } else {
        double s = context.fontSize * 0.05;
        if (children[i].spacingRequired || children[i + 1].spacingRequired) {
          s = context.fontSize * 0.15;
        }
        spacings.add(s);
        groupWidth += s;
      }
    }

    double groupHeight = groupBaselineToTop + groupBaselineToBottom;

    // brackets
    if (bracketType != BracketType.none) {
      _leftBracket = BracketPainter(
          context, groupHeight, bracketType, BracketOrientation.left);
      _rightBracket = BracketPainter(
          context, groupHeight, bracketType, BracketOrientation.right);
      _bracketSpacing = context.fontSize * 0.16;

      groupWidth += (_leftBracket!.size.width + _bracketSpacing) * 2;
    }

    size = Size(groupWidth, groupHeight);
    baselineOffset = groupBaselineToTop;
    if (children.isNotEmpty) {
      spacingRequired =
          children.first.spacingRequired || children.last.spacingRequired;
    }
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _leftBracket?.paint(canvas, start + fontSize * 0.04, baseline);

    double startOffset =
        _leftBracket != null ? (_leftBracket!.size.width + _bracketSpacing) : 0;
    for (var i = 0; i < children.length; i++) {
      children[i].paint(canvas, start + startOffset, baseline);
      startOffset += children[i].size.width + spacings[i];
    }

    _rightBracket?.paint(
        canvas,
        start + size.width - _rightBracket!.size.width - fontSize * 0.04,
        baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    // left bracket
    double startOffset =
        _leftBracket != null ? (_leftBracket!.size.width + _bracketSpacing) : 0;
    if (startOffset > 0) {
      offsets.add(Offset(start, baseline));
      fontSizes.add(fontSize);
    }

    // group
    for (var i = 0; i < children.length; i++) {
      children[i].computeCursorPositions(
          start + startOffset, baseline, offsets, fontSizes);
      startOffset += children[i].size.width + spacings[i];
    }

    // right bracket
    if (_rightBracket != null &&
        children.isNotEmpty &&
        children.last is! PlaceholderNode) {
      offsets.add(Offset(
          start + size.width - _rightBracket!.size.width - fontSize * 0.08,
          baseline));
      fontSizes.add(fontSize);
    }
  }

  @override
  double get baselineToTop {
    double v = 0;
    for (var child in children) {
      v = max(v, child.baselineToTop);
    }
    return v;
  }

  @override
  double get topCenterOffset =>
      children.length == 1 ? children.first.topCenterOffset : 0;

  @override
  bool get hasDescender {
    for (var child in children) {
      if (child.hasDescender) return true;
    }
    return false;
  }

  @override
  double get topRightOffset =>
      children.isNotEmpty ? children.last.topRightOffset : 0;

  @override
  bool get isMultiline {
    for (var child in children) {
      if (child.isMultiline) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType (${children.length}): '
        'w: ${size.width.toStringAsFixed(2)}, '
        'h: ${size.height.toStringAsFixed(2)}, '
        'baseline: ${baselineOffset.toStringAsFixed(2)}, '
        'color: $color';

    if (_leftBracket != null) {
      str += '\n$indent  - left bracket: ${_leftBracket?.bracketType}';
    }

    if (_rightBracket != null) {
      str += '\n$indent  - right bracket: ${_rightBracket?.bracketType}';
    }

    for (var i = 0; i < children.length; i++) {
      str += '\n${children[i].toStringWithIndent('$indent  ')}';
    }

    return str;
  }
}
