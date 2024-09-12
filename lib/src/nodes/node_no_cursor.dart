import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';

/// NoCursorNode wird für MitexTextFields für Variablen, Konstanten und weitere Elemente verwendet,
/// um die CursorPositions innerhalb dieser zu unterdrücken
class NoCursorNode extends LatexRenderNode {
  final LatexRenderNode child;

  NoCursorNode(this.child);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    child.performLayout(renderContext);
    baselineOffset = child.baselineOffset;
    size = child.size;
    spacingRequired = child.spacingRequired;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    child.paint(canvas, start, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    // only the start cursor position is set, the others are suppressed
    offsets.add(Offset(start, baseline));
    fontSizes.add(fontSize);
  }

  @override
  double get topCenterOffset => child.topCenterOffset;

  @override
  double get topRightOffset => child.topRightOffset;

  @override
  bool get isMultiline => child.isMultiline;

  @override
  double get baselineToTop => child.baselineToTop;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str =
        '$indent$runtimeType: w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

    str += '\n$indent  ${child.toStringWithIndent('$indent  ')}';
    return str;
  }
}
