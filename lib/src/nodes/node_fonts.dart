import 'package:flutter/widgets.dart';

import '../font/__export.dart';
import '../render/__export.dart';
import 'node.dart';


class FontNode extends LatexRenderNode {

	final LatexRenderNode child;
	final LatexFont? font;
	final bool isBold;


	FontNode(this.child, {
		this.font,
		this.isBold = false,
	});

	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		child.performLayout(renderContext.copyWith(
			font: font,
			isBold: isBold ? true : null,
		));

		size = child.size;
		baselineOffset = child.baselineOffset;
		spacingRequired = child.spacingRequired;
	}

	@override
	void paint(Canvas canvas, double start, double baseline) {
		child.paint(canvas, start, baseline);
	}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
		child.computeCursorPositions(start, baseline, offsets, fontSizes);
	}


	@override
	double get baselineToTop => child.baselineToTop;

	@override
	double get topCenterOffset => child.topCenterOffset;

	@override
	double get topRightOffset => child.topRightOffset;

	@override
	bool get hasDescender => child.hasDescender;

	@override
	bool get isMultiline => child.isMultiline;


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: '
			'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}, '
			'font: ${font?.fontFamily}, bold: ${font?.fontFamily}';

		str += '\n$indent${child.toStringWithIndent('$indent  ')}';
		return str;
	}
}