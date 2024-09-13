import 'dart:math';

import 'package:flutter/widgets.dart';

import '../util/__export.dart';
import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';
import 'node_bracket.dart';
import 'node_group.dart';
import 'node_new_column.dart';
import 'node_newline.dart';
import 'node_text.dart';

class MatrixNode extends LatexRenderNode {
  final BracketType bracketType;

  List<List<LatexRenderNode>> _rows = [];

  List<double> _rowHeights = [];
  List<double> _rowBaselines = [];
  List<double> _columnWidths = [];

  double _rowSpacing = 0;
  double _columnSpacing = 0;
  double _bracketSpacing = 0;

  late BracketPainter _leftBracket;
  late BracketPainter _rightBracket;

  MatrixNode(List<List<LatexRenderNode>> rows,
      {this.bracketType = BracketType.round}) {
    _rows = rows;
  }

  MatrixNode.fromGroup(GroupNode group,
      {this.bracketType = BracketType.round}) {
    List<LatexRenderNode> children = group.children;

    List<List<GroupNode>> rows = [
      [GroupNode([], BracketType.none)]
    ];

    for (var child in children) {
      if (child is NewColumnNode) {
        if (rows.last.last.children.isEmpty) {
          rows.last.last.children.add(TextNode(''));
        }
        rows.last.add(GroupNode([], BracketType.none));
      } else if (child is NewlineNode) {
        if (rows.last.last.children.isEmpty) {
          rows.last.last.children.add(TextNode(''));
        }
        rows.add([GroupNode([], BracketType.none)]);
      } else {
        rows.last.last.children.add(child);
      }
    }
    if (rows.last.last.children.isEmpty) {
      rows.last.last.children.add(TextNode(''));
    }

    _rows = rows;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    // layout cells
    _rowHeights = Lists.filledSafe(_rows.length, 0.0);
    _rowBaselines = Lists.filledSafe(_rows.length, 0.0);
    _columnWidths = [];

    for (var i = 0; i < _rows.length; i++) {
      double rowBaselineToTop = 0;
      double rowBaselineToBottom = 0;

      for (var j = 0; j < _rows[i].length; j++) {
        _rows[i][j].performLayout(renderContext);
        rowBaselineToTop = max(rowBaselineToTop, _rows[i][j].baselineOffset);
        rowBaselineToBottom = max(rowBaselineToBottom,
            _rows[i][j].size.height - _rows[i][j].baselineOffset);

        if (j >= _columnWidths.length) {
          _columnWidths.add(_rows[i][j].size.width);
        } else {
          _columnWidths[j] = max(_columnWidths[j], _rows[i][j].size.width);
        }
      }

      _rowHeights[i] = rowBaselineToTop + rowBaselineToBottom;
      _rowBaselines[i] = rowBaselineToTop;
    }

    // calc width
    double width = 0;
    for (var w in _columnWidths) {
      width += w;
    }
    _columnSpacing = renderContext.fontSize * 1;
    width += max((_columnWidths.length - 1) * _columnSpacing, 0);

    // calc height
    double height = 0;
    for (var h in _rowHeights) {
      height += h;
    }
    _rowSpacing = renderContext.fontSize * 0;
    height += max((_rowHeights.length - 1) * _rowSpacing, 0);

    // brackets
    _leftBracket = BracketPainter(
        renderContext, height, bracketType, BracketOrientation.left);
    _rightBracket = BracketPainter(
        renderContext, height, bracketType, BracketOrientation.right);
    _bracketSpacing = renderContext.fontSize * 0.08;
    width += (_leftBracket.size.width + _bracketSpacing) * 2;

    // calc size
    size = Size(width, height);
    baselineOffset = height * 0.5 + renderContext.baselineToCenter;
    spacingRequired = true;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _leftBracket.paint(canvas, start, baseline);

    double bracketOffset = _leftBracket.size.width + _bracketSpacing;
    double rowOffset = 0;
    double columnOffset = bracketOffset;

    for (var i = 0; i < _rows.length; i++) {
      for (var j = 0; j < _rows[i].length; j++) {
        _rows[i][j].paint(
            canvas,
            start +
                columnOffset +
                _columnWidths[j] / 2 -
                _rows[i][j].size.width / 2,
            baseline - baselineOffset + rowOffset + _rowBaselines[i]);

        columnOffset += _columnWidths[j] + _columnSpacing;
      }

      rowOffset += _rowHeights[i] + _rowSpacing;
      columnOffset = bracketOffset;
    }

    _rightBracket.paint(
        canvas, start + size.width - _rightBracket.size.width, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    // TODO
  }

  @override
  bool get isMultiline => _rows.twoOrMore;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType: '
        'w: ${size.width}, h: ${size.height}, baseline: $baselineOffset, rows: ${_rowHeights.length}, columns: ${_columnWidths.length}';

    for (var row in _rows) {
      for (var cell in row) {
        str += '\n$indent${cell.toStringWithIndent('$indent  ')}';
      }
    }

    return str;
  }
}
