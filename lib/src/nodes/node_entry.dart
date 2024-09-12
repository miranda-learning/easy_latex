import 'dart:math';

import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../painter/__export.dart';
import '../render/__export.dart';
import '../util/__export.dart';
import 'node.dart';


class EntryNode extends LatexRenderNode {

	static const double lineSpacingFactor = 0.3;

	final List<LatexRenderNode> lines;
	final String sourceText;


	EntryNode({
		required this.lines,
		required this.sourceText,
	});


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		double width = 0;
		double height = 0;

		for (var line in lines) {
			line.performLayout(renderContext);
			width = max(width, line.size.width);
			height += line.size.height;
		}

		if (lines.twoOrMore) {
      height += (lines.length - 1) * renderContext.mainFontSize * lineSpacingFactor;
    }
    size = Size(width, height);
		baselineOffset = lines.first.baselineOffset;

		// if height is 0, we set the height to the height of single letter
		if (height == 0) {
			LatexTextPainter painter = LatexTextPainter.withRenderContext('',  renderContext)..layout();
			size = painter.size;
			baselineOffset = painter.baseline;
		}
	}

	@override
	void paint(Canvas canvas, double start, double baseline, {double? width, MultiLineTextAlign? textAlign}) {
		if (lines.length == 1) {
			lines.first.paint(canvas, start, baseline);
			return;
		}

		width ??= size.width;

		for (var i = 0; i < lines.length; i++) {
			LatexRenderNode line = lines[i];

			// center multiline items
			double horizontalOffset = 0;
			if (lines.length > 1 && textAlign != null && line.size.width < width) {
				if (textAlign == MultiLineTextAlign.center) {
					horizontalOffset = (width - line.size.width)/2;
				} else if (textAlign == MultiLineTextAlign.right) {
					horizontalOffset = (width - line.size.width);
				}
			}

			if (i > 0) baseline += line.baselineOffset;
			line.paint(canvas, start+horizontalOffset, baseline);
			baseline += line.size.height - line.baselineOffset + (renderContext?.mainFontSize ?? 0)*lineSpacingFactor;
		}
	}

	@override
  void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
		// TODO line breaks not supported yet
		lines.first.computeCursorPositions(start, baseline, offsets, fontSizes);
    offsets.add(Offset(start + size.width, baseline)); fontSizes.add(fontSize);
  }


	@override
	bool get isMultiline => lines.twoOrMore || lines.first.isMultiline;


	@override
	bool operator ==(Object value) {
		return value is EntryNode && value.sourceText == sourceText;
	}

	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: w: ${size.width.toStringAsFixed(2)}, h: ${size.height.toStringAsFixed(2)}, baseline: ${baselineOffset.toStringAsFixed(2)}';

		for (var line in lines) {
			str += '\n$indent${line.toStringWithIndent('$indent  ')}';
		}

		return str;
	}

}