import 'dart:math';

import 'package:flutter/widgets.dart';

import '../render/__export.dart';
import 'node.dart';
import 'node_int.dart';
import 'node_norm.dart';
import 'node_placeholder.dart';
import 'operator_limits_placement.dart';

class SupSubNode extends LatexRenderNode {
  final LatexRenderNode? parent;
  final LatexRenderNode? superscript;
  final LatexRenderNode? subscript;

  late double _superBaselineOffset;
  late double _superStartOffset;
  late double _subBaselineOffset;
  late double _subStartOffset;
  late double _parentStartOffset;

  SupSubNode(this.parent, {this.superscript, this.subscript});

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    // layout parent
    parent?.performLayout(renderContext);
    Size parentSize = parent?.size ?? const Size(0, 0);
    double parentBaselineOffset = parent?.baselineOffset ?? 0;
    double parentForcedSubStartOffset = 0;
    _parentStartOffset = 0;

    // parent is integral
    bool isInlineInt = false;
    if (parent is IntNode) {
      isInlineInt = (parent as IntNode).usesInlineStyle;
      parentForcedSubStartOffset = isInlineInt
          ? -renderContext.fontSize * 0.25
          : -renderContext.fontSize * 0.35;
    }

    // layout super and sub
    double superInjectedSuperBaselineOffset = 0;
    double subInjectedSubBaselineOffset = 0;
    RenderContext subSupContext = renderContext.copyWith(
      fontSize: (!isInlineInt
              ? renderContext.fontSize * 0.7
              : renderContext.fontSize * 0.5)
          .roundToDouble(),
    );

    if (superscript != null) {
      superscript!.performLayout(subSupContext);

      if (superscript!.size.height > renderContext.fontSize) {
        superscript!.performLayout(
            subSupContext.copyWith(
              fontSize: (1.2 *
                      subSupContext.fontSize *
                      renderContext.fontSize /
                      superscript!.size.height)
                  .roundToDouble(),
            ),
            isDense: true);
        superInjectedSuperBaselineOffset = renderContext.fontSize * 0.04;
      }
    }

    if (subscript != null) {
      subscript!.performLayout(subSupContext);

      if (subscript!.size.height > renderContext.fontSize) {
        subscript!.performLayout(
            subSupContext.copyWith(
              fontSize: (1.2 *
                      subSupContext.fontSize *
                      renderContext.fontSize /
                      subscript!.size.height)
                  .roundToDouble(),
            ),
            isDense: true);
        subInjectedSubBaselineOffset = renderContext.fontSize * 0.04;
      }
    }

    // Explicit integral limits are centered above and below the integral.
    if (parent is IntNode &&
        (parent as IntNode).limitsPlacement == OperatorLimitsPlacement.limits) {
      double width = max(parentSize.width,
          max(superscript?.size.width ?? 0, subscript?.size.width ?? 0));
      double parentTop = -parentBaselineOffset;
      double parentBottom = parentSize.height - parentBaselineOffset;
      double top = parentTop;
      double bottom = parentBottom;

      _parentStartOffset = width / 2 - parentSize.width / 2;

      if (superscript != null) {
        _superStartOffset = width / 2 - superscript!.size.width / 2;
        double superBottom = parentTop + renderContext.fontSize * 0.12;
        _superBaselineOffset = superBottom -
            (superscript!.size.height - superscript!.baselineOffset);
        top = min(top, _superBaselineOffset - superscript!.baselineOffset);
      }

      if (subscript != null) {
        _subStartOffset = width / 2 - subscript!.size.width / 2;
        double subTop = parentBottom - renderContext.fontSize * 0.12;
        _subBaselineOffset = subTop + subscript!.baselineOffset;
        bottom = max(
            bottom,
            _subBaselineOffset +
                subscript!.size.height -
                subscript!.baselineOffset);
      }

      size = Size(width, bottom - top);
      baselineOffset = -top;
      spacingRequired = parent?.spacingRequired ?? false;
      return;
    }

    // parent is norm
    if (parent is NormNode) {
      superInjectedSuperBaselineOffset += (parentSize.height - fontSize) * 0.5;
      subInjectedSubBaselineOffset += (parentSize.height - fontSize) * 0.5;
    }

    // baselines
    if ((parent?.isMultiline ?? false) || isInlineInt) {
      _subBaselineOffset = parentBaselineOffset -
          renderContext.fontSize * 0.6 +
          subInjectedSubBaselineOffset;
      _superBaselineOffset = -parentBaselineOffset +
          renderContext.fontSize * 0.4 -
          superInjectedSuperBaselineOffset;
    } else {
      if (superscript != null && subscript != null) {
        _subBaselineOffset =
            renderContext.fontSize * 0.22 + subInjectedSubBaselineOffset;
        _superBaselineOffset =
            -renderContext.fontSize * 0.40 - superInjectedSuperBaselineOffset;
      } else {
        _subBaselineOffset =
            renderContext.fontSize * 0.18 + subInjectedSubBaselineOffset;
        _superBaselineOffset =
            -renderContext.fontSize * 0.38 - superInjectedSuperBaselineOffset;
      }
    }

    // calc subscript
    double subWidth = 0;
    double subBottomOffset = 0;
    if (subscript != null) {
      subWidth = subscript!.size.width + parentForcedSubStartOffset;
      _subStartOffset = parentSize.width + parentForcedSubStartOffset;
      subBottomOffset = max(
          _subBaselineOffset +
              (subscript!.size.height - subscript!.baselineOffset) -
              (parentSize.height - parentBaselineOffset),
          0);
    }

    // calc superscript
    double superWidth = 0;
    double superTopOffset = 0;
    if (superscript != null) {
      superWidth = superscript!.size.width + (parent?.topRightOffset ?? 0) * 5;
      _superStartOffset = parentSize.width + (parent?.topRightOffset ?? 0) * 5;
      superTopOffset = max(
          _superBaselineOffset.abs() +
              superscript!.baselineOffset -
              parentBaselineOffset,
          0);
    }

    // calc size
    size = Size(parentSize.width + max(superWidth, subWidth),
        parentSize.height + superTopOffset + subBottomOffset);
    baselineOffset = parentBaselineOffset + superTopOffset;
    spacingRequired = parent?.spacingRequired ?? false;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    parent?.paint(canvas, start + _parentStartOffset, baseline);
    superscript?.paint(
        canvas, start + _superStartOffset, baseline + _superBaselineOffset);
    subscript?.paint(
        canvas, start + _subStartOffset, baseline + _subBaselineOffset);
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    parent?.computeCursorPositions(
        start + _parentStartOffset, baseline, offsets, fontSizes);

    if (parent != null) {
      if (parent is IntNode) {
        // ignore for definite integrals
      } else if (parent is! PlaceholderNode) {
        offsets.add(Offset(start + parent!.size.width, baseline));
        fontSizes.add(parent!.fontSize);
      }
    } else if (parent == null) {
      // If parent is null means that SupSubNode is at the beginning.
      // So, we have to add the cursor position at the beginning
      offsets.add(Offset(start, baseline));
      fontSizes.add(fontSize);
    }

    subscript?.computeCursorPositions(start + _subStartOffset,
        baseline + _subBaselineOffset, offsets, fontSizes);

    if (shouldAddCursorAfterwards(subscript)) {
      offsets.add(Offset(start + _subStartOffset + subscript!.size.width,
          baseline + _subBaselineOffset));
      fontSizes.add(subscript!.fontSize);
    }

    superscript?.computeCursorPositions(start + _superStartOffset,
        baseline + _superBaselineOffset, offsets, fontSizes);

    if (shouldAddCursorAfterwards(superscript)) {
      offsets.add(Offset(start + _superStartOffset + superscript!.size.width,
          baseline + _superBaselineOffset));
      fontSizes.add(superscript!.fontSize);
    }
  }

  @override
  double get topRightOffset => parent?.topRightOffset ?? 0;

  @override
  bool get isMultiline => parent?.isMultiline ?? false;

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) {
    String str = '$indent$runtimeType: '
        'w: ${size.width}, h: ${size.height}, baseline: ${baselineOffset.toStringAsFixed(2)}';

    str += '\n$indent  parent: ${parent?.toStringWithIndent('$indent  ')}';
    str +=
        '\n$indent  superscript: ${superscript?.toStringWithIndent('$indent  ')}';
    str +=
        '\n$indent  subscript: ${subscript?.toStringWithIndent('$indent  ')}';
    return str;
  }
}
