import 'dart:math';

import 'package:flutter/widgets.dart';

import '../painter/__export.dart';
import '../render/__export.dart';
import 'node.dart';


class SqrtNode extends LatexRenderNode {

	static double get f => 0.55;

	final LatexRenderNode child;
	final LatexRenderNode? exponent;

	late SqrtPainter _sqrtPainter;
	late double _exponentWidthOffset = 0;


	SqrtNode(this.child, {this.exponent});


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		// layout children
		child.performLayout(renderContext);
		exponent?.performLayout(renderContext.copyWith(fontSizeScaling: 0.5));

		// sqrt painter
		_sqrtPainter = SqrtPainter(renderContext,
			Size(
				child.size.width + child.topCenterOffset + child.topRightOffset,
				child.isMultiline ? child.size.height : baselineToTop - fontSize*0.12
			),
			child.isMultiline,
		);

		if (exponent != null) {
			_exponentWidthOffset = max(0, exponent!.size.width - _sqrtPainter.rootWidth*f);
		}

		baselineOffset = max(child.baselineOffset, baselineToTop);
		size = Size(_sqrtPainter.size.width + _exponentWidthOffset, child.size.height - child.baselineOffset + baselineOffset);
		spacingRequired = true;
	}


	@override
	void paint(Canvas canvas, double start, double baseline) {
		child.paint(canvas, start + _sqrtPainter.rootWidth + _exponentWidthOffset, baseline);

		exponent?.paint(
			canvas,
			start + _exponentWidthOffset + _sqrtPainter.rootWidth*f - exponent!.size.width,
			isMultiline ? (baseline - fontSize * 0.5) : (baseline - baselineOffset/2)
		);

		_sqrtPainter.paint(canvas, start + _exponentWidthOffset, baseline - child.baselineOffset, baseline);
	}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
		offsets.add(Offset(start, baseline)); fontSizes.add(fontSize);

		if (exponent != null) {
			exponent!.computeCursorPositions(
				start + _exponentWidthOffset + _sqrtPainter.rootWidth*f - exponent!.size.width,
				isMultiline ? (baseline - fontSize * 0.5) : (baseline - baselineOffset/2),
				offsets,
				fontSizes
			);

			if (shouldAddCursorAfterwards(exponent)) {
				offsets.add(Offset(
					start + _exponentWidthOffset + _sqrtPainter.rootWidth*f,
					isMultiline ? (baseline - fontSize * 0.5) : (baseline - baselineOffset/2),
				));
				fontSizes.add(exponent!.fontSize);
			}
		}


		child.computeCursorPositions(
			start + _sqrtPainter.rootWidth + _exponentWidthOffset,
			baseline,
			offsets,
			fontSizes
		);

		if (shouldAddCursorAfterwards(child)) {
			offsets.add(Offset(start + _sqrtPainter.rootWidth + _exponentWidthOffset + child.size.width, baseline)); fontSizes.add(fontSize);
		}
	}


	@override
	bool get isMultiline => child.isMultiline;

	@override
	double get baselineToTop => max(child.baselineToTop + fontSize*0.24, fontSize*0.9);

	@override
	bool get hasDescender => child.hasDescender;


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: '
			'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

		str += '\n$indent  child:';
		str += '\n$indent${child.toStringWithIndent('$indent  ')}';
		str += '\n$indent  exponent:';
		str += '\n$indent${exponent?.toStringWithIndent('$indent  ')}';

		return str;
	}
}