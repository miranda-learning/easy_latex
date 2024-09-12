# easy_latex

The **easy_latex** allows developers to easily incorporate LaTeX elements
within their Flutter apps. The rendering of LaTeX is handled natively in Dart,
ensuring a rapid and efficient display without relying on HTML conversions.

## Live Rendering Demo

Check out the [live rendering](https://easylatex.open.miranda.works/) to see the plugin in action.

## Widgets

### Latex()

The `Latex()` widget enables the rendering of standalone LaTeX strings.

**locale:** The `Latex()` widget includes the `locale` parameter, allowing
you to adapt the number formatting to different languages. For example,
setting `locale` to \'de\' will display numbers like 3.14159 as 3,14159,
matching the standard German formatting.

```dart
import 'package:easy_latex/easy_latex.dart';

Latex(
  r'x_{1,2} = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a} \\ \pi = 3.14159... ',
  fontSize: 24,
  locale: 'en',
);

```


### LText()

The `LText()` widget allows you to integrate Markdown and LaTeX into your text,
enabling both rich formatting and mathematical expressions.

**Supported Markdown commands:** `LText()` supports the certain Markdown to style the text.
- `**bold**`
- `*italic*`
- ``` `code` ```
- `\(Latex\)`

**latexLocale:** The `LText()` widget includes the `locale` parameter, allowing you to adapt the number '
'formatting to different languages. For example, setting `locale` to \'de\' will display numbers '
'like 3.14159 as 3,14159, matching the standard German formatting.

```dart
import 'package:easy_latex/easy_latex.dart';

LText(
  r'This is **bold text**, this is *italic text*, '
  r'this is `code`. The value of \(\pi\) is \(3.14159...\) '
  r'and the value of \(\sqrt{2}\) is \(1.41421...\)',
  fontSize: 24,
  latexLocale: 'en',
);

```


### LatexSpan()

The `LatexSpan()` widget facilitates the embedding of LaTeX code within `RichText()`.

**Attention:** The `LatexSpan()` widget does not inherit `fontSize` and
`color` (font color) from the parent `TextSpan`. These attributes must be explicitly
defined via the `style` attribute for each `LatexSpan`.


```dart
import 'package:easy_latex/easy_latex.dart';

RichText(
  text: TextSpan(
    style: MTextStyles.largeText,
    children: [
      const TextSpan(text: 'The value of '),
      LatexSpan(text: r'\pi', style: const TextStyle(fontSize: 16)),
      const TextSpan(text: ' is '),
      LatexSpan(text: r'3.14159...', style: const TextStyle(fontSize: 16)),
      const TextSpan(text: ' and the value of '),
      LatexSpan(text: r'\sqrt{2}', style: const TextStyle(fontSize: 16)),
      const TextSpan(text: ' is '),
      LatexSpan(text: r'1.41421...', style: const TextStyle(fontSize: 16)),
    ],
  ),
);

```

## Unsupported LaTeX Commands

We know some features you might need are missing right now. We're actively 
working to support these in upcoming releases. Currently, the following commands 
are not available:

- **Fonts:** `\mathit{}`, `\mathsf{}`
- **Table:** `\begin{tabular}`, `\end{tabular}`, `\multicolumn`, `\multirow`, `\hline`, `\cline`
- **Array:** `\begin{array}`, `\end{array}`
- **Matrix:** `\begin{vmatrix}`, `\end{vmatrix}`, `\begin{Vmatrix}`, `\end{Vmatrix}`, `\begin{smallmatrix}`, `\end{smallmatrix}`
- **Align:** `\begin{align}`, `\end{align}`, `\begin{alignat}`, `\end{alignat}`
- **Underset, overset:** `\underset{}`, `\overset{}`, `\stackrel{}`, `\xrightarrow{}`, `\xleftarrow{}`
- **Phantom:** `\phantom{}`, `\hphantom{}`, `\vphantom{}`
- **Apostrophes:** `\acute`, `\grave`, `\breve`, `\check`
- **Apostrophes:** `\acute`, `\grave`, `\breve`, `\check`
- **Nolimits, limits:** `\sum\nolimits`, `\prod\nolimits`, `\int\limits`, `\sideset{}`
- **Not, cancel:** `\!`, `\not`, `\cancel{}`, `\bcancel{}`, `\xcancel{}`, `\cancelto{}`
- **Left, right:** `\left|`, `\right|`, `\left.`, `\right.`, `\left\rangle`, `\right\rangle`
- **bigl, Bigl:** `\bigl`, `\Bigl`, `\biggl`, `\Biggl`, `\bigr`, `\Bigr`, `\biggr`, `\Biggr`
- **dfrac, dbinom:** `\dfrac{}`, `\dbinom{}{}`, `\tbinom{}{}`
- **Other commands:** `\atop`, `\varliminf`, `\varlimsup`, `\longdiv`


## Fonts and Licensing

The fonts included in the `lib/fonts` folder of this plugin originate from 
[KaTeX](https://github.com/KaTeX/KaTeX]), 
a LaTeX typesetting library. These fonts have been adjusted for optimal integration 
and use within this plugin. The fonts are licensed under the MIT License, a copy of 
which is included in the `fonts/LICENSE` file. For more details, please refer to this file.


## License

This plugin is distributed under the BSD License. The full license text is included 
in the `LICENSE` file located in the root directory of this project.


## Contact

For any questions or issues, please open an issue on the GitHub repository, 
or contact us directly at [dev@miranda.works].