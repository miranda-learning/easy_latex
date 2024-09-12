/// A class that encapsulates the font details used for rendering LaTeX.
///
/// This class provides a structured way to specify and manage the font settings
/// that are applied to LaTeX rendering within the application. It allows for customization
/// of the font family and style options.
class LatexFont {
  LatexFont(
    this.fontFamily, {
    this.isSansSerif = false,
  });

  /// A flag for testing purposes only.
  ///
  /// When set to `true`, the renderer may alter its behavior to facilitate
  /// the creation of consistent, reproducible golden tests.
  static bool isGoldenTest = false;

  /// The font family used for rendering the LaTeX.
  ///
  /// This property specifies the name of the font family. It should match a font that
  /// is available in the environment where the LaTeX is being rendered.
  final String fontFamily;

  /// Specifies whether the font style is sans-serif.
  ///
  /// When set to `true`, the LaTeX rendering will use a sans-serif version of the specified
  /// font family. This is useful for ensuring that the LaTeX content aligns with the
  /// visual style of the surrounding content.
  final bool isSansSerif;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatexFont && fontFamily == other.fontFamily && isSansSerif == other.isSansSerif;

  @override
  int get hashCode => Object.hash(fontFamily, isSansSerif);
}