import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';


class NewColumnNode extends LatexRenderNode {


	NewColumnNode();


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);
		baselineOffset = 0;
		size = const Size(0, 0);
	}

	@override
	void paint(Canvas canvas, double start, double baseline) {}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {}


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		return '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
	}
}