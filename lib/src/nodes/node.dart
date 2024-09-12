import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node_comma.dart';
import 'node_error.dart';
import 'node_group.dart';
import 'node_placeholder.dart';

abstract class LatexRenderNode {
  Size size = const Size(0, 0);
  double baselineOffset = 0;
  bool spacingRequired = false;
  RenderContext? renderContext;

  @mustCallSuper
  void performLayout(RenderContext renderContext, {isDense = false}) {
    this.renderContext = renderContext;
  }

  void paint(Canvas canvas, double start, double baseline);

  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    offsets.add(Offset(start, baseline));
    fontSizes.add(fontSize);
  }

  bool shouldAddCursorAfterwards(LatexRenderNode? node) {
    return !(node == null ||
        node is ErrorNode ||
        node is PlaceholderNode ||
        node is CommaNode && node.isListSeparator ||
        node is GroupNode &&
            node.children.isNotEmpty &&
            node.children.last is PlaceholderNode);
  }

  double get fontSize => renderContext?.fontSize ?? 0;

  // distance between baseline and top drawn part of the node,
  // different distance for lowercase and uppercase letters
  double get baselineToTop => baselineOffset;

  // offset used to align top decoration of child is text and
  // text style is italic
  double get topCenterOffset => 0;

  // offset used to compensate for overhanging letters (eg. V, W)
  double get topRightOffset => 0;

  // text with g, j, q, p and y
  bool get hasDescender => false;

  bool get isMultiline => false;

  String toStringWithIndent(String indent);
}
