import '../font/__export.dart';
import '../nodes/__export.dart';

class Token {}

enum BracketTokenType {
  leftRound,
  rightRound,
  leftCurly,
  rightCurly,
  leftSquare,
  rightSquare,
  doubleLeftSquare,
  doubleRightSquare,
}

class BracketToken extends Token {
  final BracketTokenType type;
  final bool showGroupCurlyBrackets;

  BracketToken(this.type, {this.showGroupCurlyBrackets = false});

  @override
  String toString() => 'BracketToken - type: $type';
}

enum FunctionType {
  topDecoration,
  bottomDecoration,
  font,

  binom,
  cases,
  color,
  frac,
  limProdSum,
  matrix,
  nocursor,
  superscript,
  subscript,
  sqrt,
}

List<String> functionNames = [
  'min',
  'max',
  'exp',
  'log',
  'ln',
  'lg',
  'sin',
  'cos',
  'tan',
  'cot',
  'arcsin',
  'arccos',
  'arctan',
  'arccot',
  'sinh',
  'cosh',
  'tanh',
  'coth',
  'nCr',
];

class FunctionalToken extends Token {
  final FunctionType type;
  final String cmd;
  final TopDecoration? topDecoration;
  final BottomDecoration? bottomDecoration;
  final BracketType? bracketType;
  final LimProdSumType? limProdSumType;
  final LatexFont? font;
  final bool? isBold;

  FunctionalToken(
    this.type, {
    required this.cmd,
    this.topDecoration,
    this.bottomDecoration,
    this.bracketType,
    this.limProdSumType,
    this.font,
    this.isBold,
  });

  @override
  String toString() => 'FunctionalToken - type: $type';
}
