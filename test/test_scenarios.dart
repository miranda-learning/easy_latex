Map<String, dynamic> get easyLatexTestScenarios => {
  'renderTests': {
    'locale': {

      r'decimal en': {
        'text': r'.3 \ 3. \ 2.3',
        'locale': 'en',
      },

      r'decimal de': {
        'text': r'.3 \ 3. \ 2.3',
        'locale': 'de',
      },

      r'comma en': {
        'text': r'2\comma 3',
        'locale': 'en',
      },

      r'comma de': {
        'text': r'2\comma 33',
        'locale': 'de',
      },

      r'allPoints en': {
        'text': r'...',
        'allPointsAsDecimalPoints': true,
        'locale': 'en',
      },

      r'allPoints de': {
        'text': r'...',
        'allPointsAsDecimalPoints': true,
        'locale': 'de',
      },

    },
    'fontSize': {

      r'fontSize 28': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 28.0},
      r'fontSize 26': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 26.0},
      r'fontSize 24': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 24.0},
      r'fontSize 22': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 22.0},
      r'fontSize 20': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 20.0},
      r'fontSize 18': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 18.0},
      r'fontSize 16': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 16.0},
      r'fontSize 14': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 14.0},
      r'fontSize 12': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 12.0},
      r'fontSize 10': {'text': 'a1b2c3d4e5f6g7h8i9j0', 'fontSize': 10.0},

    },
    'singleChar': {
      r'singleChar 1':             r'a{b}c[d]e(f)g',
      r'singleChar 2':             r'1+2-3*4/5=6?7!8',
      r'singleChar 3':             r': ><~|`,;&°',
    },
    'subSuper': {
      r'sub super 1':             r'1^2 a^2 b^2 A^2 x_2 x^2_2 x_1 x^{\frac{1}{1}} x_2^{\frac{1}{1}} x^{\sqrt[4]{1}} x_2^{\frac{1}{1}}',
      r'sub super 2':             r'^14_{~\;6}C - ^235_{~\;92}U = ^14C',
      r'sub super 3':             r'\int_x^2 \int^x_2 \int_x \int^2 \int_x^M 1_x^2 x_x^2 M_x^2 x dx',
    },
    'newlines': {
      // with \\
      r'newline with \\ 1':     r'\frac{4}{3} \\ + 3 \\ + 3 + 4\\3',
      r'newline with \\ 2':     r'\left( \frac{4}{3} \\ + 3 \\ + 3 + 4\\3 \right) \frac{4\\3}{3}',

      r'wrapMode simple 1': {
        'text': r'1000 + 2000 + 3000 + 4000 + 5000 \Rightarrow 6000 + 7000 + 8000 \Rightarrow 6000 + 7000 + 8000',
        'wrapMode': 'simple',
      },

      r'wrapMode simple 2': {
        'text':  r'(1000 + 2000 + 3000 + 4000) + (5000 + 6000 + 7000 + 8000 + 6000 + 7000 + 8000)',
        'wrapMode': 'simple',
      },

      r'wrapMode smart 1': {
        'text': r'1000 + 2000 + 3000 + 4000 + 5000 \Rightarrow 6000 + 7000 + 8000 \Rightarrow 6000 + 7000 + 8000',
        'wrapMode': 'smart',
      },

      r'wrapMode smart 2': {
        'text': r'1000 + 2000 + 3000 + 4000 + 5000 = 6000 + 7000 + 8000',
        'wrapMode': 'smart',
      },

      r'wrapMode smart 3': {
        'text': r'1000 + 2000 + 3000 + 4000 + 5000 + 6000 + 7000 + 8000',
        'wrapMode': 'smart',
      },

      r'wrapMode smart 4': {
        'text': r'(1000 + 2000 + 3000 + 4000 + 5000) (6000 + 7000 + 8000)',
        'wrapMode': 'smart',
      },

      r'align right with \\': {
        'text': r'1000 + 2000 + 3000 + 4000 \\ + 5000 + \\ 6000 + 7000 + 8000',
        'textAlign': 'right',
      },

      r'align left simple': {
        'text':  r'1000 + 2000 + 3000 + 4000 + 5000 + 6000 + 7000 + 8000',
        'wrapMode': 'simple',
        'textAlign': 'left',
      },

      r'align center simple': {
        'text':  r'1000 + 2000 + 3000 + 4000 + 5000 + 6000 + 7000 + 8000',
        'wrapMode': 'simple',
        'textAlign': 'center',
      },

      r'align right simple': {
        'text':  r'1000 + 2000 + 3000 + 4000 + 5000 + 6000 + 7000 + 8000',
        'wrapMode': 'simple',
        'textAlign': 'right',
      },

    },
    'custom': {

      r'\comma': r'2 \comma 2',
      r'\listcomma': r'2 \listcomma 2',
      r'\minus': r'\minus2 -2',

      r'\placeholder': r'\placeholder \dashplaceholder \redplaceholder',

      r'\matrix': r'\matrix{ 1 & 2 \\ 3 & 4}',
      r'\pmatrix': r'\pmatrix{ 1 & 2 \\ 3 & 4}',
      r'\bmatrix1': r'\bmatrix{ 1 & 2 \\ 3 & 4}',
      r'\Bmatrix2': r'\Bmatrix{ 1 & 2 \\ 3 & 4}',

    },
    'brackets': {

      r'brackets 1': r'(\frac{1}{2}) '
      r'\left( \frac{1}{2} \right) '
      r'\left{ \frac{1}{2} \right} \{ \frac{1}{2} \}'
      r'[ \frac{1}{2} ] \left[ \frac{1}{2} \right] \[ \frac{1}{2} \]',

      r'brackets 2': r'\llbracket 5 \rrbracket \llbracket \frac{1}{2} \rrbracket',

      r'brackets 3': r'\lparen 5 \rparen \[5\] \lbrack 5 \rbrack \{5\} \lbrace 5 \rbrace \lgroup 5 \rgroup',
      r'brackets 4': r'[a; b)',

      r'cases':r'x = \cases{3 \ \text{für} \ 0 < x < 1 \\ 3 \\ 3 \\ 3}',

      r'norm 1': r'|1| \big| \Big| \bigg| \Bigg|',
      r'norm 2': r'|1| \big| \frac{1}{1} \big|',
      r'norm 3': r'|1| \Big| \frac{1}{1} \Big|',
      r'norm 4': r'|1| \bigg| \frac{1}{1} \bigg|',
      r'norm 5': r'|1| \Bigg| \frac{1}{1} \Bigg|',
      r'norm 6': r'|_a^b \big|_a^b \Big|_a^b \bigg|_a^b \Bigg|_a^b',

    },
    'decoration': {
      // top
      r'\bar{}':                  r'\bar{5}, \bar{55}, \bar{555}, \bar{55555}, \bar{a} \bar{ä} \bar{f}',
      r'\dot{}':                  r'\dot{5}, \dot{55}, \dot{555}, \dot{55555}, \dot{a} \dot{ä} \dot{f}',
      r'\ddot{}':                 r'\ddot{5}, \ddot{55}, \ddot{555}, \ddot{55555}, \ddot{a} \ddot{ä} \ddot{f}',
      r'\dddot{}':                r'\dddot{5}, \dddot{55}, \dddot{555}, \dddot{55555}, \dddot{a} \dddot{ä} \dddot{f}',
      r'\hat{}':                  r'\hat{5}, \hat{55}, \hat{555}, \hat{55555}, \hat{a} \hat{ä} \hat{f}',
      r'\overbrace{}':            r'\overbrace{5}, \overbrace{55}, \overbrace{555}, \overbrace{55555}, \overbrace{a} \overbrace{ä} \overbrace{f}',
      r'\overline{}':             r'\overline{5}, \overline{55}, \overline{555}, \overline{55555}, \overline{a} \overline{ä} \overline{f}',
      r'\overleftarrow{}':        r'\overleftarrow{5}, \overleftarrow{55}, \overleftarrow{555}, \overleftarrow{55555}, \overleftarrow{a} \overleftarrow{ä} \overleftarrow{f}',
      r'\overleftrightarrow{}':   r'\overleftrightarrow{5}, \overleftrightarrow{55}, \overleftrightarrow{555}, \overleftrightarrow{55555}, \overleftrightarrow{a} \overleftrightarrow{ä} \overleftrightarrow{f}',
      r'\overrightarrow{}':       r'\overrightarrow{5}, \overrightarrow{55}, \overrightarrow{555}, \overrightarrow{55555}, \overrightarrow{a} \overrightarrow{ä} \overrightarrow{f}',
      r'\tilde{}':                r'\tilde{5}, \tilde{55}, \tilde{555}, \tilde{55555}, \tilde{a} \tilde{ä} \tilde{f}',
      r'\vec{}':                  r'\vec{5}, \vec{55}, \vec{555}, \vec{55555}, \vec{a} \vec{ä} \vec{f}',
      r'\widehat{}':              r'\widehat{5}, \widehat{55}, \widehat{555}, \widehat{55555}, \widehat{aa} \widehat{ä} \widehat{f}',
      r'\widetilde{}':            r'\widetilde{5}, \widetilde{55}, \widetilde{555}, \widetilde{55555}, \widetilde{a} \widetilde{ä} \widetilde{f}',

      // bottom
      r'\underbrace{}':           r'\underbrace{5}, \underbrace{55}, \underbrace{555}, \underbrace{55555}, \underbrace{aaa} \underbrace{fff} \underbrace{\text{fff}} \underbrace{ggg}',
      r'\underline{}':            r'\underline{5}, \underline{55}, \underline{555}, \underline{55555}, \underline{a} \underline{ä} \underline{fff} \underline{\text{fff}} \underline{ggg}',

      // color
      r'\color{}':                r'\color{98CC70} \pi \sqrt{\color{red} 2} \pi \color{blue} \pi \color{apricot} 123.5 \color{mulberry} 123.5',
    },
    'fonts': {
      r'italic upper':          r'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      r'italic lower':          r'abcdefghijklmnopqrstuvwxyzäöü',

      r'regular upper':         r'\text{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'regular lower':         r'\text{abcdefghijklmnopqrstuvwxyzäöü}',
      r'regular digits':        r'0123456789',

      r'bold upper':            r'\bm{ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ}',
      r'bold lower':            r'\bm{abcdefghijklmnopqrstuvwxyzäöü}',
      r'bold digits':           r'\bm{0123456789}',

      r'mathbb upper':          r'\mathbb{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'mathbb lower':          r'\mathbb{k}',

      r'mathcal upper':         r'\mathcal{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',

      r'mathfrak upper':        r'\mathfrak{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'mathfrak lower':        r'\mathfrak{abcdefghijklmnopqrstuvwxyz}',
      r'mathfrak digits':       r'\mathfrak{0123456789}',

      r'mathscr upper':         r'\mathscr{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',

      r'mathtt upper':          r'\mathtt{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'mathtt lower':          r'\mathtt{abcdefghijklmnopqrstuvwxyz}',
      r'mathtt digits':         r'\mathtt{0123456789}',

      r'\text{}':               r'\text{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\textrm{}':             r'\textrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\mathrm{}':             r'\mathrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\operatorname{}':       r'\operatorname{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\mathbf{}':             r'\mathbf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\boldsymbol{}':         r'\boldsymbol{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
      r'\bm{}':                 r'\bm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}',
    },
    'limProdSum': {

      // bigwedge
      r'\big':                    r'\bigcap_n^a \bigcup_n^a \bigodot_n^a \bigoplus_n^a \bigotimes_n^a \bigsqcup_n^a \biguplus_n^a \bigvee_n^a \bigwedge_n^a',

      // coprod
      r'\coprod':                 r'a \coprod b \coprod{i = 1} c \coprod^{n} d \coprod{i = 1}^{n} e \coprod^{n}_{i = 1} f',

      // sum, prod, lim
      r'\lim':                    r'a \lim b \lim_{a \to \infty} c \lim^{a \to \infty} d \lim_{a \to \infty}^{a \to \infty} e \lim^{a \to \infty}_{a \to \infty} f',
      r'\prod':                   r'a \prod b \prod_{i = 1} c \prod^{n} d \prod_{i = 1}^{n} e \prod^{n}_{i = 1} f',
      r'\sum':                    r'a \sum b \sum_{i = 1} c \sum^{n} d \sum_{i = 1}^{n} e \sum^{n}_{i = 1} f',

    },
    'integral': {
      r'\int':                    r'\int_1^2 \iint_1^2 \iiint_1^2 \iiiint_1^2 \intop_1^2', // TODO intop not correctly implemented yet
      r'\oint':                   r'\oint_1^2 \oiint_1^2 \oiiint_1^2 \oiiiint_1^2',
      r'\smallint':               r'\smallint_1^2 \intinline_1^2', // TODO smallint not correctly implemented yet
    },
    'matrix': {
      r'matrix 1':              r'\matrix{3} \pmatrix{3} \bmatrix{3} \Bmatrix{3} \matrix{3 \\ 3 } \pmatrix{3 \\ 3 } \bmatrix{3 \\ 3 } \Bmatrix{3 \\ 3 }',
      r'matrix 2':              r'\matrix{3 \\ 3 \\ 3} \pmatrix{3 \\ 3 \\ 3} \bmatrix{3 \\ 3 \\ 3} \Bmatrix{3 \\ 3 \\ 3} \pmatrix{3 \\ 3 \\ 3 \\ 3} \bmatrix{3 \\ 3 \\ 3 \\ 3} \Bmatrix{3 \\ 3 \\ 3 \\ 3}',
      r'matrix 3':              r'\matrix{3 & 313 \\ 313 & 3} \pmatrix{3 & 313 \\ 313 & 3} \bmatrix{3 & 313 \\ 3 & 3} \Bmatrix{3 & 313 \\ 313 & 3}',

      r'matrix vs begin{}':     r'\matrix{3 & 3 \\ 3 & 3} \begin{matrix}3 & 3 \\ 3 & 3\end{matrix} \pmatrix{3 & 3 \\ 3 & 3} \begin{pmatrix}3 & 3 \\ 3 & 3\end{pmatrix} \bmatrix{3 & 3 \\ 3 & 3} \begin{bmatrix}3 & 3 \\ 3 & 3\end{bmatrix} \Bmatrix{3 & 3 \\ 3 & 3} \begin{Bmatrix}3 & 3 \\ 3 & 3\end{Bmatrix}',

      r'empty entries':         r'\pmatrix{3 & 3 \\ 3 & 3} \pmatrix{3 & 3 \\  & 3} \pmatrix{ & 3 \\  & 3} \pmatrix{ 3 &  \\  & } \pmatrix{  &  \\  & } \pmatrix{ 3 \\ } \pmatrix{ 3 } \pmatrix{ }',
    },
    'binomFracSqrt': {
      // sqrt
      r'\sqrt{} 1':               r'xA \sqrt{2} \sqrt{a} \sqrt{ä} \sqrt{b} \sqrt{g} \sqrt{A} \sqrt{B}',
      r'\sqrt{} 2':               r'\sqrt{\bar{x}} \sqrt{\bar{2}} \sqrt{\bar{A}} \sqrt{\bar{Wx}} \sqrt{\frac{x}{x}} \sqrt{\frac{2}{2}} \minus \sqrt{\minus\frac{2}{2}}',
      r'\sqrt{} 3':               r'\sqrt[4]{2} \sqrt[404]{2} \sqrt[40404]{2}',

      // frac
      r'\frac{} 1':               r'a\frac{2}{2}b\frac{\frac{2}{2}}{2}c\frac{\frac{\frac{2}{2}}{2}}{2} d \frac{2}{2}b\frac{2}{\frac{2}{2}} e \frac{2}{\frac{\frac{2}{2}}{2}}',
      r'\frac{} 3':               r'\sqrt{2} \sqrt{\frac{2}{2}} \sqrt{\frac{\frac{2}{2}}{2}} \sqrt{\frac{2}{\frac{\frac{2}{2}}{2}}}',
      r'\frac{} 4':               r'a\frac{ag}{ag} b \frac{A\sqrt{2}g}{A\sqrt{2}g} c',

      // binom
      r'\binom{}':               r'a \binom{ag}{ag} b',

    },
    'symbols': {
      r'symbols 1': r'+-*/=?!:><|`',
      r'symbols 2': r'\# \& \And \$ \% \permil \_ \| \colon',
      r'symbols 3': r'\div \pm \mp \times \And',
      r'primes 1': r"V' V'' V''' V'''''''' f' f'' f''' Y' W' T'",
    },
    'spaces': {
      r'spaces 1': r'-\,-\ \backslash ,',
      r'spaces 2': r'-\;-\ \backslash ;',
      r'spaces 3': r'-~-\ \sim',
      r'spaces 4': r'-\ -\ \backslash(space)',
      r'spaces 5': r'-\nobreakspace-\ \backslash nobreakspace',
      r'spaces 6': r'-\quad-\ \backslash quad',
      r'spaces 7': r'-\qquad-\ \backslash qquad',
    },
    'greek': {
      r'greek upper':             r'\Alpha \Beta \Gamma \Delta \Epsilon \Zeta \Eta \Theta \Iota \Kappa \Lambda \Mu \Nu \Xi \Omicron \Pi \Rho \Sigma \Tau \Upsilon \Phi \Chi \Psi \Omega',
      r'greek lower':             r'\alpha \beta \gamma \delta \epsilon \zeta \eta \theta \iota \kappa \lambda \mu \nu \xi \omicron \pi \rho \sigma \tau \upsilon \phi \chi \psi \omega',
      r'greek var':               r'\varepsilon \vartheta \varkappa \varpi \varrho \varsigma \varphi',
    },
    'functions': {
      r'\min, \max, \sup, \inf':        r'\min(4, 5) \  \max(4, 5) \  \sup \  \inf',
      r'\limsup, \liminf':              r'\limsup(x) \  \liminf(x)',
      r'\exp, \log, \ln, \lg':          r'\exp(x) \  \log(x) \  \ln(x) \  \lg(x)',
      r'\sin, \cos, \tan':              r'\sin(x) \  \cos(x) \  \tan(x)',
      r'\sec, \csc, \cot':              r'\sec(x) \  \csc(x) \  \cot(x)',
      r'\arcsin, \arccos, \arctan':     r'\arcsin(x) \  \arccos(x) \  \arctan(x)',
      r'\arcsec, \arccsc, \arccot':     r'\arcsec(x) \  \arccsc(x) \  \arccot(x)',
      r'\sinh, \cosh, \tanh, \coth':    r'\sinh(x) \  \cosh(x) \  \tanh(x) \  \coth(x)',
      r'\nCr, \mod':                    r'\nCr(x) \  \mod(x)',
      r'\arg, \sgn, \deg, \dim':        r'\arg \  \sgn \  \deg \  \dim',
      r'\hom, \ker, \gcd, \det, \Pr':   r'\hom \  \ker \  \gcd \  \dim \  \Pr',
    },
    'latexCommands': {
      // Special letters
      r'cmd 1': r'\AA \mathrm{\AA}',

      // Dots
      r'cmd 2': r'\dots - \vdots - \varvdots - \cdot - \cdotp - \cdots \cdots',
      r'cmd 3': r'\dots - \cdots - \dotsb - \dotsc - \dotsm - \dotsi-  \dotso',
      r'cmd 4': r'\centerdot - \ldots - \ldotp - \ddots',
      r'cmd 5': r'\mathellipsis - \bullet - \therefore - \because',

      // Comparing
      r'cmd 6': r'a = b \coloneqq c \ne c \neq d \equiv e \doteq f',
      r'cmd 7': r'a \approx b \thickapprox c \approxeq c\cong d',

      r'cmd 8': r'a \sim b \thicksim c \simeq d',
      r'cmd 9': r'a \propto b \varpropto c',

      r'cmd 10': r'a \lt b \le c \leq d \ll e',
      r'cmd 11': r'a \gt b \ge c \geq d \gg e',

      r'cmd 12': r'a \nless b \nleqslant c \nleqq d \lneq e \lneqq f',
      r'cmd 13': r'a \ngtr b \ngeqslant c \ngeqq d \gneq e \gneqq f',

      r'cmd 14': r'a \preceq b \prec c \succeq d \succ e',

      r'cmd 15': r'a \leqq b \leqslant c \eqslantless d \lesssim e \lessapprox f \lessdot g',
      r'cmd 16': r'a \geqq b \geqslant c \eqslantgtr d \gtrsim e \gtrapprox f \gtrdot g',

      r'cmd 17': r'a \lessgtr b \lesseqgtr c \lesseqqgtr d \gtrless e \gtreqless f \gtreqqless g',

      r'cmd 18': r'a \ngeq b \nleq c',

      r'cmd 19': r'a \lll b \llless c \gggtr d \ggg e',
      r'cmd 20': r'a \preccurlyeq b \curlyeqprec c \precsim d \precapprox e',
      r'cmd 21': r'a \succcurlyeq b \curlyeqsucc c \succsim d \succapprox e',

      r'cmd 22': r'a \lvertneqq b \lnsim c \lnapprox d \nprec e \npreceq f \precnsim g \precnapprox h',
      r'cmd 23': r'a \gvertneqq b \gnsim c \gnapprox d \nsucc e \nsucceq f \succnsim g \succnapprox h',

      r'cmd 24': r'a \precneqq b \succneqq c',

      r'cmd 25': r'a \nsim b \nshortmid c \ncong d \backsim e \backsimeq f \eqsim g',
      r'cmd 26': r'a \eqcirc b \circeq c \triangleq d \doteqdot e \risingdotseq f \fallingdotseq g \Doteq i',

      r'cmd 27': r'a \lhd b \vartriangleleft c \rhd d \vartriangleright e \trianglelefteq f \trianglerighteq g',
      r'cmd 28': r'a \unlhd b \unrhd c \ntriangleleft d \ntrianglelefteq e \ntriangleright f \ntrianglerighteq g',

      // Subsets and Supersets
      r'cmd 29': r'A \subset B \nsubset C \Subset D \subseteq E \subsetneq F \varsubsetneq G',
      r'cmd 30': r'A \nsubseteq B \subseteqq C \subsetneqq D \varsubsetneqq E \nsubseteqq E',
      r'cmd 31': r'A \supset B \Supset C \supseteq D \supsetneq E \varsupsetneq F \nsupseteq G',
      r'cmd 32': r'A \supseteqq B \supsetneqq C \varsupsetneqq D \nsupseteqq E',
      r'cmd 33': r'A \sqsubset B \sqsupset C \sqsubseteq D \sqsupseteq E',
      r'cmd 34': r'A \ni B \owns C \forall D \exists E \in F \notin G',

      r'cmd 35': r'\nexists \backepsilon',

      // Arrows
      r'cmd 36': r'\leftarrow \longleftarrow \Leftarrow \Longleftarrow',
      r'cmd 37': r'\rightarrow \longrightarrow \Rightarrow \Longrightarrow',

      r'cmd 38': r'\leftrightarrow \longleftrightarrow \Leftrightarrow \Longleftrightarrow',

      r'cmd 39': r'\to \gets \mapsto \longmapsto',
      r'cmd 40': r'\nearrow \searrow \swarrow \nwarrow',
      r'cmd 41': r'\hookleftarrow \hookrightarrow',

      r'cmd 42': r'\leftharpoonup \rightharpoonup \leftharpoondown \rightharpoondown \rightleftharpoons',
      r'cmd 43': r'\uparrow \Uparrow \downarrow \Downarrow \updownarrow \Updownarrow',
      r'cmd 44': r'\dashrightarrow \dashleftarrow \leftleftarrows \leftrightarrows \Lleftarrow \Rrightarrow \twoheadleftarrow',
      r'cmd 45': r'\nleftarrow \nrightarrow \nLeftarrow \nRightarrow \nleftrightarrow \nLeftrightarrow',

      r'cmd 46': r'\leftarrowtail \looparrowleft \leftrightharpoons',
      r'cmd 47': r'\curvearrowleft \circlearrowleft \Lsh',
      r'cmd 48': r'\upuparrows \upharpoonleft \downharpoonleft \multimap',
      r'cmd 49': r'\leftrightsquigarrow \rightrightarrows \rightleftarrows',
      r'cmd 50': r'\twoheadrightarrow \rightarrowtail \looparrowright \curvearrowright \circlearrowright',
      r'cmd 51': r'\Rsh \downdownarrows \upharpoonright \downharpoonright \rightsquigarrow \leadsto \restriction',

      // Others
      r'cmd 52': r'\aleph \wp \Re \Im',
      r'cmd 53': r'\clubsuit \diamondsuit \heartsuit \spadesuit \diamond \star',
      r'cmd 54': r'\natural \sharp \hbar \hslash',
      r'cmd 55': r'\nabla \partial \flat\ell',
      r'cmd 56': r'\dag \dagger \ddag \ddagger',
      r'cmd 57': r'\rmoustache \lmoustache \wr \amalg',
      r'cmd 58': r'\imath \jmath \maltese',
      r'cmd 59': r'\pounds \mathsterling \yen \euro',
      r'cmd 60': r'\S \P',

      // Others 2
      r'cmd 61': r'\perp \vdash \nvdash \dashv \top \bot \vDash \models \nvDash',
      r'cmd 62': r'\Vdash \nVdash \Vvdash \nVDash',

      r'cmd 63': r'\uplus \sqcap \ast \sqcup',

      r'cmd 64': r'\mid \nmid \parallel \nparallel \nshortparallel',
      r'cmd 65': r'\lvert \lVert \rvert \rVert \vert \Vert',
      r'cmd 66': r'\shortmid \shortparallel \lfloor \rfloor \lceil \rceil',

      r'cmd 67': r'\ulcorner \urcorner \llcorner \lrcorner',
      r'cmd 68': r'\asymp \bowtie \Join \smile \frown \smallsmile \smallfrown',
      r'cmd 69': r'\circ \bigcirc \angle \triangle \vartriangle',
      r'cmd 70': r'\triangledown \triangleleft \triangleright \bigtriangleup \bigtriangledown',

      r'cmd 71': r'\blacktriangle \blacktriangledown \blacktriangleleft \blacktriangleright \blacksquare \lozenge \blacklozenge',
      r'cmd 72': r'\bigstar \square \Box \Diamond',

      // Others 3
      r'cmd 73': r'\infty \prime \backprime \acute \grave \breve \check \degree \mathring',
      r'cmd 74': r'\neg \lnot \empty \emptyset \varnothing',
      r'cmd 75': r'\cap \cup \Cap \Cup \doublecap \doublecup',
      r'cmd 76': r'\setminus \smallsetminus \backslash \not \land \lor',
      r'cmd 77': r'\wedge \vee \surd \langle \rangle \varangle',
      r'cmd 78': r'\oplus \ominus \odot \otimes \oslash',
      r'cmd 79': r'\circleddash \circledast \circledcirc \boxminus \boxplus \boxdot \boxtimes',

      // Others 4
      r'cmd 80': r'\circledS \circledR \measuredangle \sphericalangle',
      r'cmd 81': r'\mho \Finv \Game \complement \eth \diagup \diagdown',
      r'cmd 82': r'\checkmark \beth \daleth \gimel \digamma',
      r'cmd 83': r'\bumpeq \Bumpeq \between \pitchfork',
      r'cmd 84': r'\dotplus \divideontimes \ltimes \rtimes \leftthreetimes \rightthreetimes',
      r'cmd 85': r'\barwedge \veebar \doublebarwedge \curlywedge \curlyvee \intercal',

      // Set of numbers
      r'cmd 86': r'\N \Z \Q \R \C \H',
    },
    'errors': {

      // cannot be tested since exception is thrown
      // r'error strict': {
      //   'text': r'\e + 2',
      //   'parsing': 'strict',
      // },

      r'error invalidSyntax': {
        'text': r'\e + 2',
        'parsing': 'minorErrorsAsInvalidSyntax',
      },

      r'error redPlaceholders': {
        'text': r'\e + 2',
        'parsing': 'minorErrorsAsRedPlaceholders',
      },

    },
    'mathpix': {

      r'mathpix 1': r'\# \$ \% \& \AA',
      r'mathpix 2': r'\Delta \Gamma \Im \Lambda \Leftarrow',
      r'mathpix 3': r'\Leftrightarrow \Longleftarrow \Longleftrightarrow \Longrightarrow \Omega',
      r'mathpix 4': r'\perp \Phi \Pi \Psi \Re',
      r'mathpix 5': r'\Rightarrow \S \Sigma \Theta \Upsilon',
      r'mathpix 6': r'\varangle \Vdash \Xi \\ \aleph',
      r'mathpix 7': r'\alpha \angle \approx \asymp',
      r'mathpix 8': r'\backslash \because \beta \beth',
      r'mathpix 9': r'\bigcap \bigcirc \bigcup \bigodot \bigoplus',
      r'mathpix 10': r'\bigotimes \biguplus \bigvee \bigwedge',
      r'mathpix 11': r'\bot \bowtie \breve \bullet \cap',
      r'mathpix 12': r'\cdot \cdots \check \chi \circ',
      r'mathpix 13': r'\circlearrowleft \circlearrowright \circledast',
      r'mathpix 14': r'\complement',
      r'mathpix 15': r'\cong \coprod \cup \curlyvee \curlywedge',
      r'mathpix 16': r'\curvearrowleft \curvearrowright \dagger \dashv',
      r'mathpix 17': r'\ddot \ddots \delta \diamond \div',
      r'mathpix 18': r'\dot \doteq \dots \downarrow \ell',
      r'mathpix 19': r'\emptyset',
      r'mathpix 20': r'\epsilon \equiv \eta',
      r'mathpix 21': r'\exists \fallingdotseq \forall',
      r'mathpix 22': r'\frown',
      r'mathpix 23': r'\gamma \geq \geqq \geqslant \gg',
      r'mathpix 24': r'\ggg \gtrless \gtrsim \hat \hbar',
      r'mathpix 25': r'\hookleftarrow \hookrightarrow \imath \in',
      r'mathpix 26': r'\infty \int \iota \jmath \kappa',
      r'mathpix 27': r'\lambda \langle \lceil \ldots \leadsto',
      r'mathpix 28': r'\leftarrow \leftleftarrows \leftrightarrow \leftrightarrows \leftrightharpoons',
      r'mathpix 29': r'\leq \leqq \leqslant \lessdot \lessgtr',
      r'mathpix 30': r'\lesssim \lfloor \ll \llcorner',
      r'mathpix 31': r'\lll \longleftarrow \longleftrightarrow \longmapsto',
      r'mathpix 32': r'\longrightarrow \lrcorner \ltimes \mapsto',
      r'mathpix 33': r'\mho \models \mp \mu ',
      r'mathpix 34': r'\multimap \nVdash \nabla \nearrow',
      r'mathpix 35': r'\neg \neq \nexists \ni',
      r'mathpix 36': r'\nmid \not \notin \nprec \npreceq',
      r'mathpix 37': r'\nsim \nsubseteq \nsucc \nsucceq \nsupseteq',
      r'mathpix 38': r'\nu \nvdash \nwarrow \odot ',
      r'mathpix 39': r'\oint \omega \ominus',
      r'mathpix 40': r'\oplus \oslash \otimes',
      r'mathpix 41': r'\parallel \partial \perp',
      r'mathpix 42': r'\phi \pi \pitchfork \pm \prec',
      r'mathpix 43': r'\preccurlyeq \preceq \precsim \prime \prod',
      r'mathpix 44': r'\propto \psi \qquad \quad \rangle',
      r'mathpix 45': r'\rceil \rfloor \rho \rightarrow \rightleftarrows',
      r'mathpix 46': r'\rightleftharpoons \rightrightarrows \rightsquigarrow \risingdotseq',
      r'mathpix 47': r'\rtimes \searrow \sigma \sim \simeq',
      r'mathpix 48': r'\smile \sqcap \sqcup \sqrt \sqsubset',
      r'mathpix 49': r'\sqsubseteq \sqsupset \sqsupseteq \square',
      r'mathpix 50': r'\star \subset \subseteq \subsetneq \succ',
      r'mathpix 51': r'\succcurlyeq \succeq \succsim \sum \supset',
      r'mathpix 52': r'\supseteq \supseteqq \supsetneq \supsetneqq \swarrow',
      r'mathpix 53': r'\tau \therefore \theta',
      r'mathpix 54': r'\times \top \triangle \triangleleft \triangleq',
      r'mathpix 55': r'\triangleright \unlhd',
      r'mathpix 56': r'\unrhd \uparrow \uplus \vDash \varepsilon',
      r'mathpix 57': r'\varnothing \varphi \varpi',
      r'mathpix 58': r'\varrho \varsigma \varsubsetneqq \vartheta \vdash',
      r'mathpix 59': r'\vdots \vee \wedge \wp \xi \zeta \{ \| \}',

    },
  }
};