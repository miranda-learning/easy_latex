import '../font/__export.dart';
import '../nodes/__export.dart';
import 'tokens.dart';


class SyntaxParser {

  static bool isSingleCharacterElement(String str) => _singleCharacterElements.containsKey(str);

  static dynamic parseSingleCharacterElement(String str) => _singleCharacterElements[str]?.call();

  static final Map<String, Function> _singleCharacterElements = {
    '^': () => FunctionalToken(FunctionType.superscript, cmd: '^'),
    '_': () => FunctionalToken(FunctionType.subscript, cmd: '_'),

    '{': () => BracketToken(BracketTokenType.leftCurly),
    '}': () => BracketToken(BracketTokenType.rightCurly),
    '[': () => BracketToken(BracketTokenType.leftSquare),
    ']': () => BracketToken(BracketTokenType.rightSquare),
    '(': () => BracketNode(BracketType.round, BracketOrientation.left),
    ')': () => BracketNode(BracketType.round, BracketOrientation.right),

    '+': () => TextNode('+', spacingRequired: true),
    '-': () => TextNode('\u2212', spacingRequired: true),
    '*': () => TextNode('*', spacingRequired: true),
    '/': () => TextNode('/', spacingRequired: false),
    '=': () => TextNode('=', spacingRequired: true),
    '?': () => TextNode('?'),
    '!': () => TextNode('!'),

    ':': () => TextNode(':', spacingRequired: true),
    '>': () => TextNode('>', spacingRequired: true),
    '<': () => TextNode('<', spacingRequired: true),
    '~': () => TextNode('\u00a0'),
    '|': () => TextNode('\u2223'),
    '`': () => TextNode('\u2018'),

    ',': () => TextNode(',\u200A'),
    ';': () => TextNode(';\u200A'),

    '&': () => NewColumnNode(),
    '°': () => TextNode('\u00B0'),
  };


  static bool isSingleCharLatexCommand(String str) => _singleCharacterLatexCommands.contains(str);

  static const Set<String> _singleCharacterLatexCommands = {
    // Newline
    r'\',

    // Symbols
    '#',
    '&',
    '\$',
    '%',
    '_',
    '|',

    // Spacer
    ',',
    ';',
    ' ',

    // Brackets
    '[',
    ']',
    '{',
    '}',
  };

  static bool isLatexCommand(String str) => _latexCommands.containsKey(str);

  static dynamic parseLatexCommand(String str) => _latexCommands[str]?.call();

  static final Map<String, Function> _latexCommands = {
    // Newline
    r'\': () => NewlineNode(),

    // Custom
    'comma': () => CommaNode(),
    'listcomma': () => CommaNode(isListSeparator: true),
    'minus': () => MinusNode(),
    'placeholder': () => PlaceholderNode(),
    'dashplaceholder': () => PlaceholderNode(type: PlaceholderType.dashed),
    'redplaceholder': () => PlaceholderNode(type: PlaceholderType.lightRed),
    'nocursor': () => FunctionalToken(FunctionType.nocursor, cmd: 'nocursor'),

    // Brackets
    'left(': () => BracketToken(BracketTokenType.leftRound),
    'right)': () => BracketToken(BracketTokenType.rightRound),
    'left{': () => BracketToken(BracketTokenType.leftCurly, showGroupCurlyBrackets: true), // original latex: \left\{, but _cleanInitialExpr() remove the second \
    'right}': () => BracketToken(BracketTokenType.rightCurly, showGroupCurlyBrackets: true), // original latex: \right\}, but _cleanInitialExpr() remove the second \
    'left[': () => BracketToken(BracketTokenType.leftSquare),
    'right]': () => BracketToken(BracketTokenType.rightSquare),
    'llbracket': () => BracketToken(BracketTokenType.doubleLeftSquare),
    'rrbracket': () => BracketToken(BracketTokenType.doubleRightSquare),

    'lparen': () => BracketNode(BracketType.round, BracketOrientation.left),
    'rparen': () => BracketNode(BracketType.round, BracketOrientation.right),
    '[': () => BracketNode(BracketType.square, BracketOrientation.left),
    ']': () => BracketNode(BracketType.square, BracketOrientation.right),
    'lbrack': () => BracketNode(BracketType.square, BracketOrientation.left),
    'rbrack': () => BracketNode(BracketType.square, BracketOrientation.right),
    '{': () => BracketNode(BracketType.curly, BracketOrientation.left),
    '}': () => BracketNode(BracketType.curly, BracketOrientation.right),
    'lbrace': () => BracketNode(BracketType.curly, BracketOrientation.left),
    'rbrace': () => BracketNode(BracketType.curly, BracketOrientation.right),
    'lgroup': () => TextNode('\u27ee'),
    'rgroup': () => TextNode('\u27ef'),

    // Cases
    'cases':        () => FunctionalToken(FunctionType.cases,       cmd: 'cases'),

    // Norm
    'big|': () => NormNode(NormSize.big),
    'Big|': () => NormNode(NormSize.Big),
    'bigg|': () => NormNode(NormSize.bigg),
    'Bigg|': () => NormNode(NormSize.Bigg),

    // Top decoration
    'bar':                () => FunctionalToken(FunctionType.topDecoration, cmd: 'bar',                topDecoration: TopDecoration.bar),
    'dot':                () => FunctionalToken(FunctionType.topDecoration, cmd: 'dot',                topDecoration: TopDecoration.dot),
    'ddot':               () => FunctionalToken(FunctionType.topDecoration, cmd: 'ddot',               topDecoration: TopDecoration.ddot),
    'dddot':              () => FunctionalToken(FunctionType.topDecoration, cmd: 'dddot',              topDecoration: TopDecoration.dddot),
    'hat':                () => FunctionalToken(FunctionType.topDecoration, cmd: 'hat',                topDecoration: TopDecoration.hat),
    'overbrace':          () => FunctionalToken(FunctionType.topDecoration, cmd: 'overbrace',          topDecoration: TopDecoration.overbrace),
    'overline':           () => FunctionalToken(FunctionType.topDecoration, cmd: 'overline',           topDecoration: TopDecoration.overline),
    'overleftarrow':      () => FunctionalToken(FunctionType.topDecoration, cmd: 'overleftarrow',      topDecoration: TopDecoration.overleftarrow),
    'overleftrightarrow': () => FunctionalToken(FunctionType.topDecoration, cmd: 'overleftrightarrow', topDecoration: TopDecoration.overleftrightarrow),
    'overrightarrow':     () => FunctionalToken(FunctionType.topDecoration, cmd: 'overrightarrow',     topDecoration: TopDecoration.overrightarrow),
    'tilde':              () => FunctionalToken(FunctionType.topDecoration, cmd: 'tilde',              topDecoration: TopDecoration.tilde),
    'vec':                () => FunctionalToken(FunctionType.topDecoration, cmd: 'vec',                topDecoration: TopDecoration.vec),
    'widehat':            () => FunctionalToken(FunctionType.topDecoration, cmd: 'widehat',            topDecoration: TopDecoration.widehat),
    'widetilde':          () => FunctionalToken(FunctionType.topDecoration, cmd: 'widetilde',          topDecoration: TopDecoration.widetilde),

    // Bottom decoration
    'underbrace':         () => FunctionalToken(FunctionType.bottomDecoration, cmd: 'underbrace', bottomDecoration: BottomDecoration.underbrace),
    'underline':          () => FunctionalToken(FunctionType.bottomDecoration, cmd: 'underline',  bottomDecoration: BottomDecoration.underline),

    // Color
    'color':        () => FunctionalToken(FunctionType.color,       cmd: 'color'),

    // Fonts
    'bm':           () => FunctionalToken(FunctionType.font, cmd: 'bm',           isBold: true),
    'boldsymbol':   () => FunctionalToken(FunctionType.font, cmd: 'boldsymbol',   isBold: true),
    'mathbb':       () => FunctionalToken(FunctionType.font, cmd: 'mathbb',       font: AmsLatexFont()),
    'mathbf':       () => FunctionalToken(FunctionType.font, cmd: 'mathbf',       font: MainLatexFont(), isBold: true),
    'mathcal':      () => FunctionalToken(FunctionType.font, cmd: 'mathcal',      font: CalLatexFont()),
    'mathfrak':     () => FunctionalToken(FunctionType.font, cmd: 'mathfrak',     font: FrakturLatexFont()),
    // 'mathit':       () => FunctionalToken(FunctionType.font, cmd: 'mathit',       font: MainItalicLatexFont()), no italic supported for 0-9
    'mathrm':       () => FunctionalToken(FunctionType.font, cmd: 'mathrm',       font: MainLatexFont()),
    'mathscr':      () => FunctionalToken(FunctionType.font, cmd: 'mathscr',      font: ScriptLatexFont()),
    'mathtt':       () => FunctionalToken(FunctionType.font, cmd: 'mathtt',       font: TypewriterLatexFont()),
    'operatorname': () => FunctionalToken(FunctionType.font, cmd: 'operatorname', font: MainLatexFont()), // TODO
    'text':         () => FunctionalToken(FunctionType.font, cmd: 'text',         font: MainLatexFont()),
    'textrm':       () => FunctionalToken(FunctionType.font, cmd: 'textrm',       font: MainLatexFont()),

    // Big, Lim, Prod, Sum
    'bigcap':       () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigcap',    limProdSumType: LimProdSumType.bigcap),
    'bigcup':       () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigcup',    limProdSumType: LimProdSumType.bigcup),
    'bigodot':      () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigodot',   limProdSumType: LimProdSumType.bigodot),
    'bigoplus':     () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigoplus',  limProdSumType: LimProdSumType.bigoplus),
    'bigotimes':    () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigotimes', limProdSumType: LimProdSumType.bigotimes),
    'bigsqcup':     () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigsqcup',  limProdSumType: LimProdSumType.bigsqcup),
    'biguplus':     () => FunctionalToken(FunctionType.limProdSum,  cmd: 'biguplus',  limProdSumType: LimProdSumType.biguplus),
    'bigvee':       () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigvee',    limProdSumType: LimProdSumType.bigvee),
    'bigwedge':     () => FunctionalToken(FunctionType.limProdSum,  cmd: 'bigwedge',  limProdSumType: LimProdSumType.bigwedge),
    'coprod':       () => FunctionalToken(FunctionType.limProdSum,  cmd: 'coprod',    limProdSumType: LimProdSumType.coprod),
    'lim':          () => FunctionalToken(FunctionType.limProdSum,  cmd: 'lim',       limProdSumType: LimProdSumType.lim),
    'prod':         () => FunctionalToken(FunctionType.limProdSum,  cmd: 'prod',      limProdSumType: LimProdSumType.prod),
    'sum':          () => FunctionalToken(FunctionType.limProdSum,  cmd: 'sum',       limProdSumType: LimProdSumType.sum),

    // Integrals
    'int': () => IntNode(),
    'iint': () => IntNode(type: IntegralType.double),
    'iiint': () => IntNode(type: IntegralType.triple),
    'iiiint': () => IntNode(type: IntegralType.quad),
    'oint': () => IntNode(type: IntegralType.contour),
    'oiint': () => IntNode(type: IntegralType.contourDouble),
    'oiiint': () => IntNode(type: IntegralType.contourTriple),
    'oiiiint': () => IntNode(type: IntegralType.contourQuad),
    'intop': () => IntNode(), // TODO
    'smallint': () => IntNode(isInline: true), //TODO
    'intinline': () => IntNode(isInline: true), // custom

    // Matrix
    'matrix':       () => FunctionalToken(FunctionType.matrix,      cmd: 'matrix',  bracketType: BracketType.none),
    'pmatrix':      () => FunctionalToken(FunctionType.matrix,      cmd: 'pmatrix', bracketType: BracketType.round),
    'bmatrix':      () => FunctionalToken(FunctionType.matrix,      cmd: 'bmatrix', bracketType: BracketType.square),
    'Bmatrix':      () => FunctionalToken(FunctionType.matrix,      cmd: 'Bmatrix', bracketType: BracketType.curly),

    // Binom, Frac, Sqrt
    'binom':        () => FunctionalToken(FunctionType.binom,       cmd: 'binom'),
    'frac':         () => FunctionalToken(FunctionType.frac,        cmd: 'frac'),
    'sqrt':         () => FunctionalToken(FunctionType.sqrt,        cmd: 'sqrt'),

    // Symbols
    '#': () => TextNode('\u0023'),
    '&': () => TextNode('\u0026'),
    'And': () => TextNode('\u0026'),
    '\$': () => TextNode('\$'),
    '%': () => TextNode('%'),
    'permil': () => TextNode('\u2030'),
    '_': () => TextNode('_'),
    '|': () => TextNode('\u2225'),
    'colon': () => TextNode(':'),

    // Operators
    'div': () => TextNode('\u00f7'),
    'pm': () => TextNode('\u00b1'),
    'mp': () => TextNode('\u2213'),
    'times': () => TextNode('\u00d7'),

    // Spacer
    ',': () => TextNode('\u200A'),
    ';': () => TextNode('\u2009'),
    ' ': () => TextNode('\u00a0'),
    'quad': () => TextNode('\u2001'),
    'qquad': () => TextNode('\u2001\u2001'),
    'space': () => TextNode('\u00a0'),
    'nobreakspace': () => TextNode('\u00a0'),
    // 'nobreak': () => TextNode(null),
    // 'allowbreak': () => TextNode(null),

    // Greek
    'alpha': () => TextNode('\u03b1', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'beta': () => TextNode('\u03b2', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'gamma': () => TextNode('\u03b3', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'delta': () => TextNode('\u03b4', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'epsilon': () => TextNode('\u03f5', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'zeta': () => TextNode('\u03b6', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'eta': () => TextNode('\u03b7', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'theta': () => TextNode('\u03b8', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'iota': () => TextNode('\u03b9', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'kappa': () => TextNode('\u03ba', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'lambda': () => TextNode('\u03bb', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'mu': () => TextNode('\u03bc', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'nu': () => TextNode('\u03bd', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'xi': () => TextNode('\u03be', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'omicron': () => TextNode('\u03bf', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'pi': () => TextNode('\u03c0', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'rho': () => TextNode('\u03c1', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'sigma': () => TextNode('\u03c3', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'tau': () => TextNode('\u03c4', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'upsilon': () => TextNode('\u03c5', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'phi': () => TextNode('\u03d5', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'chi': () => TextNode('\u03c7', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'psi': () => TextNode('\u03c8', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'omega': () => TextNode('\u03c9', font: MainItalicLatexFont(), textType: TextType.lowerCase),

    'varepsilon': () => TextNode('\u03b5', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'vartheta': () => TextNode('\u03d1', font: MainItalicLatexFont(), textType: TextType.upperCase),
    'varkappa': () => TextNode('\u03f0', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'varpi': () => TextNode('\u03d6', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'varrho': () => TextNode('\u03f1', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'varsigma': () => TextNode('\u03c2', font: MainItalicLatexFont(), textType: TextType.lowerCase),
    'varphi': () => TextNode('\u03c6', font: MainItalicLatexFont(), textType: TextType.lowerCase),

    // Capital greek Latex-letters are not italic (capital latin are italic). We us lowerCase since the height of regular letters is differently defined
    'Alpha': () => TextNode('A', textType: TextType.upperCase),
    'Beta': () => TextNode('B', textType: TextType.upperCase),
    'Gamma': () => TextNode('\u0393', textType: TextType.upperCase),
    'Delta': () => TextNode('\u0394', textType: TextType.upperCase),
    'Epsilon': () => TextNode('E', textType: TextType.upperCase),
    'Zeta': () => TextNode('Z', textType: TextType.upperCase),
    'Eta': () => TextNode('H', textType: TextType.upperCase),
    'Theta': () => TextNode('\u0398', textType: TextType.upperCase),
    'Iota': () => TextNode('I', textType: TextType.upperCase),
    'Kappa': () => TextNode('K', textType: TextType.upperCase),
    'Lambda': () => TextNode('\u039b', textType: TextType.upperCase),
    'Mu': () => TextNode('M', textType: TextType.upperCase),
    'Nu': () => TextNode('N', textType: TextType.upperCase),
    'Xi': () => TextNode('\u039e', textType: TextType.upperCase),
    'Omicron': () => TextNode('O', textType: TextType.upperCase),
    'Pi': () => TextNode('\u03a0', textType: TextType.upperCase),
    'Rho': () => TextNode('P', textType: TextType.upperCase),
    'Sigma': () => TextNode('\u03a3', textType: TextType.upperCase),
    'Tau': () => TextNode('T', textType: TextType.upperCase),
    'Upsilon': () => TextNode('\u03a5', textType: TextType.upperCase),
    'Phi': () => TextNode('\u03a6', textType: TextType.upperCase),
    'Chi': () => TextNode('X', textType: TextType.upperCase),
    'Psi': () => TextNode('\u03a8', textType: TextType.upperCase),
    'Omega': () => TextNode('\u03a9', textType: TextType.upperCase),

    // Function names
    'min': () => TextNode('min', textType: TextType.upperCase),
    'max': () => TextNode('max', textType: TextType.lowerCase),
    'sup': () => TextNode('sup', textType: TextType.lowerCase),
    'inf': () => TextNode('inf', textType: TextType.upperCase),

    'limsup': () => TextNode('lim sup', textType: TextType.upperCase),
    'liminf': () => TextNode('lim inf', textType: TextType.upperCase),

    'exp': () => TextNode('exp', textType: TextType.lowerCase),
    'log': () => TextNode('log', textType: TextType.upperCase),
    'ln': () => TextNode('ln', textType: TextType.upperCase),
    'lg': () => TextNode('lg', textType: TextType.upperCase),

    'sin': () => TextNode('sin', textType: TextType.upperCase),
    'cos': () => TextNode('cos', textType: TextType.lowerCase),
    'tan': () => TextNode('tan', textType: TextType.upperCase),
    'sec': () => TextNode('sec', textType: TextType.lowerCase),
    'csc': () => TextNode('csc', textType: TextType.lowerCase),
    'cot': () => TextNode('cot', textType: TextType.upperCase),

    'arcsin': () => TextNode('arcsin', textType: TextType.upperCase),
    'arccos': () => TextNode('arccos', textType: TextType.lowerCase),
    'arctan': () => TextNode('arctan', textType: TextType.upperCase),
    'arcsec': () => TextNode('arcsec', textType: TextType.lowerCase),
    'arccsc': () => TextNode('arccsc', textType: TextType.lowerCase),
    'arccot': () => TextNode('arccot', textType: TextType.upperCase),

    'sinh': () => TextNode('sinh', textType: TextType.upperCase),
    'cosh': () => TextNode('cosh', textType: TextType.upperCase),
    'tanh': () => TextNode('tanh', textType: TextType.upperCase),
    'coth': () => TextNode('coth', textType: TextType.upperCase),

    'nCr': () => TextNode('nCr', textType: TextType.upperCase),
    'mod': () => TextNode('mod', textType: TextType.lowerCase),

    'arg': () => TextNode('arg', textType: TextType.lowerCase),
    'sgn': () => TextNode('sgn', textType: TextType.lowerCase),
    'deg': () => TextNode('deg', textType: TextType.upperCase),
    'dim': () => TextNode('dim', textType: TextType.upperCase),
    'hom': () => TextNode('hom', textType: TextType.upperCase),
    'ker': () => TextNode('ker', textType: TextType.upperCase),
    'gcd': () => TextNode('gcd', textType: TextType.upperCase),
    'det': () => TextNode('det', textType: TextType.upperCase),
    'Pr': () => TextNode('Pr', textType: TextType.upperCase),

    // Special letters
    'AA': () => TextNode('\u212b', font: MainItalicLatexFont(), textType: TextType.upperCase),

    // Dots
    'cdot': () => TextNode('\u22c5', spacingRequired: true),
    'centerdot': () => TextNode('\u22c5', spacingRequired: true),
    'cdotp': () => TextNode('\u22c5'),
    'cdots': () => TextNode('\u22ef'),
    'dots': () => TextNode('.\u200A.\u200A.'),
    'dotsb': () => TextNode('\u22ef'),
    'dotsc': () => TextNode('.\u200A.\u200A.'),
    'dotsm': () => TextNode('\u22ef'),
    'dotsi': () => TextNode('\u22ef'),
    'dotso': () => TextNode('.\u200A.\u200A.'),
    'vdots': () => TextNode('\u22ee'),
    'varvdots': () => TextNode('\u2af6'),
    'ldotp': () => TextNode('\u002e'),
    'ldots': () => TextNode('\u2026'),
    'ddots': () => TextNode('\u22f1'),
    'bullet': () => TextNode('\u2219'),
    'mathellipsis': () => TextNode('\u2026'),
    'therefore': () => TextNode('\u2234'),
    'because': () => TextNode('\u2235'),


    // Comparing
    'coloneqq': () => ColonEqqNode(spacingRequired: true),
    'ne': () => TextNode('\u2260', spacingRequired: true),
    'neq': () => TextNode('\u2260', spacingRequired: true),
    'equiv': () => TextNode('\u2261', spacingRequired: true),
    'doteq': () => TextNode('\u2250', spacingRequired: true),

    'approx': () => TextNode('\u2248', spacingRequired: true),
    'thickapprox': () => TextNode('\u2248', spacingRequired: true),
    'approxeq': () => TextNode('\u224a', spacingRequired: true),
    'cong': () => TextNode('\u2245', spacingRequired: true),

    'sim': () => TextNode('\u223c', spacingRequired: true),
    'thicksim': () => TextNode('\u223c', spacingRequired: true),
    'simeq': () => TextNode('\u2243', spacingRequired: true),

    'propto': () => TextNode('\u221d', spacingRequired: true),
    'varpropto': () => TextNode('\u221d', spacingRequired: true),

    'lt': () => TextNode('\u003c', spacingRequired: true),
    'le': () => TextNode('\u2264', spacingRequired: true),
    'leq': () => TextNode('\u2264', spacingRequired: true),
    'll': () => TextNode('\u226a', spacingRequired: true),

    'gt': () => TextNode('\u003e', spacingRequired: true),
    'ge': () => TextNode('\u2265', spacingRequired: true),
    'geq': () => TextNode('\u2265', spacingRequired: true),
    'gg': () => TextNode('\u226b', spacingRequired: true),

    'preceq': () => TextNode('\u2aaf', spacingRequired: true),
    'succeq': () => TextNode('\u2ab0', spacingRequired: true),
    'prec': () => TextNode('\u227a', spacingRequired: true),
    'succ': () => TextNode('\u227b', spacingRequired: true),

    'leqq': () => TextNode('\u2266', spacingRequired: true),
    'leqslant': () => TextNode('\u2a7d', spacingRequired: true),
    'eqslantless': () => TextNode('\u2a95', spacingRequired: true),
    'lesssim': () => TextNode('\u2272', spacingRequired: true),
    'lessapprox': () => TextNode('\u2a85', spacingRequired: true),
    'lessdot': () => TextNode('\u22d6', spacingRequired: true),

    'nless': () => TextNode('\u226e', spacingRequired: true),
    'nleqslant': () => TextNode('\ue010', spacingRequired: true),
    'nleqq': () => TextNode('\ue011', spacingRequired: true),
    'lneq': () => TextNode('\u2a87', spacingRequired: true),
    'lneqq': () => TextNode('\u2268', spacingRequired: true),

    'geqq': () => TextNode('\u2267', spacingRequired: true),
    'geqslant': () => TextNode('\u2a7e', spacingRequired: true),
    'eqslantgtr': () => TextNode('\u2a96', spacingRequired: true),
    'gtrsim': () => TextNode('\u2273', spacingRequired: true),
    'gtrapprox': () => TextNode('\u2a86', spacingRequired: true),
    'gtrdot': () => TextNode('\u22d7', spacingRequired: true),

    'ngtr': () => TextNode('\u226f', spacingRequired: true),
    'ngeqslant': () => TextNode('\ue00f', spacingRequired: true),
    'ngeqq': () => TextNode('\ue00e', spacingRequired: true),
    'gneq': () => TextNode('\u2a88', spacingRequired: true),
    'gneqq': () => TextNode('\u2269', spacingRequired: true),

    'lessgtr': () => TextNode('\u2276', spacingRequired: true),
    'lesseqgtr': () => TextNode('\u22da', spacingRequired: true),
    'lesseqqgtr': () => TextNode('\u2a8b', spacingRequired: true),

    'gtrless': () => TextNode('\u2277', spacingRequired: true),
    'gtreqless': () => TextNode('\u22db', spacingRequired: true),
    'gtreqqless': () => TextNode('\u2a8c', spacingRequired: true),

    'ngeq': () => TextNode('\u2271', spacingRequired: true),
    'nleq': () => TextNode('\u2270', spacingRequired: true),

    'lll': () => TextNode('\u22d8', spacingRequired: true),
    'llless': () => TextNode('\u22d8', spacingRequired: true),
    'gggtr': () => TextNode('\u22d9', spacingRequired: true),
    'ggg': () => TextNode('\u22d9', spacingRequired: true),

    'preccurlyeq': () => TextNode('\u227c', spacingRequired: true),
    'curlyeqprec': () => TextNode('\u22de', spacingRequired: true),
    'precsim': () => TextNode('\u227e', spacingRequired: true),
    'precapprox': () => TextNode('\u2ab7', spacingRequired: true),

    'succcurlyeq': () => TextNode('\u227d', spacingRequired: true),
    'curlyeqsucc': () => TextNode('\u22df', spacingRequired: true),
    'succsim': () => TextNode('\u227f', spacingRequired: true),
    'succapprox': () => TextNode('\u2ab8', spacingRequired: true),

    'lvertneqq': () => TextNode('\ue00c', spacingRequired: true),
    'lnsim': () => TextNode('\u22e6', spacingRequired: true),
    'lnapprox': () => TextNode('\u2a89', spacingRequired: true),
    'nprec': () => TextNode('\u2280', spacingRequired: true),
    'npreceq': () => TextNode('\u22e0', spacingRequired: true),
    'precnsim': () => TextNode('\u22e8', spacingRequired: true),
    'precnapprox': () => TextNode('\u2ab9', spacingRequired: true),

    'gvertneqq': () => TextNode('\ue00d', spacingRequired: true),
    'gnsim': () => TextNode('\u22e7', spacingRequired: true),
    'gnapprox': () => TextNode('\u2a8a', spacingRequired: true),
    'nsucc': () => TextNode('\u2281', spacingRequired: true),
    'nsucceq': () => TextNode('\u22e1', spacingRequired: true),
    'succnsim': () => TextNode('\u22e9', spacingRequired: true),
    'succnapprox': () => TextNode('\u2aba', spacingRequired: true),

    'precneqq': () => TextNode('\u2ab5', spacingRequired: true),
    'succneqq': () => TextNode('\u2ab6', spacingRequired: true),

    'nsim': () => TextNode('\u2241', spacingRequired: true),
    'nshortmid': () => TextNode('\ue006', spacingRequired: true),
    'ncong': () => TextNode('\u2246', spacingRequired: true),

    'backsim': () => TextNode('\u223d', spacingRequired: true),
    'backsimeq': () => TextNode('\u22cd', spacingRequired: true),

    'eqsim': () => TextNode('\u2242', spacingRequired: true),

    'eqcirc': () => TextNode('\u2256', spacingRequired: true),
    'circeq': () => TextNode('\u2257', spacingRequired: true),
    'triangleq': () => TextNode('\u225c', spacingRequired: true),

    'doteqdot': () => TextNode('\u2251', spacingRequired: true),
    'risingdotseq': () => TextNode('\u2253', spacingRequired: true),
    'fallingdotseq': () => TextNode('\u2252', spacingRequired: true),

    'Doteq': () => TextNode('\u2251', spacingRequired: true),

    'lhd': () => TextNode('\u22b2', spacingRequired: true),
    'vartriangleleft': () => TextNode('\u22b2', spacingRequired: true),
    'rhd': () => TextNode('\u22b3', spacingRequired: true),
    'vartriangleright': () => TextNode('\u22b3', spacingRequired: true),
    'trianglelefteq': () => TextNode('\u22b4', spacingRequired: true),
    'trianglerighteq': () => TextNode('\u22b5', spacingRequired: true),

    'unlhd': () => TextNode('\u22b4', spacingRequired: true),
    'unrhd': () => TextNode('\u22b5', spacingRequired: true),
    'ntriangleleft': () => TextNode('\u22ea', spacingRequired: true),
    'ntrianglelefteq': () => TextNode('\u22ec', spacingRequired: true),
    'ntriangleright': () => TextNode('\u22eb', spacingRequired: true),
    'ntrianglerighteq': () => TextNode('\u22ed', spacingRequired: true),


    // Subsets and Supersets
    'subset': () => TextNode('\u2282'),
    'nsubset': () => TextNode('\u2284'),
    'Subset': () => TextNode('\u22d0'),
    'subseteq': () => TextNode('\u2286'),
    'subsetneq': () => TextNode('\u228a'),
    'varsubsetneq': () => TextNode('\u228a'), //TODO

    'nsubseteq': () => TextNode('\u2288'),
    'subseteqq': () => TextNode('\u2ac5'),
    'subsetneqq': () => TextNode('\u2acb'),
    'varsubsetneqq': () => TextNode('\u2acb'), //TODO
    'nsubseteqq': () => TextNode('\ue016'),

    'supset': () => TextNode('\u2283'),
    'Supset': () => TextNode('\u22d1'),
    'supseteq': () => TextNode('\u2287'),
    'supsetneq': () => TextNode('\u228b'),
    'varsupsetneq': () => TextNode('\u228b'), //TODO
    'nsupseteq': () => TextNode('\u2289'),

    'supseteqq': () => TextNode('\u2ac6'),
    'supsetneqq': () => TextNode('\u2acc'),
    'varsupsetneqq': () => TextNode('\u2acc'), //TODO
    'nsupseteqq': () => TextNode('\ue018'),
    'sqsubset': () => TextNode('\u228f'),
    'sqsubseteq': () => TextNode('\u2291'),
    'sqsupset': () => TextNode('\u2290'),
    'sqsupseteq': () => TextNode('\u2292'),

    'ni': () => TextNode('\u220b'),
    'owns': () => TextNode('\u220b'),
    'forall': () => TextNode('\u2200'),
    'exists': () => TextNode('\u2203'),
    'nexists': () => TextNode('\u2204'),
    'in': () => TextNode('\u200A\u2208\u200A'),
    'notin': () => TextNode('\u2209'),

    'backepsilon': () => TextNode('\u220d'),


    // Arrows
    'leftarrow': () => TextNode('\u2190', spacingRequired: true),
    'longleftarrow': () => TextNode('\u27f5', spacingRequired: true),
    'Leftarrow': () => TextNode('\u21d0', spacingRequired: true),
    'Longleftarrow': () => TextNode('\u27f8', spacingRequired: true),

    'rightarrow': () => TextNode('\u2192', spacingRequired: true),
    'longrightarrow': () => TextNode('\u27f6', spacingRequired: true),
    'Rightarrow': () => TextNode('\u21d2', spacingRequired: true),
    'Longrightarrow': () => TextNode('\u27f9', spacingRequired: true),

    'leftrightarrow': () => TextNode('\u2194', spacingRequired: true),
    'longleftrightarrow': () => TextNode('\u27f7', spacingRequired: true),
    'Leftrightarrow': () => TextNode('\u21d4', spacingRequired: true),
    'Longleftrightarrow': () => TextNode('\u27fa', spacingRequired: true),

    'gets': () => TextNode('\u2190', spacingRequired: true),
    'to': () => TextNode('\u2192'), // can't add spacing, since it is used in too many units
    'mapsto': () => TextNode('\u21a6'), // can't add spacing, since it is used in too many units
    'longmapsto': () => TextNode('\u27fc', spacingRequired: true),

    'nearrow': () => TextNode('\u2197', spacingRequired: true),
    'searrow': () => TextNode('\u2198', spacingRequired: true),
    'swarrow': () => TextNode('\u2199', spacingRequired: true),
    'nwarrow': () => TextNode('\u2196', spacingRequired: true),

    'hookleftarrow': () => TextNode('\u21a9', spacingRequired: true),
    'hookrightarrow': () => TextNode('\u21aa', spacingRequired: true),

    'leftharpoonup': () => TextNode('\u21bc', spacingRequired: true),
    'rightharpoonup': () => TextNode('\u21c0', spacingRequired: true),
    'leftharpoondown': () => TextNode('\u21bd', spacingRequired: true),
    'rightharpoondown': () => TextNode('\u21c1', spacingRequired: true),
    'rightleftharpoons': () => TextNode('\u21cc', spacingRequired: true),

    'uparrow': () => TextNode('\u2191', spacingRequired: true),
    'Uparrow': () => TextNode('\u21d1', spacingRequired: true),
    'downarrow': () => TextNode('\u2193', spacingRequired: true),
    'Downarrow': () => TextNode('\u21d3', spacingRequired: true),
    'updownarrow': () => TextNode('\u2195', spacingRequired: true),
    'Updownarrow': () => TextNode('\u21d5', spacingRequired: true),

    'dashrightarrow': () => TextNode('\u21e2', spacingRequired: true),
    'dashleftarrow': () => TextNode('\u21e0', spacingRequired: true),
    'leftleftarrows': () => TextNode('\u21c7', spacingRequired: true),
    'leftrightarrows': () => TextNode('\u21c6', spacingRequired: true),
    'Lleftarrow': () => TextNode('\u21da', spacingRequired: true),
    'Rrightarrow': () => TextNode('\u21db', spacingRequired: true),
    'twoheadleftarrow': () => TextNode('\u219e', spacingRequired: true),

    'nleftarrow': () => TextNode('\u219a', spacingRequired: true),
    'nrightarrow': () => TextNode('\u219b', spacingRequired: true),
    'nLeftarrow': () => TextNode('\u21cd', spacingRequired: true),
    'nRightarrow': () => TextNode('\u21cf', spacingRequired: true),
    'nleftrightarrow': () => TextNode('\u21ae', spacingRequired: true),
    'nLeftrightarrow': () => TextNode('\u21ce', spacingRequired: true),

    'leftarrowtail': () => TextNode('\u21a2', spacingRequired: true),
    'looparrowleft': () => TextNode('\u21ab', spacingRequired: true),
    'leftrightharpoons': () => TextNode('\u21cb', spacingRequired: true),
    'curvearrowleft': () => TextNode('\u21b6', spacingRequired: true),
    'circlearrowleft': () => TextNode('\u21ba', spacingRequired: true),
    'Lsh': () => TextNode('\u21b0', spacingRequired: true),
    'upuparrows': () => TextNode('\u21c8', spacingRequired: true),
    'upharpoonleft': () => TextNode('\u21bf', spacingRequired: true),
    'downharpoonleft': () => TextNode('\u21c3', spacingRequired: true),

    'leftrightsquigarrow': () => TextNode('\u21ad', spacingRequired: true),
    'rightrightarrows': () => TextNode('\u21c9', spacingRequired: true),
    'rightleftarrows': () => TextNode('\u21c4', spacingRequired: true),
    'twoheadrightarrow': () => TextNode('\u21a0', spacingRequired: true),
    'rightarrowtail': () => TextNode('\u21a3', spacingRequired: true),
    'looparrowright': () => TextNode('\u21ac', spacingRequired: true),
    'curvearrowright': () => TextNode('\u21b7', spacingRequired: true),
    'circlearrowright': () => TextNode('\u21bb', spacingRequired: true),
    'Rsh': () => TextNode('\u21b1', spacingRequired: true),
    'downdownarrows': () => TextNode('\u21ca', spacingRequired: true),
    'upharpoonright': () => TextNode('\u21be', spacingRequired: true),
    'downharpoonright': () => TextNode('\u21c2', spacingRequired: true),
    'rightsquigarrow': () => TextNode('\u21dd', spacingRequired: true),
    'leadsto': () => TextNode('\u21dd', spacingRequired: true),
    'restriction': () => TextNode('\u21be', spacingRequired: true),

    'multimap': () => TextNode('\u22b8', spacingRequired: true),

    // Others
    'aleph': () => TextNode('\u2135'),
    'wp': () => TextNode('\u2118'),
    'Re': () => TextNode('\u211c'),
    'Im': () => TextNode('\u2111'),

    'clubsuit': () => TextNode('\u2663'),
    'diamondsuit': () => TextNode('\u2662'),
    'heartsuit': () => TextNode('\u2661'),
    'spadesuit': () => TextNode('\u2660'),
    'diamond': () => TextNode('\u22c4'),
    'star': () => TextNode('\u22c6'),

    'natural': () => TextNode('\u266e'),
    'sharp': () => TextNode('\u266f'),
    'hbar': () => TextNode('\u210f'),
    'hslash': () => TextNode('\u210f'),

    'nabla': () => TextNode('\u2207'),
    'partial': () => TextNode('\u2202'),
    'flat': () => TextNode('\u266d'),
    'ell': () => TextNode('\u2113'),

    'dag': () => TextNode('\u2020'),
    'dagger': () => TextNode('\u2020'),
    'ddag': () => TextNode('\u2021'),
    'ddagger': () => TextNode('\u2021'),

    'rmoustache': () => TextNode('\u23b1'),
    'lmoustache': () => TextNode('\u23b0'),
    'wr': () => TextNode('\u2240'),
    'amalg': () => TextNode('\u2a3f'),

    'imath': () => TextNode('\u0131'),
    'jmath': () => TextNode('\u0237'),
    'maltese': () => TextNode('\u2720'),

    'pounds': () => TextNode('\u00a3'),
    'mathsterling': () => TextNode('\u00a3'),
    'yen': () => TextNode('\u00a5'),
    'euro': () => TextNode('\u20ac'),

    'S': () => TextNode('\u00a7'),
    'P': () => TextNode('\u00b6'),


    // Others 2
    'perp': () => TextNode('\u22a5'),
    'vdash': () => TextNode('\u22a2'),
    'nvdash': () => TextNode('\u22ac'),

    'dashv': () => TextNode('\u22a3'),

    'top': () => TextNode('\u22a4'),
    'bot': () => TextNode('\u22a5'),

    'vDash': () => TextNode('\u22a8'),
    'models': () => TextNode('\u22a8'),
    'nvDash': () => TextNode('\u22ad'),

    'Vdash': () => TextNode('\u22a9'),
    'nVDash': () => TextNode('\u22af'),

    'nVdash': () => TextNode('\u22ae'),
    'Vvdash': () => TextNode('\u22aa'),

    'uplus': () => TextNode('\u228e'),
    'sqcap': () => TextNode('\u2293'),
    'ast': () => TextNode('\u2217'),
    'sqcup': () => TextNode('\u2294'),

    'mid': () => TextNode('\u2223'),
    'nmid': () => TextNode('\u2224'),
    'parallel': () => TextNode('\u2225'),
    'nparallel': () => TextNode('\u2226'),
    'nshortparallel': () => TextNode('\ue007'),
    'lvert': () => TextNode('\u2223'),
    'lVert': () => TextNode('\u2225'),
    'rvert': () => TextNode('\u2223'),
    'rVert': () => TextNode('\u2225'),
    'vert': () => TextNode('\u2223'),
    'Vert': () => TextNode('\u2225'),
    'shortmid': () => TextNode('\u2223'),
    'shortparallel': () => TextNode('\u2225'),
    'lfloor': () => TextNode('\u230a'),
    'rfloor': () => TextNode('\u230b'),
    'lceil': () => TextNode('\u2308'),
    'rceil': () => TextNode('\u2309'),

    'ulcorner': () => TextNode('\u250c'),
    'urcorner': () => TextNode('\u2510'),
    'llcorner': () => TextNode('\u2514'),
    'lrcorner': () => TextNode('\u2518'),

    'asymp': () => TextNode('\u224d'),
    'bowtie': () => TextNode('\u22c8'),
    'Join': () => TextNode('\u22c8'),
    'smile': () => TextNode('\u2323'),
    'frown': () => TextNode('\u2322'),
    'smallsmile': () => TextNode('\u2323'),
    'smallfrown': () => TextNode('\u2322'),

    'circ': () => TextNode('\u2218'),
    'bigcirc': () => TextNode('\u25ef'),
    'angle': () => TextNode('\u2220'),
    'triangle': () => TextNode('\u25b3'),
    'vartriangle': () => TextNode('\u25b3'),

    'triangledown': () => TextNode('\u25bd'),
    'bigtriangleup': () => TextNode('\u25b3'),
    'bigtriangledown': () => TextNode('\u25bd'),
    'triangleleft': () => TextNode('\u25c3'),
    'triangleright': () => TextNode('\u25b9'),

    'blacktriangle': () => TextNode('\u25b2'),
    'blacktriangledown': () => TextNode('\u25bc'),
    'blacktriangleleft': () => TextNode('\u25c0'),
    'blacktriangleright': () => TextNode('\u25b6'),
    'blacksquare': () => TextNode('\u25a0'),
    'lozenge': () => TextNode('\u25ca'),
    'blacklozenge': () => TextNode('\u29eb'),
    'bigstar': () => TextNode('\u2605'),

    'square': () => TextNode('\u25a1'),
    'Box': () => TextNode('\u25a1'),
    'Diamond': () => TextNode('\u25ca'),


    // Others 3
    'infty': () => TextNode('\u221e'),
    'prime': () => TextNode('\u2032'),
    'backprime': () => TextNode('\u2035'),
    'acute': () => TextNode('\u02ca'),
    'grave': () => TextNode('\u02cb'),
    'breve': () => TextNode('\u02d8'),
    'check': () => TextNode('\u02c7'),
    'degree': () => TextNode('\u00b0'),
    'mathring': () => TextNode('\u02da'),

    'neg': () => TextNode('\u00ac'),
    'lnot': () => TextNode('\u00ac'),

    'empty': () => TextNode('\u2205'),
    'emptyset': () => TextNode('\u2205'),
    'varnothing': () => TextNode('\u2205'),

    'cap': () => TextNode('\u22c2'),
    'cup': () => TextNode('\u22c3'),
    'Cap': () => TextNode('\u22d2'),
    'Cup': () => TextNode('\u22d3'),
    'doublecap': () => TextNode('\u22d2'),
    'doublecup': () => TextNode('\u22d3'),
    'setminus': () => TextNode('\u2216'),
    'smallsetminus': () => TextNode('\u2216'),
    'backslash': () => TextNode(r'\'),
    'not': () => TextNode('\ue020'),
    'land': () => TextNode('\u2227'),
    'lor': () => TextNode('\u2228'),
    'wedge': () => TextNode('\u2227'),
    'vee': () => TextNode('\u2228'),
    'surd': () => TextNode('\u221a'),
    'langle': () => TextNode('\u27e8'),
    'rangle': () => TextNode('\u27e9'),

    'oplus': () => TextNode('\u2295'),
    'ominus': () => TextNode('\u2296'),
    'odot': () => TextNode('\u2299'),
    'otimes': () => TextNode('\u2297'),
    'oslash': () => TextNode('\u2298'),

    'circleddash': () => TextNode('\u229d'),
    'circledast': () => TextNode('\u229b'),
    'circledcirc': () => TextNode('\u229a'),
    'boxminus': () => TextNode('\u229f'),
    'boxplus': () => TextNode('\u229e'),
    'boxdot': () => TextNode('\u22a1'),
    'boxtimes': () => TextNode('\u22a0'),


    // Others 4
    'circledS': () => TextNode('\u24c8'),
    'circledR': () => TextNode('\u00ae'),
    'measuredangle': () => TextNode('\u2221'),
    'sphericalangle': () => TextNode('\u2222'),
    'varangle': () => TextNode('\u2222'), // TODO

    'mho': () => TextNode('\u2127'),
    'Finv': () => TextNode('\u2132'),
    'Game': () => TextNode('\u2141'),

    'complement': () => TextNode('\u2201'),
    'eth': () => TextNode('\u00f0'),
    'diagup': () => TextNode('\u2571'),
    'diagdown': () => TextNode('\u2572'),

    'checkmark': () => TextNode('\u2713'),
    'beth': () => TextNode('\u2136'),
    'daleth': () => TextNode('\u2138'),
    'gimel': () => TextNode('\u2137'),
    'digamma': () => TextNode('\u03dd'),

    'bumpeq': () => TextNode('\u224f'),
    'Bumpeq': () => TextNode('\u224e'),

    'between': () => TextNode('\u226c'),
    'pitchfork': () => TextNode('\u22d4'),

    'dotplus': () => TextNode('\u2214'),
    'divideontimes': () => TextNode('\u22c7'),
    'ltimes': () => TextNode('\u22c9'),
    'rtimes': () => TextNode('\u22ca'),
    'leftthreetimes': () => TextNode('\u22cb'),
    'rightthreetimes': () => TextNode('\u22cc'),

    'barwedge': () => TextNode('\u22bc'),
    'veebar': () => TextNode('\u22bb'),
    'doublebarwedge': () => TextNode('\u2a5e'),
    'curlywedge': () => TextNode('\u22cf'),
    'curlyvee': () => TextNode('\u22ce'),

    'intercal': () => TextNode('\u22ba'),

    // Set of numbers
    'N': () => TextNode('N', font: AmsLatexFont(), textType: TextType.upperCase),
    'Z': () => TextNode('Z', font: AmsLatexFont(), textType: TextType.upperCase),
    'Q': () => TextNode('Q', font: AmsLatexFont(), textType: TextType.upperCase),
    'R': () => TextNode('R', font: AmsLatexFont(), textType: TextType.upperCase),
    'C': () => TextNode('C', font: AmsLatexFont(), textType: TextType.upperCase),
    'H': () => TextNode('H', font: AmsLatexFont(), textType: TextType.upperCase),
  };

}