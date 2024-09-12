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


class CasesNode extends LatexRenderNode {

	late List<List<LatexRenderNode>> _rows;

	late List<double> _rowHeights;
	late List<double> _rowBaselines;
	late List<double> _columnWidths;

	late double _rowSpacing;
	late double _columnSpacing;
	late double _bracketSpacing;

	late BracketPainter _leftBracket;


	CasesNode(List<List<LatexRenderNode>> rows) {
		_rows = rows;
	}

	CasesNode.fromGroup(GroupNode group) {
		List<LatexRenderNode> children = group.children;

		List<List<GroupNode>> rows = [[GroupNode([], BracketType.none)]];

		for (var child in children) {
			if (child is NewColumnNode) {
				rows.last.add(GroupNode([], BracketType.none));
			} else if (child is NewlineNode) {
				rows.add([GroupNode([], BracketType.none)]);
			} else {
				rows.last.last.children.add(child);
			}
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
				rowBaselineToBottom = max(rowBaselineToBottom, _rows[i][j].size.height - _rows[i][j].baselineOffset);

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
		_columnSpacing = renderContext.fontSize*1;
		width += max((_columnWidths.length-1) * _columnSpacing, 0.0);


		// calc height
		double height = 0;
		for (var h in _rowHeights) {
		  height += h;
		}
		_rowSpacing = renderContext.fontSize*0;
		height += max((_rowHeights.length-1) * _rowSpacing, 0.0);


		// brackets
		_leftBracket = BracketPainter(renderContext, height, BracketType.curly, BracketOrientation.left);
		_bracketSpacing = renderContext.fontSize*0.24;
		width += _leftBracket.size.width + _bracketSpacing;


		// calc size
		size = Size(width, height);
		baselineOffset = height*0.5 + renderContext.baselineToCenter;
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

				_rows[i][j].paint(canvas,
					start + columnOffset,
					baseline - baselineOffset + rowOffset +_rowBaselines[i]
				);

				columnOffset += _columnWidths[j] + _columnSpacing;
			}

			rowOffset += _rowHeights[i] + _rowSpacing;
			columnOffset = bracketOffset;
		}
	}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
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