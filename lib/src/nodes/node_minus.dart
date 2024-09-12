import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';


class MinusNode extends LatexRenderNode {


	MinusNode();


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		// calc size
		baselineOffset = renderContext.fontSize/2;
		size = Size(renderContext.fontSize*0.44, renderContext.fontSize/2);
	}

	@override
	void paint(Canvas canvas, double start, double baseline) {
		Paint linePaint = Paint()
			..color = renderContext!.color
			..strokeWidth = renderContext!.mainFontSize / 24
			..strokeCap = StrokeCap.square;


		double y = baseline - size.height*0.6;

		canvas.drawLine(
			Offset(start + size.width*0.15, y),
			Offset(start + size.width*0.85, y),
			linePaint,
		);
	}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
		offsets.add(Offset(start, baseline)); fontSizes.add(fontSize);
	}


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';
		return str;
	}
}