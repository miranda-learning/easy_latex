import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';
import 'node_matrix.dart';


class BinomNode extends LatexRenderNode {

	final LatexRenderNode n;
	final LatexRenderNode k;

	late MatrixNode _matrixNode;


	BinomNode(this.n, this.k);


	@override
	void performLayout(RenderContext renderContext, {isDense = false}) {
		super.performLayout(renderContext);

		_matrixNode = MatrixNode([[n], [k]]);
		_matrixNode.performLayout(renderContext);

		size = _matrixNode.size;
		baselineOffset = _matrixNode.baselineOffset;
		spacingRequired = true;
	}

	@override
	void paint(Canvas canvas, double start, double baseline) {
		_matrixNode.paint(canvas, start, baseline);
	}

	@override
	void computeCursorPositions(double start, double baseline, List<Offset> offsets, List<double> fontSizes) {
		_matrixNode.computeCursorPositions(start, baseline, offsets, fontSizes);
	}


	@override
	bool get isMultiline => true;


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: '
			'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

		str += '\n$indent  n:';
		str += '\n$indent${n.toStringWithIndent('$indent  ')}';
		str += '\n$indent  k:';
		str += '\n$indent${k.toStringWithIndent('$indent  ')}';
		return str;
	}
}