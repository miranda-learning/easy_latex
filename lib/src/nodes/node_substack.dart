import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';
import 'node_bracket.dart';
import 'node_group.dart';
import 'node_newline.dart';
import 'node_text.dart';

class SubstackNode extends LatexRenderNode {
  final List<GroupNode> rows;

  List<double> _rowHeights = [];
  List<double> _rowBaselines = [];
  double _rowSpacing = 0;

  SubstackNode.fromGroup(GroupNode group)
      : rows = [GroupNode([], BracketType.none)] {
    for (var child in group.children) {
      if (child is NewlineNode) {
        if (rows.last.children.isEmpty) rows.last.children.add(TextNode(''));
        rows.add(GroupNode([], BracketType.none));
      } else {
        rows.last.children.add(child);
      }
    }

    if (rows.last.children.isEmpty) rows.last.children.add(TextNode(''));
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _rowHeights = [];
    _rowBaselines = [];
    _rowSpacing = -renderContext.fontSize * 0.12;

    double width = 0;
    double height = 0;
    for (var row in rows) {
      row.performLayout(renderContext, isDense: true);
      width = max(width, row.size.width);
      height += row.size.height;
      _rowHeights.add(row.size.height);
      _rowBaselines.add(row.baselineOffset);
    }
    height += max(0, rows.length - 1) * _rowSpacing;

    size = Size(width, height);
    baselineOffset = height / 2 + renderContext.baselineToCenter * 0.5;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    double top = baseline - baselineOffset;
    double rowOffset = 0;
    for (var i = 0; i < rows.length; i++) {
      rows[i].paint(
        canvas,
        start + size.width / 2 - rows[i].size.width / 2,
        top + rowOffset + _rowBaselines[i],
      );
      rowOffset += _rowHeights[i] + _rowSpacing;
    }
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    double top = baseline - baselineOffset;
    double rowOffset = 0;
    for (var i = 0; i < rows.length; i++) {
      rows[i].computeCursorPositions(
        start + size.width / 2 - rows[i].size.width / 2,
        top + rowOffset + _rowBaselines[i],
        offsets,
        fontSizes,
      );
      rowOffset += _rowHeights[i] + _rowSpacing;
    }
  }

  @override
  bool get isMultiline => true;

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType (${rows.length}): '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    for (var row in rows) {
      str += '\n${row.toStringWithIndent('$indent  ')}';
    }
    return str;
  }
}
