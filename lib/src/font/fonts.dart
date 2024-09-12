import 'latex_font.dart';

class AmsLatexFont extends LatexFont {
  AmsLatexFont()
      : super(LatexFont.isGoldenTest ? 'kt-ams' : 'packages/easy_latex/kt-ams');
}

class CalLatexFont extends LatexFont {
  CalLatexFont()
      : super(LatexFont.isGoldenTest ? 'kt-cal' : 'packages/easy_latex/kt-cal');
}

class FrakturLatexFont extends LatexFont {
  FrakturLatexFont()
      : super(LatexFont.isGoldenTest
            ? 'kt-fraktur'
            : 'packages/easy_latex/kt-fraktur');
}

class MainLatexFont extends LatexFont {
  MainLatexFont()
      : super(
            LatexFont.isGoldenTest ? 'kt-main' : 'packages/easy_latex/kt-main');
}

class MainItalicLatexFont extends LatexFont {
  MainItalicLatexFont()
      : super(LatexFont.isGoldenTest
            ? 'kt-main-italic'
            : 'packages/easy_latex/kt-main-italic');
}

class ScriptLatexFont extends LatexFont {
  ScriptLatexFont()
      : super(LatexFont.isGoldenTest
            ? 'kt-script'
            : 'packages/easy_latex/kt-script');
}

class TypewriterLatexFont extends LatexFont {
  TypewriterLatexFont()
      : super(LatexFont.isGoldenTest
            ? 'kt-typewriter'
            : 'packages/easy_latex/kt-typewriter');
}
