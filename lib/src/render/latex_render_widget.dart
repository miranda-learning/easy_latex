import 'package:flutter/widgets.dart';

import '../enums.dart';
import '../nodes/__export.dart';
import 'handler_line_breaks.dart';
import 'render_context.dart';

class LatexRenderWidget extends LeafRenderObjectWidget {
  final EntryNode entryNode;
  final RenderContext renderContext;
  final Color? backgroundColor;
  final double baselineOffset;
  final LatexWrapMode wrapMode;
  final MultiLineTextAlign? textAlign;

  const LatexRenderWidget({
    super.key,
    required this.entryNode,
    required this.renderContext,
    this.backgroundColor,
    this.baselineOffset = 0,
    this.wrapMode = LatexWrapMode.none,
    this.textAlign,
  });

  @override
  RenderBox createRenderObject(BuildContext context) => LatexRenderBox(
        entryNode: entryNode,
        renderContext: renderContext,
        backgroundColor: backgroundColor,
        baselineOffset: baselineOffset,
        wrapMode: wrapMode,
        textAlign: textAlign,
      );

  @override
  updateRenderObject(BuildContext context, LatexRenderBox renderObject) {
    renderObject.update(
      entryNode: entryNode,
      renderContext: renderContext,
      backgroundColor: backgroundColor,
      baselineOffset: baselineOffset,
      wrapMode: wrapMode,
      textAlign: textAlign,
    );
  }

  Size preLayout() {
    entryNode.performLayout(renderContext);
    return entryNode.size;
  }
}

class LatexRenderBox extends RenderBox {
  EntryNode entryNode;
  RenderContext renderContext;
  Color? backgroundColor;
  double baselineOffset;
  LatexWrapMode wrapMode;
  MultiLineTextAlign? textAlign;

  MultiLineTextAlign? _customTextAlign;

  LatexRenderBox({
    required this.entryNode,
    required this.renderContext,
    required this.backgroundColor,
    required this.baselineOffset,
    required this.wrapMode,
    required this.textAlign,
  });

  void update({
    required EntryNode entryNode,
    required RenderContext renderContext,
    required Color? backgroundColor,
    required double baselineOffset,
    required LatexWrapMode wrapMode,
    required MultiLineTextAlign? textAlign,
  }) {
    if (entryNode != this.entryNode ||
        renderContext != this.renderContext ||
        backgroundColor != this.backgroundColor ||
        baselineOffset != this.baselineOffset ||
        wrapMode != this.wrapMode ||
        textAlign != this.textAlign) {
      this.entryNode = entryNode;
      this.renderContext = renderContext;
      this.backgroundColor = backgroundColor;
      this.baselineOffset = baselineOffset;
      this.wrapMode = wrapMode;
      this.textAlign = textAlign;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  bool get isRepaintBoundary => true; // separates repainting from its parent

  @override
  double computeMinIntrinsicWidth(double height) =>
      _computeIntrinsicSize().width;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _computeIntrinsicSize().width;

  @override
  double computeMinIntrinsicHeight(double width) =>
      _computeIntrinsicSize().height;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _computeIntrinsicSize().height;

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      entryNode.baselineOffset + baselineOffset;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _computeIntrinsicSize(constraints);

  @override
  void performLayout() {
    size = _computeIntrinsicSize(constraints);

    // dPrint(
    // 	'fs: ${renderContext.fontSize}, ${entryNode.sourceText}, '
    // 	'h: ${entryNode.size.height} ($nodeHeight), '
    // 	'baseline: ${entryNode.baselineOffset} ($_baselineOffset), '
    // 	'b/h: ${entryNode.baselineOffset/entryNode.size.height}'
    // );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (backgroundColor != null) {
      context.canvas.drawRect(
        Rect.fromLTRB(0, 0, entryNode.size.width, entryNode.size.height),
        Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor!,
      );
    }

    entryNode.paint(
      context.canvas,
      offset.dx,
      entryNode.baselineOffset,
      width: wrapMode != LatexWrapMode.none ? size.width : null,
      textAlign: textAlign ?? _customTextAlign ?? MultiLineTextAlign.center,
    );
  }

  Size _computeIntrinsicSize([BoxConstraints? constraints]) {
    // dPrint('_computeIntrinsicSize - ${entryNode.sourceText} - constraints: $constraints, minHeight: $minHeight');

    entryNode.performLayout(renderContext);

    // add line breaks
    if (constraints != null && entryNode.size.width > constraints.maxWidth) {
      switch (wrapMode) {
        case LatexWrapMode.none:
          _customTextAlign = null;
          break;

        case LatexWrapMode.simple:
          entryNode = LineBreaksHandler.addLineBreaks(
              entryNode, renderContext, constraints.maxWidth);
          _customTextAlign = null;
          entryNode.performLayout(renderContext);
          break;

        case LatexWrapMode.smart:
          var r = LineBreaksHandler.addSmartLineBreaks(
              entryNode, renderContext, constraints.maxWidth);
          entryNode = r.$1;
          _customTextAlign = r.$2;
          entryNode.performLayout(renderContext);
          break;
      }
    }

    // // see latex_app_browser.md for more information
    // if (isInline && kIsWeb) {
    // 	nodeHeight = nodeHeight.roundToDouble();
    // 	_baselineOffset = _baselineOffset.floorToDouble();
    // }

    if (constraints != null) {
      return Size(
        entryNode.size.width.clamp(constraints.minWidth, constraints.maxWidth),
        entryNode.size.height
            .clamp(constraints.minHeight, constraints.maxHeight),
      );
    } else {
      return entryNode.size;
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LatexRenderWidget: w: ${size.width}, h: ${size.height}'
        '\n${entryNode.toString()}';
  }
}
