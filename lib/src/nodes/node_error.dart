import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../render/__export.dart';
import 'node_placeholder.dart';
import 'node_text.dart';
import 'node.dart';

enum ErrorVisualization {
  showInvalidSyntax,
  redPlaceholder;

  static ErrorVisualization fromParsing(ParsingMode mode) {
    switch (mode) {
      case ParsingMode.minorErrorsAsInvalidSyntax:
        return ErrorVisualization.showInvalidSyntax;
      case ParsingMode.minorErrorsAsRedPlaceholders:
        return ErrorVisualization.redPlaceholder;
      case ParsingMode.strict:
        return ErrorVisualization.redPlaceholder;
    }
  }
}

class ErrorNode extends LatexRenderNode {
  final ErrorVisualization errorVisualization;
  final String msg;
  late LatexRenderNode _child;

  ErrorNode({
    required this.errorVisualization,
    required this.msg,
  }) {
    switch (errorVisualization) {
      case ErrorVisualization.showInvalidSyntax:
        _child = TextNode(msg,
            color: const Color(0xFFFFEB3B), bgColor: const Color(0xFFF44336));
        break;
      case ErrorVisualization.redPlaceholder:
        _child = PlaceholderNode(type: PlaceholderType.red);
        break;
    }
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    _child.performLayout(renderContext, isDense: isDense);
    size = _child.size;
    baselineOffset = _child.baselineOffset;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _child.paint(canvas, start, baseline);
  }

  @override
  double get baselineToTop => _child.baselineToTop;

  @override
  double get topCenterOffset => _child.topCenterOffset;

  @override
  double get topRightOffset => _child.topRightOffset;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str =
        '$indent$runtimeType: w: ${size.width}, h: ${size.height}, visualization: ${errorVisualization.name}, baseline: ${baselineOffset.toStringAsFixed(2)}';
    return str;
  }
}
