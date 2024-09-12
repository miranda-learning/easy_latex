import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';


enum NormSize {
	big,
	Big,
	bigg,
	Bigg
}

class NormNode extends LatexRenderNode {

	final NormSize normSize;


	NormNode(this.normSize);


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		double height;
		switch (normSize) {
		  case NormSize.big: height = renderContext.fontSize*1.2; break;
		  case NormSize.Big: height = renderContext.fontSize*1.6; break;
		  case NormSize.bigg: height = renderContext.fontSize*2.0; break;
		  case NormSize.Bigg: height = renderContext.fontSize*2.4; break;
		}

		size = Size(renderContext.fontSize * 0.24, height);
		baselineOffset = renderContext.baselineToCenter + height/2;
	}

	@override
	void paint(Canvas canvas, double start, double baseline) {

		double lineWidth = renderContext!.fontSize * 0.04;
		start += size.width/2 - lineWidth/2;

		Paint paint = Paint()
			..color = renderContext!.color
			..strokeWidth = lineWidth;

		canvas.drawLine(
			Offset(start, baseline - baselineOffset),
			Offset(start, baseline - baselineOffset + size.height),
			paint
		);
	}



	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		return '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}, '
		'normSize: $normSize';
	}
}