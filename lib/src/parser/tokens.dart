import '../font/__export.dart';
import '../nodes/__export.dart';
import '../render/__export.dart';

class Token {}

enum BracketTokenType {
  leftRound,
  rightRound,
  leftCurly,
  rightCurly,
  leftSquare,
  rightSquare,
  leftVertical,
  rightVertical,
  leftDoubleVertical,
  rightDoubleVertical,
  leftAngle,
  rightAngle,
  leftFloor,
  rightFloor,
  leftCeil,
  rightCeil,
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

class SizedBracketToken extends Token {
  final double heightScale;
  final BracketOrientation bracketOrientation;

  SizedBracketToken(this.heightScale, this.bracketOrientation);
}

enum FunctionType {
  topDecoration,
  bottomDecoration,
  font,

  binom,
  boxed,
  cases,
  color,
  frac,
  extendedArrow,
  limProdSum,
  limitPlacement,
  mathStyle,
  matrix,
  nocursor,
  pmod,
  substack,
  superscript,
  subscript,
  sqrt,
  overset,
  underset,
  stackrel,
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
  'lcm',
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
  final bool? isTextStyle;
  final bool isSmallMatrix;
  final LatexMathStyle? mathStyle;
  final OperatorLimitsPlacement? limitsPlacement;
  final ExtendedArrowDirection? extendedArrowDirection;

  FunctionalToken(
    this.type, {
    required this.cmd,
    this.topDecoration,
    this.bottomDecoration,
    this.bracketType,
    this.limProdSumType,
    this.font,
    this.isBold,
    this.isTextStyle,
    this.isSmallMatrix = false,
    this.mathStyle,
    this.limitsPlacement,
    this.extendedArrowDirection,
  });

  @override
  String toString() => 'FunctionalToken - type: $type';
}
