import '../enums.dart';
import '../font/__export.dart';
import '../nodes/__export.dart';
import '../util/__export.dart';
import 'exceptions.dart';
import 'parser_syntax.dart';
import 'tokens.dart';

/// A class for parsing LaTeX expressions into a structured format that can be rendered.
class LatexParser {
  /// Stores the current error handling mode for the parser.
  late ParsingMode _errorHandlingMode;

  /// Attempts to parse a LaTeX expression without throwing errors for unsuccessful parsing attempts.
  ///
  /// This method tries to parse the provided LaTeX expression [expr] and returns the parsed
  /// structure if successful; otherwise, it returns null. It is useful in scenarios where
  /// failure to parse should not interrupt the flow of the application.
  ///
  /// Parameters:
  ///   - [expr]: The LaTeX expression to parse.
  ///   - [parsing]: The parsing mode to use which determines how errors are handled.
  ///   - [allPointsAsDecimalPoints]: Whether all decimal points should be considered as such,
  ///     adapting to locale-specific decimal separators if needed.
  ///
  /// Returns:
  ///   An [EntryNode] representing the parsed LaTeX structure, or null if parsing fails.
  EntryNode? tryParse(
    String expr, {
    ParsingMode parsing = ParsingMode.minorErrorsAsRedPlaceholders,
    bool allPointsAsDecimalPoints = false,
  }) {
    try {
      return parse(
        expr,
        allPointsAsDecimalPoints: allPointsAsDecimalPoints,
        parsing: parsing,
      );
    } catch (e) {
      return null;
    }
  }

  /// Parses a LaTeX expression into a structured format.
  ///
  /// This method takes a LaTeX expression [expr] and parses it into an [EntryNode],
  /// which can be used for rendering. It throws errors when parsing fails, according to the
  /// specified [parsing] mode.
  ///
  /// Parameters:
  ///   - [expr]: The LaTeX expression to parse.
  ///   - [parsing]: The parsing mode to use which determines how errors are handled.
  ///   - [allPointsAsDecimalPoints]: Whether all decimal points should be considered as such,
  ///     adapting to locale-specific decimal separators if needed.
  ///
  /// Returns:
  ///   An [EntryNode] representing the parsed LaTeX structure.
  EntryNode parse(
    String expr, {
    ParsingMode parsing = ParsingMode.minorErrorsAsRedPlaceholders,
    bool allPointsAsDecimalPoints = false,
  }) {
    _errorHandlingMode = parsing;

    // clean initial expr
    expr = _cleanInitialExpr(expr);

    // build initial terms list
    List<dynamic> nodesAndTokens =
        _parseInitialNodesAndTokens(expr, allPointsAsDecimalPoints);

    // fixed-size brackets
    _replaceSizedBrackets(nodesAndTokens);

    // condense all bracket terms
    _groupBracketTerms(nodesAndTokens);

    // newlines
    List<LatexRenderNode> lines = [];
    List<dynamic> tmp = [];
    for (var node in nodesAndTokens) {
      if (node is NewlineNode) {
        if (tmp.isNotEmpty) {
          lines.add(_groupNodes(tmp, BracketType.none)); // group terms
        }
        tmp.clear();
      } else {
        tmp.add(node);
      }
    }
    if (tmp.isNotEmpty || lines.isEmpty) {
      lines.add(_groupNodes(tmp, BracketType.none)); // group terms
    }

    return EntryNode(lines: lines, sourceText: expr);
  }

  String _cleanInitialExpr(String expr) {
    return expr
        .replaceAll(r'\left\{', r'\left{')
        .replaceAll(r'\right\}', r'\right}')
        .replaceAll(r'\left\lVert', r'\leftVert')
        .replaceAll(r'\right\rVert', r'\rightVert')
        .replaceAll(r'\left\Vert', r'\leftVert')
        .replaceAll(r'\right\Vert', r'\rightVert')
        .replaceAll(r'\left\vert', r'\left|')
        .replaceAll(r'\right\vert', r'\right|')
        .replaceAll(r'\left\langle', r'\leftAngle')
        .replaceAll(r'\right\rangle', r'\rightAngle')
        .replaceAll(r'\left\lfloor', r'\leftFloor')
        .replaceAll(r'\right\rfloor', r'\rightFloor')
        .replaceAll(r'\left\lceil', r'\leftCeil')
        .replaceAll(r'\right\rceil', r'\rightCeil')
        .replaceAll(r'\begin{matrix}', r'\matrix{')
        .replaceAll(r'\end{matrix}', r'}')
        .replaceAll(r'\begin{bmatrix}', r'\bmatrix{')
        .replaceAll(r'\end{bmatrix}', r'}')
        .replaceAll(r'\begin{Bmatrix}', r'\Bmatrix{')
        .replaceAll(r'\end{Bmatrix}', r'}')
        .replaceAll(r'\begin{vmatrix}', r'\vmatrix{')
        .replaceAll(r'\end{vmatrix}', r'}')
        .replaceAll(r'\begin{Vmatrix}', r'\Vmatrix{')
        .replaceAll(r'\end{Vmatrix}', r'}')
        .replaceAll(r'\begin{pmatrix}', r'\pmatrix{')
        .replaceAll(r'\end{pmatrix}', r'}')
        .replaceAll(r'\begin{smallmatrix}', r'\smallmatrix{')
        .replaceAll(r'\end{smallmatrix}', r'}')
        .replaceAll(r'\begin{cases}', r'\cases{')
        .replaceAll(r'\end{cases}', r'}');
  }

  void _replaceSizedBrackets(List<dynamic> nodesAndTokens) {
    for (var i = 0; i < nodesAndTokens.length; i++) {
      dynamic token = nodesAndTokens[i];
      if (token is! SizedBracketToken) continue;

      dynamic delimiter =
          i + 1 < nodesAndTokens.length ? nodesAndTokens[i + 1] : null;
      BracketType? bracketType = _getBracketType(delimiter);
      if (bracketType == null) {
        if (_errorHandlingMode == ParsingMode.strict) {
          throw (ArgumentsException(
              'Delimiter missing after fixed-size bracket command'));
        }
        nodesAndTokens[i] = ErrorNode(
          errorVisualization:
              ErrorVisualization.fromParsing(_errorHandlingMode),
          msg: 'delimiter missing',
        );
        continue;
      }

      nodesAndTokens[i] = BracketNode(
        bracketType,
        token.bracketOrientation,
        heightScale: token.heightScale,
      );
      nodesAndTokens.removeAt(i + 1);
    }
  }

  BracketType? _getBracketType(dynamic delimiter) {
    if (delimiter is BracketNode) return delimiter.bracketType;
    if (delimiter is NormNode) return BracketType.vertical;

    if (delimiter is BracketToken) {
      switch (delimiter.type) {
        case BracketTokenType.leftRound:
        case BracketTokenType.rightRound:
          return BracketType.round;
        case BracketTokenType.leftCurly:
        case BracketTokenType.rightCurly:
          return BracketType.curly;
        case BracketTokenType.leftSquare:
        case BracketTokenType.rightSquare:
          return BracketType.square;
        case BracketTokenType.leftVertical:
        case BracketTokenType.rightVertical:
          return BracketType.vertical;
        case BracketTokenType.leftDoubleVertical:
        case BracketTokenType.rightDoubleVertical:
          return BracketType.doubleVertical;
        case BracketTokenType.leftAngle:
        case BracketTokenType.rightAngle:
          return BracketType.angle;
        case BracketTokenType.leftFloor:
        case BracketTokenType.rightFloor:
          return BracketType.floor;
        case BracketTokenType.leftCeil:
        case BracketTokenType.rightCeil:
          return BracketType.ceil;
        case BracketTokenType.doubleLeftSquare:
        case BracketTokenType.doubleRightSquare:
          return BracketType.doubleSquare;
      }
    }

    if (delimiter is TextNode) {
      switch (delimiter.text) {
        case '\u2223':
          return BracketType.vertical;
        case '\u2225':
          return BracketType.doubleVertical;
        case '\u27e8':
        case '\u27e9':
          return BracketType.angle;
        case '\u230a':
        case '\u230b':
          return BracketType.floor;
        case '\u2308':
        case '\u2309':
          return BracketType.ceil;
      }
    }

    return null;
  }

  /// Returns a list of terms (numbers, variables) and tokens (brackets, operators, functions, constants).
  List<dynamic> _parseInitialNodesAndTokens(
      String expr, bool allPointsAsDecimalPoints) {
    final List<dynamic> nodesAndTokens = [];

    for (var i = 0; i < expr.length; i++) {
      if (expr[i] == ' ' && !_isText(nodesAndTokens)) {
        // skip spaces
        continue;
      } else if (SyntaxParser.isSingleCharacterElement(expr[i])) {
        // find single-char latex symbols
        nodesAndTokens.add(SyntaxParser.parseSingleCharacterElement(expr[i]));

        // if (expr[i] == ',' && i+1 < expr.length && i > 0 && double.tryParse(expr[i-1]) != null && double.tryParse(expr[i+1]) != null) {
        // 	throw MitexParserException('Do not use a comma as decimal separator.');
        // }
      } else if (double.tryParse(expr[i]) != null) {
        // find numbers
        int j = i;
        while (double.tryParse(expr.substringSafe(i, j + 1)) != null) {
          j++;
          if (j >= expr.length) break;
        }

        if (j > i) {
          nodesAndTokens.add(NumberNode(expr.substringSafe(i, j).trim()));
          i = j - 1;
        }
      } else if (allPointsAsDecimalPoints && expr[i] == '.') {
        // lonely decimal points
        nodesAndTokens.add(DecimalPointNode());
      } else if (expr[i] == r'\' && i < expr.lastIndex) {
        // find latex keywords
        int j = i + 2;

        // check for single-char keywords first, e.g. \,
        String subStr = expr.substringSafe(i + 1, j);
        if (SyntaxParser.isSingleCharLatexCommand(subStr)) {
          nodesAndTokens.add(SyntaxParser.parseLatexCommand(subStr));
          i++;
          continue;
        }

        // search for multi-char keywords
        while (j < expr.length &&
            (!SyntaxParser.isSingleCharacterElement(expr[j]) ||
                subStr == 'left' ||
                subStr == 'right' ||
                subStr == 'big' ||
                subStr == 'Big' ||
                subStr == 'bigg' ||
                subStr == 'Bigg') &&
            expr[j] != r'\' &&
            expr[j] != ' ' &&
            expr[j] != '.' &&
            subStr != 'left(' &&
            subStr != 'right)' &&
            subStr != r'left{' &&
            subStr != r'right}' &&
            subStr != 'left[' &&
            subStr != 'right]' &&
            subStr != 'left|' &&
            subStr != 'right|' &&
            subStr != 'big|' &&
            subStr != 'Big|' &&
            subStr != 'bigg|' &&
            subStr != 'Bigg|' &&
            double.tryParse(expr[j]) == null) {
          j++;
          subStr = expr.substringSafe(i + 1, j);
        }

        if (SyntaxParser.isLatexCommand(subStr)) {
          nodesAndTokens.add(SyntaxParser.parseLatexCommand(subStr));
        } else {
          if (_errorHandlingMode == ParsingMode.strict) {
            throw (UnknownCommandException('\\$subStr not supported'));
          }
          nodesAndTokens.add(ErrorNode(
              errorVisualization:
                  ErrorVisualization.fromParsing(_errorHandlingMode),
              msg: '\\$subStr'));
        }
        i = j - 1;
      } else if (expr[i] == '\'') {
        // find derivatives

        int j = 0;
        do {
          j++;
          if (i + j >= expr.length || j >= 4) break;
        } while (expr[i + j] == '\'');

        if (j == 1) {
          nodesAndTokens.add(TextNode('\u2032'));
        } else if (j == 2) {
          nodesAndTokens.add(TextNode('\u2033'));
        } else if (j == 3) {
          nodesAndTokens.add(TextNode('\u2034'));
        } else if (j == 4) {
          nodesAndTokens.add(TextNode('\u2057'));
        }

        i += j - 1;
      } else {
        // find variables
        int j = i;
        bool isText = _isText(nodesAndTokens);
        while (!(SyntaxParser.isSingleCharacterElement(expr[j]) ||
            expr[j] == r'\' ||
            expr[j] == ' ' && !isText ||
            expr[j] == '\'' ||
            double.tryParse(expr[j]) != null)) {
          j++;
          if (j >= expr.length) break;
        }

        if (j > i) {
          nodesAndTokens.add(
              TextNode(expr.substringSafe(i, j), font: MainItalicLatexFont()));
          i = j - 1;
        }
      }
    }

    return nodesAndTokens;
  }

  bool _isText(List<dynamic> nodesAndTokens) {
    return nodesAndTokens.length >= 2 &&
        nodesAndTokens.secondToLast is FunctionalToken &&
        (nodesAndTokens.secondToLast as FunctionalToken).type ==
            FunctionType.font &&
        nodesAndTokens.last is BracketToken &&
        (nodesAndTokens.last as BracketToken).type ==
            BracketTokenType.leftCurly;
  }

  /// Groups all bracket terms.
  void _groupBracketTerms(List<dynamic> nodesAndTokens) {
    while (true) {
      int startIndexCurlyBracket = -1;
      int startIndexSquareBracket = -1;
      int startIndexVerticalBracket = -1;
      int startIndexDoubleVerticalBracket = -1;
      int startIndexAngleBracket = -1;
      int startIndexFloorBracket = -1;
      int startIndexCeilBracket = -1;
      bool showGroupCurlyBrackets = false;
      int startIndexRoundBracket = -1;
      int endIndexCurlyBracket = -1;
      int endIndexSquareBracket = -1;
      int endIndexVerticalBracket = -1;
      int endIndexDoubleVerticalBracket = -1;
      int endIndexAngleBracket = -1;
      int endIndexFloorBracket = -1;
      int endIndexCeilBracket = -1;
      int endIndexRoundBracket = -1;

      loop:
      for (var i = 0; i < nodesAndTokens.length; i++) {
        dynamic token = nodesAndTokens[i];
        if (token is! BracketToken) continue;

        switch (token.type) {
          case BracketTokenType.leftCurly:
            startIndexCurlyBracket = i;
            showGroupCurlyBrackets = token.showGroupCurlyBrackets;
            break;

          case BracketTokenType.rightCurly:
            endIndexCurlyBracket = i;
            if (startIndexCurlyBracket >= 0) {
              showGroupCurlyBrackets &= token.showGroupCurlyBrackets;
              break loop;
            }
            break;

          case BracketTokenType.leftSquare:
            startIndexSquareBracket = i;
            break;

          case BracketTokenType.rightSquare:
            endIndexSquareBracket = i;
            if (startIndexSquareBracket >= 0) break loop;
            break;

          case BracketTokenType.leftVertical:
            startIndexVerticalBracket = i;
            break;

          case BracketTokenType.rightVertical:
            endIndexVerticalBracket = i;
            if (startIndexVerticalBracket >= 0) break loop;
            break;

          case BracketTokenType.leftDoubleVertical:
            startIndexDoubleVerticalBracket = i;
            break;

          case BracketTokenType.rightDoubleVertical:
            endIndexDoubleVerticalBracket = i;
            if (startIndexDoubleVerticalBracket >= 0) break loop;
            break;

          case BracketTokenType.leftAngle:
            startIndexAngleBracket = i;
            break;

          case BracketTokenType.rightAngle:
            endIndexAngleBracket = i;
            if (startIndexAngleBracket >= 0) break loop;
            break;

          case BracketTokenType.leftFloor:
            startIndexFloorBracket = i;
            break;

          case BracketTokenType.rightFloor:
            endIndexFloorBracket = i;
            if (startIndexFloorBracket >= 0) break loop;
            break;

          case BracketTokenType.leftCeil:
            startIndexCeilBracket = i;
            break;

          case BracketTokenType.rightCeil:
            endIndexCeilBracket = i;
            if (startIndexCeilBracket >= 0) break loop;
            break;

          case BracketTokenType.leftRound:
            startIndexRoundBracket = i;
            break;

          case BracketTokenType.rightRound:
            endIndexRoundBracket = i;
            if (startIndexRoundBracket >= 0) break loop;
            break;

          default:
            break;
        }
      }

      // found curly bracket term and condense it
      if (startIndexCurlyBracket >= 0 &&
          endIndexCurlyBracket >= startIndexCurlyBracket) {
        nodesAndTokens[startIndexCurlyBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexCurlyBracket + 1, endIndexCurlyBracket),
          showGroupCurlyBrackets ? BracketType.curly : BracketType.none,
        );
        nodesAndTokens.removeRange(
            startIndexCurlyBracket + 1, endIndexCurlyBracket + 1);

        // found square bracket term and condense it
      } else if (startIndexSquareBracket >= 0 &&
          endIndexSquareBracket >= startIndexSquareBracket) {
        nodesAndTokens[startIndexSquareBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexSquareBracket + 1, endIndexSquareBracket),
          BracketType.square,
        );
        nodesAndTokens.removeRange(
            startIndexSquareBracket + 1, endIndexSquareBracket + 1);

        // found vertical bracket term and condense it
      } else if (startIndexVerticalBracket >= 0 &&
          endIndexVerticalBracket >= startIndexVerticalBracket) {
        nodesAndTokens[startIndexVerticalBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexVerticalBracket + 1, endIndexVerticalBracket),
          BracketType.vertical,
        );
        nodesAndTokens.removeRange(
            startIndexVerticalBracket + 1, endIndexVerticalBracket + 1);

        // found double vertical bracket term and condense it
      } else if (startIndexDoubleVerticalBracket >= 0 &&
          endIndexDoubleVerticalBracket >= startIndexDoubleVerticalBracket) {
        nodesAndTokens[startIndexDoubleVerticalBracket] = _groupNodes(
          nodesAndTokens.sublist(startIndexDoubleVerticalBracket + 1,
              endIndexDoubleVerticalBracket),
          BracketType.doubleVertical,
        );
        nodesAndTokens.removeRange(startIndexDoubleVerticalBracket + 1,
            endIndexDoubleVerticalBracket + 1);

        // found angle bracket term and condense it
      } else if (startIndexAngleBracket >= 0 &&
          endIndexAngleBracket >= startIndexAngleBracket) {
        nodesAndTokens[startIndexAngleBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexAngleBracket + 1, endIndexAngleBracket),
          BracketType.angle,
        );
        nodesAndTokens.removeRange(
            startIndexAngleBracket + 1, endIndexAngleBracket + 1);

        // found floor bracket term and condense it
      } else if (startIndexFloorBracket >= 0 &&
          endIndexFloorBracket >= startIndexFloorBracket) {
        nodesAndTokens[startIndexFloorBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexFloorBracket + 1, endIndexFloorBracket),
          BracketType.floor,
        );
        nodesAndTokens.removeRange(
            startIndexFloorBracket + 1, endIndexFloorBracket + 1);

        // found ceil bracket term and condense it
      } else if (startIndexCeilBracket >= 0 &&
          endIndexCeilBracket >= startIndexCeilBracket) {
        nodesAndTokens[startIndexCeilBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexCeilBracket + 1, endIndexCeilBracket),
          BracketType.ceil,
        );
        nodesAndTokens.removeRange(
            startIndexCeilBracket + 1, endIndexCeilBracket + 1);

        // found round bracket term and condense it
      } else if (startIndexRoundBracket >= 0 &&
          endIndexRoundBracket >= startIndexRoundBracket) {
        nodesAndTokens[startIndexRoundBracket] = _groupNodes(
          nodesAndTokens.sublist(
              startIndexRoundBracket + 1, endIndexRoundBracket),
          BracketType.round,
        );
        nodesAndTokens.removeRange(
            startIndexRoundBracket + 1, endIndexRoundBracket + 1);

        // found no bracket terms -> leave while-loop
      } else {
        break;
      }
    }
  }

  GroupNode _groupNodes(List<dynamic> nodesAndTokens, BracketType bracketType) {
    // brackets
    _replaceSingleBrackets(nodesAndTokens);

    // functions
    _parseFunctions(nodesAndTokens);

    // sanity check
    List<LatexRenderNode> nodes = [];
    for (var node in nodesAndTokens) {
      if (node is! LatexRenderNode) {
        throw GroupingException('${node.toString()} is not a node.');
      }
      nodes.add(node);
    }

    // colors
    _addColorsToGroups(nodes);

    // math styles
    _addMathStylesToGroups(nodes);

    return GroupNode(nodes, bracketType);
  }

  void _replaceSingleBrackets(List<dynamic> nodesAndTokens) {
    for (var i = 0; i < nodesAndTokens.length; i++) {
      dynamic token = nodesAndTokens[i];
      if (token is! BracketToken) continue;

      switch ((nodesAndTokens[i] as BracketToken).type) {
        case BracketTokenType.leftRound:
          nodesAndTokens[i] =
              BracketNode(BracketType.round, BracketOrientation.left);
          break;
        case BracketTokenType.rightRound:
          nodesAndTokens[i] =
              BracketNode(BracketType.round, BracketOrientation.right);
          break;
        case BracketTokenType.leftSquare:
          nodesAndTokens[i] =
              BracketNode(BracketType.square, BracketOrientation.left);
          break;
        case BracketTokenType.rightSquare:
          nodesAndTokens[i] =
              BracketNode(BracketType.square, BracketOrientation.right);
          break;
        case BracketTokenType.doubleLeftSquare:
          nodesAndTokens[i] =
              BracketNode(BracketType.doubleSquare, BracketOrientation.left);
          break;
        case BracketTokenType.doubleRightSquare:
          nodesAndTokens[i] =
              BracketNode(BracketType.doubleSquare, BracketOrientation.right);
          break;
        case BracketTokenType.leftVertical:
          nodesAndTokens[i] =
              BracketNode(BracketType.vertical, BracketOrientation.left);
          break;
        case BracketTokenType.rightVertical:
          nodesAndTokens[i] =
              BracketNode(BracketType.vertical, BracketOrientation.right);
          break;
        case BracketTokenType.leftDoubleVertical:
          nodesAndTokens[i] =
              BracketNode(BracketType.doubleVertical, BracketOrientation.left);
          break;
        case BracketTokenType.rightDoubleVertical:
          nodesAndTokens[i] =
              BracketNode(BracketType.doubleVertical, BracketOrientation.right);
          break;
        case BracketTokenType.leftAngle:
          nodesAndTokens[i] =
              BracketNode(BracketType.angle, BracketOrientation.left);
          break;
        case BracketTokenType.rightAngle:
          nodesAndTokens[i] =
              BracketNode(BracketType.angle, BracketOrientation.right);
          break;
        case BracketTokenType.leftFloor:
          nodesAndTokens[i] =
              BracketNode(BracketType.floor, BracketOrientation.left);
          break;
        case BracketTokenType.rightFloor:
          nodesAndTokens[i] =
              BracketNode(BracketType.floor, BracketOrientation.right);
          break;
        case BracketTokenType.leftCeil:
          nodesAndTokens[i] =
              BracketNode(BracketType.ceil, BracketOrientation.left);
          break;
        case BracketTokenType.rightCeil:
          nodesAndTokens[i] =
              BracketNode(BracketType.ceil, BracketOrientation.right);
          break;

        default:
          break;
      }
    }
  }

  void _parseFunctions(List<dynamic> nodesAndTokens, {int? start, int? end}) {
    for (var i = start ?? 0; i < (end ?? nodesAndTokens.length); i++) {
      dynamic token = nodesAndTokens[i];
      if (token is! FunctionalToken) continue;

      switch (token.type) {
        case FunctionType.topDecoration:
          _parseFunction1(nodesAndTokens, i, token.cmd,
              (n) => TopDecorationNode(n, token.topDecoration!));
          break;

        case FunctionType.bottomDecoration:
          _parseFunction1(nodesAndTokens, i, token.cmd,
              (n) => BottomDecorationNode(n, token.bottomDecoration!));
          break;

        case FunctionType.font:
          _parseFunction1(
              nodesAndTokens,
              i,
              token.cmd,
              (n) =>
                  FontNode(n, font: token.font, isBold: token.isBold ?? false));
          break;

        case FunctionType.color:
          _parseFunction1(nodesAndTokens, i, token.cmd, (n) => ColorNode(n));
          break;

        case FunctionType.binom:
          _parseFunction2(nodesAndTokens, i, token.cmd,
              (n0, n1) => BinomNode(n0, n1, isTextStyle: token.isTextStyle));
          break;

        case FunctionType.boxed:
          _parseFunction1(nodesAndTokens, i, token.cmd, (n) => BoxedNode(n));
          break;

        case FunctionType.cases:
          _parseFunctionCases(nodesAndTokens, i, token.cmd);
          break;

        case FunctionType.frac:
          _parseFunction2(nodesAndTokens, i, token.cmd,
              (n0, n1) => FracNode(n0, n1, isTextStyle: token.isTextStyle));
          break;

        case FunctionType.extendedArrow:
          _parseFunction1(nodesAndTokens, i, token.cmd,
              (n) => ExtendedArrowNode(n, token.extendedArrowDirection!));
          break;

        case FunctionType.limProdSum:
          _parseFunctionLimProdSum(nodesAndTokens, i, token.limProdSumType!);
          break;

        case FunctionType.limitPlacement:
          bool removed = _parseFunctionLimitPlacement(
              nodesAndTokens, i, token.limitsPlacement!);
          if (removed) i--;
          break;

        case FunctionType.mathStyle:
          nodesAndTokens[i] = MathStyleDeclarationNode(token.mathStyle!);
          break;

        case FunctionType.matrix:
          _parseFunctionMatrix(nodesAndTokens, i, token.cmd, token.bracketType!,
              isSmallMatrix: token.isSmallMatrix);
          break;

        case FunctionType.nocursor:
          _parseFunction1(nodesAndTokens, i, token.cmd, (n) => NoCursorNode(n));
          break;

        case FunctionType.pmod:
          _parseFunction1(
              nodesAndTokens,
              i,
              token.cmd,
              (n) => GroupNode([
                    TextNode('mod',
                        textType: TextType.lowerCase, spacingRequired: true),
                    n,
                  ], BracketType.round));
          break;

        case FunctionType.substack:
          _parseFunctionSubstack(nodesAndTokens, i, token.cmd);
          break;

        case FunctionType.subscript:
          bool shiftIndexToLeft =
              _parseFunctionSubSuper(nodesAndTokens, i, false);
          if (shiftIndexToLeft) i--;
          break;

        case FunctionType.superscript:
          bool shiftIndexToLeft =
              _parseFunctionSubSuper(nodesAndTokens, i, true);
          if (shiftIndexToLeft) i--;
          break;

        case FunctionType.sqrt:
          _parseFunction2FirstOptional(nodesAndTokens, i, '\\sqrt',
              (n, optional) => SqrtNode(n, exponent: optional));
          break;

        case FunctionType.overset:
          _parseFunction2(
              nodesAndTokens,
              i,
              token.cmd,
              (n0, n1) => StackNode(
                    annotation: n0,
                    child: n1,
                    position: StackPosition.over,
                  ));
          break;

        case FunctionType.underset:
          _parseFunction2(
              nodesAndTokens,
              i,
              token.cmd,
              (n0, n1) => StackNode(
                    annotation: n0,
                    child: n1,
                    position: StackPosition.under,
                  ));
          break;

        case FunctionType.stackrel:
          _parseFunction2(
              nodesAndTokens,
              i,
              token.cmd,
              (n0, n1) => StackNode(
                    annotation: n0,
                    child: n1,
                    position: StackPosition.over,
                    isRelation: true,
                  ));
          break;
      }
    }
  }

  void _parseFunction1(List<dynamic> nodesAndTokens, int index, String name,
      LatexRenderNode Function(LatexRenderNode node) createNode) {
    if (index + 1 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is LatexRenderNode) {
      try {
        nodesAndTokens[index] = createNode(nodesAndTokens[index + 1]);
      } catch (e) {
        if (_errorHandlingMode == ParsingMode.strict) rethrow;
        nodesAndTokens[index] = ErrorNode(
          errorVisualization:
              ErrorVisualization.fromParsing(_errorHandlingMode),
          msg: e.toString(),
        );
      }
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name);
    }

    nodesAndTokens.removeRange(index + 1, index + 2);
  }

  void _parseFunction2(
      List<dynamic> nodesAndTokens,
      int index,
      String name,
      LatexRenderNode Function(LatexRenderNode n1, LatexRenderNode n2)
          createNode) {
    if (index + 2 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is LatexRenderNode &&
        nodesAndTokens[index + 2] is LatexRenderNode) {
      nodesAndTokens[index] =
          createNode(nodesAndTokens[index + 1], nodesAndTokens[index + 2]);
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name,
          'arg1: $nodesAndTokens, arg2: ${index + 2 > nodesAndTokens.lastIndex ? null : nodesAndTokens[index + 2]}');
    }

    nodesAndTokens.removeRange(index + 1, index + 3);
  }

  void _parseFunction2FirstOptional(
      List<dynamic> nodesAndTokens,
      int index,
      String name,
      LatexRenderNode Function(LatexRenderNode n, LatexRenderNode? optional)
          createNode) {
    if (index + 1 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is LatexRenderNode) {
      if (index + 2 < nodesAndTokens.length &&
          (nodesAndTokens[index + 2] is LatexRenderNode) &&
          (nodesAndTokens[index + 1] is GroupNode) &&
          (nodesAndTokens[index + 1] as GroupNode).bracketType ==
              BracketType.square) {
        // set bracket type of optional to None
        (nodesAndTokens[index + 1] as GroupNode).bracketType = BracketType.none;

        nodesAndTokens[index] =
            createNode(nodesAndTokens[index + 2], nodesAndTokens[index + 1]);
        nodesAndTokens.removeRange(index + 1, index + 3);
      } else {
        nodesAndTokens[index] = createNode(nodesAndTokens[index + 1], null);
        nodesAndTokens.removeRange(index + 1, index + 2);
      }
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name);
      nodesAndTokens.removeRange(index + 1, index + 2);
    }
  }

  void _parseFunctionCases(
      List<dynamic> nodesAndTokens, int index, String name) {
    if (index + 1 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is GroupNode) {
      nodesAndTokens[index] = CasesNode.fromGroup(nodesAndTokens[index + 1]);
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name);
    }

    nodesAndTokens.removeRange(index + 1, index + 2);
  }

  void _parseFunctionSubstack(
      List<dynamic> nodesAndTokens, int index, String name) {
    if (index + 1 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is GroupNode) {
      nodesAndTokens[index] = SubstackNode.fromGroup(nodesAndTokens[index + 1]);
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name);
    }

    nodesAndTokens.removeRange(index + 1, index + 2);
  }

  void _parseFunctionMatrix(List<dynamic> nodesAndTokens, int index,
      String name, BracketType bracketType,
      {bool isSmallMatrix = false}) {
    if (index + 1 <= nodesAndTokens.lastIndex &&
        nodesAndTokens[index + 1] is GroupNode) {
      nodesAndTokens[index] = MatrixNode.fromGroup(nodesAndTokens[index + 1],
          bracketType: bracketType, isSmall: isSmallMatrix);
    } else {
      nodesAndTokens[index] = _createArgsErrorNode(name);
    }

    nodesAndTokens.removeRange(index + 1, index + 2);
  }

  void _parseFunctionLimProdSum(
      List<dynamic> nodesAndTokens, int index, LimProdSumType type) {
    int modifierCount = 0;
    OperatorLimitsPlacement limitsPlacement = OperatorLimitsPlacement.automatic;
    dynamic modifier =
        index + 1 < nodesAndTokens.length ? nodesAndTokens[index + 1] : null;
    if (modifier is FunctionalToken &&
        modifier.type == FunctionType.limitPlacement) {
      limitsPlacement = modifier.limitsPlacement!;
      modifierCount = 1;
    }

    dynamic token1 = index + 1 + modifierCount < nodesAndTokens.length
        ? nodesAndTokens[index + 1 + modifierCount]
        : null;
    dynamic token2 = index + 2 + modifierCount < nodesAndTokens.length
        ? nodesAndTokens[index + 2 + modifierCount]
        : null;
    dynamic token3 = index + 3 + modifierCount < nodesAndTokens.length
        ? nodesAndTokens[index + 3 + modifierCount]
        : null;
    dynamic token4 = index + 4 + modifierCount < nodesAndTokens.length
        ? nodesAndTokens[index + 4 + modifierCount]
        : null;

    if (token1 is FunctionalToken &&
        (token1.type == FunctionType.subscript ||
            token1.type == FunctionType.superscript) &&
        token2 is LatexRenderNode) {
      bool firstIsSuper = token1.type == FunctionType.superscript;

      // \lim_a^b or \lim^a_b
      if (token3 is FunctionalToken &&
          ((firstIsSuper && token3.type == FunctionType.subscript) ||
              token3.type == FunctionType.superscript) &&
          token4 is LatexRenderNode) {
        nodesAndTokens[index] = LimProdSumNode(
          type: type,
          superscript: firstIsSuper ? token2 : token4,
          subscript: firstIsSuper ? token4 : token2,
          limitsPlacement: limitsPlacement,
        );
        nodesAndTokens.removeRange(index + 1, index + 5 + modifierCount);

        // \lim_a or \lim^a
      } else {
        nodesAndTokens[index] = LimProdSumNode(
          type: type,
          superscript: firstIsSuper ? token2 : null,
          subscript: firstIsSuper ? null : token2,
          limitsPlacement: limitsPlacement,
        );
        nodesAndTokens.removeRange(index + 1, index + 3 + modifierCount);
      }

      // \lim
    } else {
      nodesAndTokens[index] =
          LimProdSumNode(type: type, limitsPlacement: limitsPlacement);
      if (modifierCount == 1) {
        nodesAndTokens.removeAt(index + 1);
      }
    }
  }

  bool _parseFunctionLimitPlacement(List<dynamic> nodesAndTokens, int index,
      OperatorLimitsPlacement limitsPlacement) {
    dynamic parent = index > 0 ? nodesAndTokens[index - 1] : null;
    if (parent is IntNode) {
      parent.limitsPlacement = limitsPlacement;
      nodesAndTokens.removeAt(index);
      return true;
    }

    nodesAndTokens[index] = ErrorNode(
      errorVisualization: ErrorVisualization.fromParsing(_errorHandlingMode),
      msg:
          '\\${limitsPlacement == OperatorLimitsPlacement.limits ? 'limits' : 'nolimits'}',
    );
    return false;
  }

  bool _parseFunctionSubSuper(
      List<dynamic> nodesAndTokens, int index, bool firstIsSuper) {
    dynamic token1 =
        index + 1 < nodesAndTokens.length ? nodesAndTokens[index + 1] : null;
    if (token1 is! LatexRenderNode) {
      _parseFunctions(nodesAndTokens, start: index + 1, end: index + 2);
      token1 =
          index + 1 < nodesAndTokens.length ? nodesAndTokens[index + 1] : null;
      if (token1 is! LatexRenderNode) {
        nodesAndTokens[index] = _createArgsErrorNode(firstIsSuper ? '^' : '_');
        nodesAndTokens.removeRange(index + 1, index + 2);
        return false;
      }
    }

    // handle a_b^c and a^b_c
    dynamic token2 =
        index + 2 < nodesAndTokens.length ? nodesAndTokens[index + 2] : null;
    dynamic token3 =
        index + 3 < nodesAndTokens.length ? nodesAndTokens[index + 3] : null;

    bool isToken2SubOrSup = token2 is FunctionalToken &&
        ((firstIsSuper && token2.type == FunctionType.subscript) ||
            (!firstIsSuper && token2.type == FunctionType.superscript));

    if (isToken2SubOrSup && token3 is! LatexRenderNode) {
      _parseFunctions(nodesAndTokens, start: index + 3, end: index + 4);
      token3 =
          index + 3 < nodesAndTokens.length ? nodesAndTokens[index + 3] : null;
    }

    dynamic parentToken = index - 1 >= 0 ? nodesAndTokens[index - 1] : null;

    LatexRenderNode? parent;
    int offset = 0;
    if (parentToken is LatexRenderNode &&
        (!parentToken.spacingRequired || parentToken is IntNode)) {
      parent = parentToken;
      offset = 1;
    }

    if (isToken2SubOrSup && token3 is LatexRenderNode) {
      nodesAndTokens[index - offset] = SupSubNode(
        parent,
        subscript: firstIsSuper ? token3 : token1,
        superscript: firstIsSuper ? token1 : token3,
      );
      nodesAndTokens.removeRange(index + 1 - offset, index + 4);
    } else {
      if (firstIsSuper) {
        nodesAndTokens[index - offset] =
            SupSubNode(parent, superscript: token1);
      } else {
        nodesAndTokens[index - offset] = SupSubNode(parent, subscript: token1);
      }
      nodesAndTokens.removeRange(index + 1 - offset, index + 2);
    }

    return parent != null;
  }

  ErrorNode _createArgsErrorNode(String functionName, [String msg = '']) {
    if (_errorHandlingMode == ParsingMode.strict) {
      throw (ArgumentsException(
          'Arguments missing for "$functionName" -- $msg'));
    }
    return ErrorNode(
      errorVisualization: ErrorVisualization.fromParsing(_errorHandlingMode),
      msg: 'args missing for $functionName',
    );
  }

  void _addColorsToGroups(List<LatexRenderNode> nodes) {
    if (!nodes.containsWhere((e) => e is ColorNode)) return;

    for (var i = 0; i < nodes.length; i++) {
      dynamic colorNode = nodes[i];
      if (colorNode is! ColorNode) continue;
      int end = i + 1;
      for (var j = i + 1; j < nodes.length; j++) {
        if (nodes[j] is ColorNode) break;
        end++;
      }
      if (end > i + 1) {
        nodes[i] = GroupNode(
            nodes.getRange(i + 1, end).toList(), BracketType.none,
            color: colorNode.color);
        nodes.removeRange(i + 1, end);
      } else {
        nodes.removeRange(i, i + 1);
        i--;
      }
    }
  }

  void _addMathStylesToGroups(List<LatexRenderNode> nodes) {
    for (var node in nodes) {
      if (node is GroupNode) {
        _addMathStylesToGroups(node.children);
      }
    }

    for (var i = 0; i < nodes.length; i++) {
      LatexRenderNode styleNode = nodes[i];
      if (styleNode is! MathStyleDeclarationNode) continue;

      int end = nodes.length;
      for (var j = i + 1; j < nodes.length; j++) {
        if (nodes[j] is MathStyleDeclarationNode) {
          end = j;
          break;
        }
      }

      if (end > i + 1) {
        nodes[i] = MathStyleNode(
          GroupNode(nodes.getRange(i + 1, end).toList(), BracketType.none),
          styleNode.mathStyle,
        );
        nodes.removeRange(i + 1, end);
      } else {
        nodes.removeAt(i);
        i--;
      }
    }
  }
}
