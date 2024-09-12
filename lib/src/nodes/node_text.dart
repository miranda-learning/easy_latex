import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../font/__export.dart';
import '../painter/__export.dart';
import '../parser/__export.dart';
import '../render/__export.dart';
import 'node.dart';

enum TextType {
  lowerCase,
  mediumCase,
  upperCase,
}

class TextNode extends LatexRenderNode {
  String text;
  final TextType textType;
  final bool? isBold;
  final Color? color;
  final Color? bgColor;

  late LatexFont _font;
  late LatexTextPainter _textPainter;

  TextNode(
    this.text, {
    TextType? textType,
    LatexFont? font,
    this.isBold,
    this.color,
    this.bgColor,
    bool spacingRequired = false,
  }) : textType = textType ?? calcTextType(text) {
    _font = font ?? MainLatexFont();
    super.spacingRequired = spacingRequired;
  }

  @override
  void performLayout(RenderContext renderContext, {isDense = false}) {
    super.performLayout(renderContext);

    _font = renderContext.font ?? _font;

    _textPainter = LatexTextPainter(
      text,
      fontSize: fontSize,
      isBold: isBold ?? renderContext.isBold,
      color: color ?? renderContext.color,
      bgColor: bgColor,
      font: _font,
    );
    _textPainter.layout();

    size = _textPainter.size;
    baselineOffset = _textPainter.baseline;
  }

  @override
  void paint(Canvas canvas, double start, double baseline) {
    _textPainter.paint(canvas, Offset(start, baseline - baselineOffset));
  }

  @override
  void computeCursorPositions(double start, double baseline,
      List<Offset> offsets, List<double> fontSizes) {
    // some texts are treated as single units since they represent a function
    for (var f in functionNames) {
      if (text == f) {
        super.computeCursorPositions(start, baseline, offsets, fontSizes);
        return;
      }
    }

    for (var i = 0; i < text.length; i++) {
      // ignore any spaces
      if (text[i] == '\u00a0' || text[i] == '\u200A') {
        continue;
      }

      offsets.add(Offset(
          start +
              _textPainter
                  .getOffsetForCaret(TextPosition(offset: i), Rect.zero)
                  .dx,
          baseline));
      fontSizes.add(fontSize);
    }
  }

  TextNode copy() {
    return TextNode(
      text,
      textType: textType,
      font: _font,
      spacingRequired: spacingRequired,
    );
  }

  @override
  double get baselineToTop {
    if (textType == TextType.upperCase) {
      return fontSize * 0.75;
    } else if (textType == TextType.mediumCase) {
      return fontSize * 0.68;
    } else {
      return fontSize * 0.5;
    }
  }

  @override
  double get topCenterOffset {
    if (_font is MainItalicLatexFont) {
      switch (textType) {
        case TextType.upperCase:
          return fontSize * 0.11;
        case TextType.mediumCase:
          return fontSize * 0.05;
        case TextType.lowerCase:
          return fontSize * 0.05;
      }
    }

    return 0;
  }

  @override
  double get topRightOffset =>
      _font is MainItalicLatexFont ? calcTopRightOffset(fontSize) : 0;

  @override
  bool get hasDescender => _hasDescenders(text);

  static TextType calcTextType(String text) {
    if (text.toLowerCase() != text ||
        text.contains('b') ||
        text.contains('d') ||
        text.contains('f') ||
        text.contains('h') ||
        text.contains('i') ||
        text.contains('j') ||
        text.contains('k') ||
        text.contains('l') ||
        text.contains('t')) {
      return TextType.upperCase;
    } else if (text.contains('ä') || text.contains('ö') || text.contains('ü')) {
      return TextType.mediumCase;
    } else {
      return TextType.lowerCase;
    }
  }

  bool _hasDescenders(String text) {
    return (text.contains('f') && _font is MainItalicLatexFont ||
        text.contains('g') ||
        text.contains('j') ||
        text.contains('p') ||
        text.contains('q') ||
        text.contains('y'));
  }

  double calcTopRightOffset(double fontSize) {
    if (text.isEmpty) return 0;

    if (text.endsWith('A') ||
        text.endsWith('B') ||
        text.endsWith('D') ||
        text.endsWith('G') ||
        text.endsWith('L') ||
        text.endsWith('O') ||
        text.endsWith('Q') ||
        text.endsWith('R')) return fontSize * 0;

    if (text.endsWith('d') ||
        text.endsWith('E') ||
        text.endsWith('I') ||
        text.endsWith('K') ||
        text.endsWith('S') ||
        text.endsWith('X') ||
        text.endsWith('Z')) return fontSize * 0.01;

    if (text.endsWith('f') ||
        text.endsWith('C') ||
        text.endsWith('H') ||
        text.endsWith('J') ||
        text.endsWith('M') ||
        text.endsWith('N') ||
        text.endsWith('P') ||
        text.endsWith('T') ||
        text.endsWith('U') ||
        text.endsWith('W')) return fontSize * 0.02;

    if (text.endsWith('F')) return fontSize * 0.03;

    if (text.endsWith('V') || text.endsWith('Y')) return fontSize * 0.04;

    return 0;
  }

  @override
  String toString() => toStringWithIndent('');

  @override
  String toStringWithIndent(String indent) => '$indent$runtimeType: $text, '
      'w: ${size.width}, h: ${size.height}, baseline: $baselineOffset, fontType: ${_font.fontFamily}, fontSize: $fontSize';
}
