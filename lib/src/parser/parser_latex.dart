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
	EntryNode? tryParse(String expr, {
		ParsingMode parsing = ParsingMode.minorErrorsAsRedPlaceholders,
		bool allPointsAsDecimalPoints = false,
	}) {
		try {
			return parse(expr,
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
	EntryNode parse(String expr, {
		ParsingMode parsing = ParsingMode.minorErrorsAsRedPlaceholders,
		bool allPointsAsDecimalPoints = false,
	}) {
		_errorHandlingMode = parsing;

		// clean initial expr
		expr = _cleanInitialExpr(expr);

		// build initial terms list
		List<dynamic> nodesAndTokens = _parseInitialNodesAndTokens(expr, allPointsAsDecimalPoints);

		// condense all bracket terms
		_groupBracketTerms(nodesAndTokens);

		// newlines
		List<LatexRenderNode> lines = [];
		List<dynamic> tmp = [];
		for (var node in nodesAndTokens) {
			if (node is NewlineNode) {
				if (tmp.isNotEmpty) lines.add(_groupNodes(tmp, BracketType.none)); // group terms
				tmp.clear();
			} else {
				tmp.add(node);
			}
		}
		if (tmp.isNotEmpty || lines.isEmpty) lines.add(_groupNodes(tmp, BracketType.none)); // group terms

		return EntryNode(lines: lines, sourceText: expr);
	}

	String _cleanInitialExpr(String expr) {
		return expr
			.replaceAll(r'\left\{', r'\left{')
			.replaceAll(r'\right\}', r'\right}')
			.replaceAll(r'\begin{matrix}', r'\matrix{')
			.replaceAll(r'\end{matrix}', r'}')
			.replaceAll(r'\begin{bmatrix}', r'\bmatrix{')
			.replaceAll(r'\end{bmatrix}', r'}')
			.replaceAll(r'\begin{Bmatrix}', r'\Bmatrix{')
			.replaceAll(r'\end{Bmatrix}', r'}')
			.replaceAll(r'\begin{pmatrix}', r'\pmatrix{')
			.replaceAll(r'\end{pmatrix}', r'}')
			.replaceAll(r'\begin{cases}', r'\cases{')
			.replaceAll(r'\end{cases}', r'}');
	}

	/// Returns a list of terms (numbers, variables) and tokens (brackets, operators, functions, constants).
	List<dynamic> _parseInitialNodesAndTokens(String expr, bool allPointsAsDecimalPoints) {
		final List<dynamic> nodesAndTokens = [];
		
		for (var i = 0; i < expr.length; i++) {

			if (expr[i] == ' ' && !_isText(nodesAndTokens)) { // skip spaces
				continue;

			} else if (SyntaxParser.isSingleCharacterElement(expr[i])) { // find single-char latex symbols
				nodesAndTokens.add(SyntaxParser.parseSingleCharacterElement(expr[i]));

				// if (expr[i] == ',' && i+1 < expr.length && i > 0 && double.tryParse(expr[i-1]) != null && double.tryParse(expr[i+1]) != null) {
				// 	throw MitexParserException('Do not use a comma as decimal separator.');
				// }

			} else if (double.tryParse(expr[i]) != null) { // find numbers
				int j = i;
				while (double.tryParse(expr.substringSafe(i,j+1)) != null) {
					j++;
          if (j >= expr.length) break;
				}

				if (j > i) {
					nodesAndTokens.add(NumberNode(expr.substringSafe(i,j).trim()));
					i = j-1;
				}

			} else if (allPointsAsDecimalPoints && expr[i] == '.') { // lonely decimal points
				nodesAndTokens.add(DecimalPointNode());

			} else if (expr[i] == r'\' && i < expr.lastIndex) { // find latex keywords
				int j = i+2;

				// check for single-char keywords first, e.g. \,
				String subStr = expr.substringSafe(i+1, j);
				if (SyntaxParser.isSingleCharLatexCommand(subStr)) {
					nodesAndTokens.add(SyntaxParser.parseLatexCommand(subStr));
					i++;
					continue;
				}

				// search for multi-char keywords
				while (
					j < expr.length &&
					(
						!SyntaxParser.isSingleCharacterElement(expr[j]) ||
							subStr == 'left' || subStr == 'right' ||
							subStr == 'big' || subStr == 'Big' || subStr == 'bigg' || subStr == 'Bigg'
					) &&
					expr[j] != r'\' && expr[j] != ' ' &&
					subStr != 'left(' && subStr != 'right)' && subStr != r'left{' && subStr != r'right}' && subStr != 'left[' && subStr != 'right]' &&
					subStr != 'big|' && subStr != 'Big|' && subStr != 'bigg|' && subStr != 'Bigg|' &&
					double.tryParse(expr[j]) == null
				) {
					j++;
					subStr = expr.substringSafe(i+1, j);
				}

				if (SyntaxParser.isLatexCommand(subStr)) {
					nodesAndTokens.add(SyntaxParser.parseLatexCommand(subStr));
				} else {
					if (_errorHandlingMode == ParsingMode.strict) throw(UnknownCommandException('\\$subStr not supported'));
					nodesAndTokens.add(ErrorNode(errorVisualization: ErrorVisualization.fromParsing(_errorHandlingMode), msg: '\\$subStr'));
				}
				i = j-1;


			} else if (expr[i] == '\'') { // find derivatives

				int j = 0;
				do {
					j++;
					if (i+j >= expr.length || j >= 4) break;
				} while (expr[i+j] == '\'');

				if (j == 1) {
					nodesAndTokens.add(TextNode('\u2032'));
				} else if (j == 2) {
					nodesAndTokens.add(TextNode('\u2033'));
				} else if (j == 3) {
					nodesAndTokens.add(TextNode('\u2034'));
				} else if (j == 4) {
					nodesAndTokens.add(TextNode('\u2057'));
				}

				i += j-1;


			} else { // find variables
				int j = i;
				bool isText = _isText(nodesAndTokens);
				while (!(SyntaxParser.isSingleCharacterElement(expr[j]) ||
					expr[j] == r'\' ||
					expr[j] == ' ' && !isText ||
					expr[j] == '\'' ||
					double.tryParse(expr[j]) != null)
				) {
					j++;
					if (j >= expr.length) break;
				}

				if (j > i) {
					nodesAndTokens.add(TextNode(expr.substringSafe(i,j), font: MainItalicLatexFont()));
					i = j-1;
				}
			}
		}
		
		return nodesAndTokens;
	}

	bool _isText(List<dynamic> nodesAndTokens) {
		return nodesAndTokens.length >=2 &&
			nodesAndTokens.secondToLast is FunctionalToken && (nodesAndTokens.secondToLast as FunctionalToken).type == FunctionType.font &&
			nodesAndTokens.last is BracketToken && (nodesAndTokens.last as BracketToken).type == BracketTokenType.leftCurly;
	}

	/// Groups all bracket terms.
	void _groupBracketTerms(List<dynamic> nodesAndTokens) {
		while (true) {

			int startIndex_curlyBracket = -1;
			int startIndex_squareBracket = -1;
			bool showGroupCurlyBrackets = false;
			int startIndex_roundBracket = -1;
			int endIndex_curlyBracket = -1;
			int endIndex_squareBracket = -1;
			int endIndex_roundBracket = -1;

			loop: for (var i = 0; i < nodesAndTokens.length; i++) {
				dynamic token = nodesAndTokens[i];
				if (token is !BracketToken) continue;

				switch (token.type) {
					case BracketTokenType.leftCurly:
						startIndex_curlyBracket = i;
						showGroupCurlyBrackets = token.showGroupCurlyBrackets;
						break;

					case BracketTokenType.rightCurly:
						endIndex_curlyBracket = i;
						if (startIndex_curlyBracket >= 0) {
							showGroupCurlyBrackets &= token.showGroupCurlyBrackets;
              break loop;
            }
            break;

					case BracketTokenType.leftSquare:
						startIndex_squareBracket = i;
						break;

					case BracketTokenType.rightSquare:
						endIndex_squareBracket = i;
						if (startIndex_squareBracket >= 0) break loop;
						break;

					case BracketTokenType.leftRound:
						startIndex_roundBracket = i;
						break;

					case BracketTokenType.rightRound:
						endIndex_roundBracket = i;
						if (startIndex_roundBracket >= 0) break loop;
						break;

					default: break;
				}
			}

			// found curly bracket term and condense it
			if (startIndex_curlyBracket >= 0 && endIndex_curlyBracket >= startIndex_curlyBracket) {
				nodesAndTokens[startIndex_curlyBracket] = _groupNodes(
					nodesAndTokens.sublist(startIndex_curlyBracket+1, endIndex_curlyBracket),
					showGroupCurlyBrackets ? BracketType.curly : BracketType.none,
				);
				nodesAndTokens.removeRange(startIndex_curlyBracket+1, endIndex_curlyBracket+1);

			// found square bracket term and condense it
			} else if (startIndex_squareBracket >= 0 && endIndex_squareBracket >= startIndex_squareBracket) {
				nodesAndTokens[startIndex_squareBracket] = _groupNodes(
					nodesAndTokens.sublist(startIndex_squareBracket+1, endIndex_squareBracket),
					BracketType.square,
				);
				nodesAndTokens.removeRange(startIndex_squareBracket+1, endIndex_squareBracket+1);

			// found round bracket term and condense it
			} else if (startIndex_roundBracket >= 0 && endIndex_roundBracket >= startIndex_roundBracket) {
				nodesAndTokens[startIndex_roundBracket] = _groupNodes(
					nodesAndTokens.sublist(startIndex_roundBracket+1, endIndex_roundBracket),
					BracketType.round,
				);
				nodesAndTokens.removeRange(startIndex_roundBracket+1, endIndex_roundBracket+1);

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
			if (node is !LatexRenderNode) throw GroupingException('${node.toString()} is not a node.');
			nodes.add(node);
		}

		// colors
		_addColorsToGroups(nodes);

		return GroupNode(nodes, bracketType);
	}

	void _replaceSingleBrackets(List<dynamic> nodesAndTokens) {
		for (var i = 0; i < nodesAndTokens.length; i++) {
			dynamic token = nodesAndTokens[i];
			if (token is !BracketToken) continue;

			switch ((nodesAndTokens[i] as BracketToken).type) {
				case BracketTokenType.leftRound:
					nodesAndTokens[i] = BracketNode(BracketType.round, BracketOrientation.left);
					break;
				case BracketTokenType.rightRound:
					nodesAndTokens[i] = BracketNode(BracketType.round, BracketOrientation.right);
					break;
				case BracketTokenType.leftSquare:
					nodesAndTokens[i] = BracketNode(BracketType.square, BracketOrientation.left);
					break;
				case BracketTokenType.rightSquare:
					nodesAndTokens[i] = BracketNode(BracketType.square, BracketOrientation.right);
					break;
				case BracketTokenType.doubleLeftSquare:
					nodesAndTokens[i] = BracketNode(BracketType.doubleSquare, BracketOrientation.left);
					break;
				case BracketTokenType.doubleRightSquare:
					nodesAndTokens[i] = BracketNode(BracketType.doubleSquare, BracketOrientation.right);
					break;

				default: break;
			}
		}
	}

	void _parseFunctions(List<dynamic> nodesAndTokens, {int? start, int? end}) {
		for (var i = start ?? 0; i < (end ?? nodesAndTokens.length); i++) {
			dynamic token = nodesAndTokens[i];
			if (token is !FunctionalToken) continue;

			switch (token.type) {
				case FunctionType.topDecoration:
					_parseFunction1(nodesAndTokens, i, token.cmd, (n) => TopDecorationNode(n, token.topDecoration!));
					break;

				case FunctionType.bottomDecoration:
					_parseFunction1(nodesAndTokens, i, token.cmd, (n) => BottomDecorationNode(n, token.bottomDecoration!));
					break;

				case FunctionType.font:
					_parseFunction1(nodesAndTokens, i, token.cmd, (n) => FontNode(n, font: token.font, isBold: token.isBold ?? false));
					break;

				case FunctionType.color:
					_parseFunction1(
						nodesAndTokens, i, token.cmd, (n) => ColorNode(n));
					break;

				case FunctionType.binom:
					_parseFunction2(nodesAndTokens, i, token.cmd, (n0, n1) => BinomNode(n0, n1));
					break;

				case FunctionType.cases:
					_parseFunction_cases(nodesAndTokens, i, token.cmd);
					break;

				case FunctionType.frac:
					_parseFunction2(nodesAndTokens, i, token.cmd, (n0, n1) => FracNode(n0, n1));
					break;

				case FunctionType.limProdSum:
					_parseFunction_LimProdSum(nodesAndTokens, i, token.limProdSumType!);
					break;

				case FunctionType.matrix:
					_parseFunction_matrix(nodesAndTokens, i, token.cmd, token.bracketType!);
					break;

				case FunctionType.nocursor:
					_parseFunction1(nodesAndTokens, i, token.cmd, (n) => NoCursorNode(n));
					break;

				case FunctionType.subscript:
					bool shiftIndexToLeft = _parseFunction_subSuper(nodesAndTokens, i, false);
					if (shiftIndexToLeft) i--;
					break;

				case FunctionType.superscript:
					bool shiftIndexToLeft = _parseFunction_subSuper(nodesAndTokens, i, true);
					if (shiftIndexToLeft) i--;
					break;

				case FunctionType.sqrt:
					_parseFunction2_firstOptional(
						nodesAndTokens, i, '\\sqrt', (n, optional) => SqrtNode(n, exponent: optional));
					break;
			}

		}
	}

	void _parseFunction1(List<dynamic> nodesAndTokens, int index, String name,
		LatexRenderNode Function(LatexRenderNode node) createNode) {

		if (index+1 <= nodesAndTokens.lastIndex && nodesAndTokens[index+1] is LatexRenderNode) {
			try {
				nodesAndTokens[index] = createNode(nodesAndTokens[index+1]);
			} catch (e) {
				if (_errorHandlingMode == ParsingMode.strict) rethrow;
				nodesAndTokens[index] = ErrorNode(
					errorVisualization: ErrorVisualization.fromParsing(_errorHandlingMode),
					msg: e.toString(),
				);
			}
    } else {
			nodesAndTokens[index] = _createArgsErrorNode(name);
		}

		nodesAndTokens.removeRange(index+1, index+2);
	}

	void _parseFunction2(List<dynamic> nodesAndTokens, int index, String name,
		LatexRenderNode Function(LatexRenderNode n1, LatexRenderNode n2) createNode) {

		if (index+2 <= nodesAndTokens.lastIndex &&
			nodesAndTokens[index+1] is LatexRenderNode &&
			nodesAndTokens[index+2] is LatexRenderNode
		) {
    	nodesAndTokens[index] = createNode(nodesAndTokens[index+1], nodesAndTokens[index+2]);
    } else {
			nodesAndTokens[index] = _createArgsErrorNode(name, 'arg1: $nodesAndTokens, arg2: ${index+2 > nodesAndTokens.lastIndex ? null : nodesAndTokens[index+2]}');
		}

		nodesAndTokens.removeRange(index+1, index+3);
	}

	void _parseFunction2_firstOptional(
		List<dynamic> nodesAndTokens,
		int index,
		String name,
		LatexRenderNode Function(LatexRenderNode n, LatexRenderNode? optional) createNode
	) {

		if (index+1 <= nodesAndTokens.lastIndex && nodesAndTokens[index+1] is LatexRenderNode) {
			if (index+2 < nodesAndTokens.length &&
				(nodesAndTokens[index+2] is LatexRenderNode) &&
				(nodesAndTokens[index+1] is GroupNode) &&
				(nodesAndTokens[index+1] as GroupNode).bracketType == BracketType.square
			) {

				// set bracket type of optional to None
				(nodesAndTokens[index+1] as GroupNode).bracketType = BracketType.none;

				nodesAndTokens[index] = createNode(nodesAndTokens[index+2], nodesAndTokens[index+1]);
				nodesAndTokens.removeRange(index+1, index+3);
			} else {
				nodesAndTokens[index] = createNode(nodesAndTokens[index+1], null);
				nodesAndTokens.removeRange(index+1, index+2);
			}

    } else {
			nodesAndTokens[index] = _createArgsErrorNode(name);
			nodesAndTokens.removeRange(index+1, index+2);
		}

	}

	void _parseFunction_cases(List<dynamic> nodesAndTokens, int index, String name) {
		if (index+1 <= nodesAndTokens.lastIndex && nodesAndTokens[index+1] is GroupNode) {
			nodesAndTokens[index] = CasesNode.fromGroup(nodesAndTokens[index+1]);
    } else {
			nodesAndTokens[index] = _createArgsErrorNode(name);
		}

		nodesAndTokens.removeRange(index+1, index+2);
	}

	void _parseFunction_matrix(List<dynamic> nodesAndTokens, int index, String name, BracketType bracketType) {
		if (index+1 <= nodesAndTokens.lastIndex && nodesAndTokens[index+1] is GroupNode) {
			nodesAndTokens[index] = MatrixNode.fromGroup(nodesAndTokens[index+1], bracketType: bracketType);
		} else {
			nodesAndTokens[index] = _createArgsErrorNode(name);
		}

		nodesAndTokens.removeRange(index+1, index+2);
	}

	void _parseFunction_LimProdSum(List<dynamic> nodesAndTokens, int index, LimProdSumType type) {
		dynamic token1 = index+1 < nodesAndTokens.length ? nodesAndTokens[index+1] : null;
		dynamic token2 = index+2 < nodesAndTokens.length ? nodesAndTokens[index+2] : null;
		dynamic token3 = index+3 < nodesAndTokens.length ? nodesAndTokens[index+3] : null;
		dynamic token4 = index+4 < nodesAndTokens.length ? nodesAndTokens[index+4] : null;

		if (token1 is FunctionalToken &&
			(token1.type == FunctionType.subscript || token1.type == FunctionType.superscript) &&
			token2 is LatexRenderNode
		) {
			bool firstIsSuper = token1.type == FunctionType.superscript;

			// \lim_a^b or \lim^a_b
			if (token3 is FunctionalToken &&
				((firstIsSuper && token3.type == FunctionType.subscript) || token3.type == FunctionType.superscript) &&
				token4 is LatexRenderNode
			) {
				nodesAndTokens[index] = LimProdSumNode(
					type: type,
					superscript: firstIsSuper ? token2 : token4,
					subscript: firstIsSuper ? token4 : token2,
				);
				nodesAndTokens.removeRange(index+1, index+5);

			// \lim_a or \lim^a
			} else {
				nodesAndTokens[index] = LimProdSumNode(
					type: type,
					superscript: firstIsSuper ? token2 : null,
					subscript: firstIsSuper ? null : token2,
				);
				nodesAndTokens.removeRange(index+1, index+3);
			}

		// \lim
		} else {
			nodesAndTokens[index] = LimProdSumNode(type: type);
		}
	}

	bool _parseFunction_subSuper(List<dynamic> nodesAndTokens, int index, bool firstIsSuper) {
		dynamic token1 = index+1 < nodesAndTokens.length ? nodesAndTokens[index+1] : null;
		if (token1 is !LatexRenderNode) {
			_parseFunctions(nodesAndTokens, start: index+1, end: index+2);
			token1 = index+1 < nodesAndTokens.length ? nodesAndTokens[index+1] : null;
			if (token1 is !LatexRenderNode) {
				nodesAndTokens[index] = _createArgsErrorNode(firstIsSuper ? '^' : '_');
				nodesAndTokens.removeRange(index+1, index+2);
				return false;
			}
		}

		// handle a_b^c and a^b_c
		dynamic token2 = index+2 < nodesAndTokens.length ? nodesAndTokens[index+2] : null;
		dynamic token3 = index+3 < nodesAndTokens.length ? nodesAndTokens[index+3] : null;

		bool isToken2SubOrSup = token2 is FunctionalToken &&
			((firstIsSuper && token2.type == FunctionType.subscript) || (!firstIsSuper && token2.type == FunctionType.superscript));

		if (isToken2SubOrSup && token3 is !LatexRenderNode) {
			_parseFunctions(nodesAndTokens, start: index+3, end: index+4);
			token3 = index+3 < nodesAndTokens.length ? nodesAndTokens[index+3] : null;
		}

		dynamic parentToken = index - 1 >= 0 ? nodesAndTokens[index-1] : null;

    LatexRenderNode? parent;
		int offset = 0;
		if (parentToken is LatexRenderNode && (!parentToken.spacingRequired || parentToken is IntNode)) {
			parent = parentToken;
			offset = 1;
		}

		if (isToken2SubOrSup && token3 is LatexRenderNode) {
			nodesAndTokens[index-offset] = SupSubNode(
				parent,
				subscript: firstIsSuper ? token3 : token1,
				superscript: firstIsSuper ? token1 : token3,
			);
			nodesAndTokens.removeRange(index+1-offset, index+4);

		} else {
			if (firstIsSuper) {
				nodesAndTokens[index-offset] = SupSubNode(parent, superscript: token1);
			} else {
				nodesAndTokens[index-offset] = SupSubNode(parent, subscript: token1);
			}
			nodesAndTokens.removeRange(index+1-offset, index+2);
		}

		return parent != null;
	}

	ErrorNode _createArgsErrorNode(String functionName, [String msg = '']) {
		if (_errorHandlingMode == ParsingMode.strict) {
			throw(ArgumentsException('Arguments missing for "$functionName" -- $msg'));
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
			if (colorNode is !ColorNode) continue;
			int end = i+1;
			for (var j = i+1; j < nodes.length; j++) {
				if (nodes[j] is ColorNode) break;
				end++;
			}
			if (end > i+1) {
				nodes[i] = GroupNode(nodes.getRange(i+1, end).toList(), BracketType.none, color: colorNode.color);
				nodes.removeRange(i+1, end);
			} else {
				nodes.removeRange(i, i+1);
				i--;
			}
		}
	}

}