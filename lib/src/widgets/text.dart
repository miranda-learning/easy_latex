import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../enums.dart';
import '../util/__export.dart';
import 'span_latex.dart';


enum _SpanType {
  regular,
  bold,
  italic,
  code,
  latex;

  bool get isRegular => this == regular;
  bool get isBold => this == bold;
  bool get isItalic => this == italic;
  bool get isCode => this == code;
  bool get isLatex => this == latex;
}

class _SpanItem {
  final String text;
  final _SpanType type;

  _SpanItem(this.text, this.type);
}


/// The LText allows you to integrate Markdown and LaTeX into your text.
///
/// This widget supports basic Markdown syntax for styling text and allows the inclusion of LaTeX
/// for mathematical expressions, making it suitable for educational and scientific applications
/// where rich text and complex formulas need to be displayed together.
///
/// **Supported Markdown commands:** `LText()` supports the certain Markdown to style the text.
///   - `**bold**`
///   - `*italic*`
///   - ``` `code` ```
///   - `\(Latex\)`
class LText extends StatelessWidget {

  /// Constructs a [LText] widget that can display styled text and mathematical expressions.
  ///
  /// The [style] parameter allows for customization of text appearance such as color,
  /// background, font size, and weight. Markdown features enable bold, italic, and code
  /// formatting, with additional support for embedding LaTeX expressions for complex
  /// mathematical notation.
  LText(this.text, {
    super.key,
    TextStyle? style,
    double fontSize = defaultFontSize,
    Color color = Colors.black,
    Color? backgroundColor,
    FontWeight? fontWeight,
    this.boldWeight = FontWeight.w700,
    this.codeBackgroundColor = const Color(0xFFeeeeee),
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.softWrap,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor,
    this.maxLines,
    this.textWidthBasis,
    this.latexSizeFactor = 1,
    this.latexParsing = ParsingMode.strict,
    this.latexLocale,
  }) :
      style = style ?? TextStyle(
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w400,
      );

  /// The default font size used if no specific font size is provided.
  static const double defaultFontSize = 14;

  /// The text to be rendered, potentially including Markdown and LaTeX syntax.
  final String text;

  /// Style configuration for the text.
  final TextStyle style;

  /// The font weight to use for bold text specified in Markdown.
  final FontWeight boldWeight;

  /// Background color for text segments formatted as code in Markdown.
  final Color codeBackgroundColor;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection textDirection;

  /// Whether the text should wrap if it exceeds the line width.
  final bool? softWrap;

  /// How overflowing text should be handled.
  final TextOverflow? overflow;

  /// The scale factor to be applied to the text's font size.
  final double? textScaleFactor;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The strategy to use when calculating the width of the text.
  final TextWidthBasis? textWidthBasis;

  /// Factor by which the LaTeX font size is scaled relative to the overall text font size.
  final double latexSizeFactor;

  /// Parsing mode for LaTeX content.
  final ParsingMode latexParsing;

  /// Locale used to adapt number formatting within LaTeX content.
  ///
  /// Setting this modifies how numbers are displayed, matching local conventions, such as
  /// using commas as decimal separators in many European languages.
  final String? latexLocale;


  @override
  Widget build(BuildContext context) {

    // spanItems
    List<_SpanItem> items = _parseText(text);

    String? simpleText;
    List<InlineSpan> spans = [];

    if (items.isEmpty || (items.length == 1 && items.first.type.isRegular)) {
      simpleText = items.firstOrNull?.text ?? '';
    } else {
      spans = _buildTextSpans(items);
    }

    TextScaler textScaler = textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : MediaQuery.of(context).textScaler;
    DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = !style.inherit ? style : defaultTextStyle.style.merge(style);
    SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);

    Widget result = RichText(
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow: overflow ?? style.overflow ?? defaultTextStyle.overflow,
      textScaler: textScaler,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: defaultTextStyle.textHeightBehavior ?? DefaultTextHeightBehavior.maybeOf(context),
      selectionRegistrar: registrar,
      selectionColor: DefaultSelectionStyle.of(context).selectionColor ?? DefaultSelectionStyle.defaultColor,
      text: TextSpan(
        style: effectiveTextStyle,
        text: simpleText,
        children: spans,
      ),
    );

    if (registrar != null) {
      result = MouseRegion(
        cursor: DefaultSelectionStyle.of(context).mouseCursor ?? SystemMouseCursors.text,
        child: result,
      );
    }

    return result;
  }

  List<InlineSpan> _buildTextSpans(List<_SpanItem> items) {
    List<InlineSpan> spans = [];
    for (var i = 0; i < items.length; i++) {
      _SpanItem item = items[i];
      switch (item.type) {
        case _SpanType.regular:
          spans.add(TextSpan(text: item.text));
          break;

        case _SpanType.bold:
          spans.add(TextSpan(text: item.text, style: TextStyle(fontWeight: boldWeight)));
          break;

        case _SpanType.italic:
          spans.add(TextSpan(text: item.text, style: TextStyle(fontStyle: FontStyle.italic)));
          break;

        case _SpanType.code:
          spans.add(TextSpan(text: '\u202F${item.text}\u202F', style: TextStyle(backgroundColor: codeBackgroundColor)));
          break;

        case _SpanType.latex:
          spans.add(LatexSpan(
            text: item.text,
            style: style.copyWith(fontSize: (style.fontSize ?? defaultFontSize) * latexSizeFactor),
            parsing: latexParsing,
            locale: latexLocale,
          ));
          break;
      }
    }

    return spans;
  }


  static List<_SpanItem> _parseText(String text) {
    if (text.isEmpty) return [];

    String regExpStr = r'(\*\*)(.*?)(\*\*)|(\*)(.*?)(\*)|```(.*?)```|`([^`]*)`|(\\\()(.*?)(\\\))';

    List<_SpanItem> items = [];

    Iterable<RegExpMatch> matches = RegExp(regExpStr).allMatches(text);
    if (matches.isNotEmpty) {
      int lastEnd = 0;
      for (var match in matches) {

        if (match.start > lastEnd) {
          items.add(_SpanItem(text.substringSafe(lastEnd, match.start), _SpanType.regular));
        }

        if (match.group(1) != null && match.group(2)!.isNotEmpty) {
          items.add(_SpanItem(match.group(2)!, _SpanType.bold));
        } else if (match.group(4) != null && match.group(5)!.isNotEmpty) {
          items.add(_SpanItem(match.group(5)!, _SpanType.italic));
        } else if (match.group(7) != null) {
          items.add(_SpanItem(match.group(7)!.trim(), _SpanType.code));
        } else if (match.group(8) != null) {
          items.add(_SpanItem(match.group(8)!.trim(), _SpanType.code));
        } else if (match.group(9) != null && match.group(10)!.isNotEmpty) {
          items.add(_SpanItem(match.group(10)!, _SpanType.latex));
        }

        lastEnd = match.end;
      }

      if (matches.last.end < text.length) {
        items.add(_SpanItem(text.substringSafe(matches.last.end), _SpanType.regular));
      }

    } else {
      items.add(_SpanItem(text, _SpanType.regular));
    }

    return items;
  }

}