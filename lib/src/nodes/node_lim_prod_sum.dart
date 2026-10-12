import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';
import 'node_sup_sub.dart';
import 'node_text.dart';
import 'operator_limits_placement.dart';

enum LimProdSumType {
  coprod,
  lim,
  prod,
  sum,
  bigcap,
  bigcup,
  bigodot,
  bigoplus,
  bigotimes,
  bigsqcup,
  biguplus,
  bigvee,
  bigwedge,
  argmin,
  argmax,
}

class LimProdSumNode extends LatexRenderNode {
  final LimProdSumType type;
  final LatexRenderNode? superscript;
  final LatexRenderNode? subscript;
  final OperatorLimitsPlacement limitsPlacement;

  late final TextNode _parent;
  late final double _fontScaling;
  late final double _superScriptBottomOffset;
  SupSubNode? _sideNode;
  bool _useLimits = true;

  LimProdSumNode({
    required this.type,
    this.superscript,
    this.subscript,
    this.limitsPlacement = OperatorLimitsPlacement.automatic,
  }) {
    switch (type) {
      case LimProdSumType.coprod:
        _parent = TextNode('\u2210');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.lim:
        _parent = TextNode('lim');
        _fontScaling = 1;
        _superScriptBottomOffset = 0;
        break;

      case LimProdSumType.prod:
        _parent = TextNode('\u03a0');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.sum:
        _parent = TextNode('\u03a3');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.bigcap:
        _parent = TextNode('\u2229');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.bigcup:
        _parent = TextNode('\u222a');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.bigodot:
        _parent = TextNode('\u2a00');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.35;
        break;

      case LimProdSumType.bigoplus:
        _parent = TextNode('\u2a01');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.35;
        break;

      case LimProdSumType.bigotimes:
        _parent = TextNode('\u2a02');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.35;
        break;

      case LimProdSumType.bigsqcup:
        _parent = TextNode('\u2a06');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.35;
        break;

      case LimProdSumType.biguplus:
        _parent = TextNode('\u2a04');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.bigvee:
        _parent = TextNode('\u22c1');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.bigwedge:
        _parent = TextNode('\u22c0');
        _fontScaling = 1.5;
        _superScriptBottomOffset = 0.15;
        break;

      case LimProdSumType.argmin:
        _parent = TextNode('arg\u200Amin', textType: TextType.upperCase);
        _fontScaling = 1;
        _superScriptBottomOffset = 0;
        break;

      case LimProdSumType.argmax:
        _parent = TextNode('arg\u200Amax', textType: TextType.upperCase);
        _fontScaling = 1;
        _superScriptBottomOffset = 0;
        break;
    }
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _useLimits = limitsPlacement == OperatorLimitsPlacement.limits ||
        limitsPlacement == OperatorLimitsPlacement.automatic &&
            renderContext.mathStyle == LatexMathStyle.display;
    double parentFontScaling =
        renderContext.mathStyle == LatexMathStyle.text && _fontScaling > 1
            ? 1
            : _fontScaling;

    if (!_useLimits) {
      _sideNode = SupSubNode(
        _ScaledNode(_parent, parentFontScaling),
        superscript: superscript,
        subscript: subscript,
      );
      _sideNode!.performLayout(renderContext);
      size = _sideNode!.size;
      baselineOffset = _sideNode!.baselineOffset;
      spacingRequired = true;
      return;
    }

    _sideNode = null;

    // layout parent
    _parent.performLayout(
        renderContext.copyWith(fontSizeScaling: parentFontScaling));

    // layout super
    RenderContext subSupContext = renderContext.copyWith(
        fontSize: (renderContext.fontSize * 0.7).roundToDouble());

    double superWidth = 0;
    double superBaselineToTop = 0;
    if (superscript != null) {
      superscript!.performLayout(subSupContext);

      if (superscript!.size.height > renderContext.fontSize) {
        superscript!.performLayout(
            subSupContext.copyWith(
                fontSize: (1.2 *
                        subSupContext.fontSize *
                        renderContext.fontSize /
                        superscript!.size.height)
                    .roundToDouble()),
            isDense: true);
      }

      superWidth = superscript!.size.width;
      superBaselineToTop = superscript!.baselineToTop;
    }

    // layout sub
    double subWidth = 0;
    double subHeight = 0;

    if (subscript != null) {
      subscript!.performLayout(subSupContext);

      if (subscript!.size.height > renderContext.fontSize) {
        subscript!.performLayout(
            subSupContext.copyWith(
                fontSize: (1.2 *
                        subSupContext.fontSize *
                        renderContext.fontSize /
                        subscript!.size.height)
                    .roundToDouble()),
            isDense: true);
      }

      subWidth = subscript!.size.width;
      subHeight = subscript!.size.height;
    }

    // calc size
    size = Size(
      max(_parent.size.width, max(superWidth, subWidth)),
      _parent.baselineOffset +
          superBaselineToTop +
          max(subHeight, _parent.size.height - _parent.baselineOffset),
    );
    baselineOffset = _parent.baselineOffset + superBaselineToTop;
    spacingRequired = true;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    if (!_useLimits) {
      _sideNode!.paint(canvas, start, baseline);
      return;
    }

    _parent.paint(
      canvas,
      start + size.width / 2 - _parent.size.width / 2,
      baseline,
    );

    if (superscript != null) {
      superscript!.paint(
        canvas,
        start + size.width / 2 - superscript!.size.width / 2,
        baseline - _parent.baselineOffset + _superScriptBottomOffset * fontSize,
      );
    }

    if (subscript != null) {
      subscript!.paint(
        canvas,
        start + size.width / 2 - subscript!.size.width / 2,
        baseline + subscript!.baselineOffset,
      );
    }
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    _sideNode?.computeCursorPositions(start, baseline, offsets, fontSizes);
  }

  @override
  double get topRightOffset => 0;

  @override
  bool get isMultiline => false;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType: '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

    str += '\n$indent  parent: ${_parent.toStringWithIndent('$indent  ')}';
    str +=
        '\n$indent  superscript: ${superscript?.toStringWithIndent('$indent  ')}';
    str +=
        '\n$indent  subscript: ${subscript?.toStringWithIndent('$indent  ')}';
    return str;
  }
}

class _ScaledNode extends LatexRenderNode {
  final LatexRenderNode child;
  final double fontScaling;

  _ScaledNode(this.child, this.fontScaling);

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);
    child.performLayout(renderContext.copyWith(fontSizeScaling: fontScaling),
        isDense: isDense);
    size = child.size;
    baselineOffset = child.baselineOffset;
    spacingRequired = child.spacingRequired;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    child.paint(canvas, start, baseline);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    child.computeCursorPositions(start, baseline, offsets, fontSizes);
  }

  @override
  double get baselineToTop => child.baselineToTop;

  @override
  double get topRightOffset => child.topRightOffset;

  @override
  bool get isMultiline => child.isMultiline;

  @override
  String toStringWithIndent(String indent) => child.toStringWithIndent(indent);
}
