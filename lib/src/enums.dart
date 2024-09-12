/// An enumeration that specifies the wrapping behavior for LaTeX rendering.
///
/// This enum controls how LaTeX content is managed when it exceeds the available
/// space for rendering.
enum LatexWrapMode {
  /// No wrapping is applied.
  ///
  /// If the LaTeX content exceeds the line width, it will overflow
  /// without automatically breaking into a new line.
  none,

  /// Simple wrapping mode.
  ///
  /// This mode ensures that the rendering of LaTeX content breaks into a new line
  /// at the first item that cannot fit on the current line. Each overflowing item
  /// starts at the beginning of the next line.
  simple,

  /// Smart wrapping mode.
  ///
  /// In this mode, the wrapping is more context-aware, aiming to break lines
  /// at logical points within the LaTeX expression:
  ///
  /// - If an "=" sign is present, it breaks the line at this point. The "=" sign
  ///   will appear at the end of the current line and is also repeated at the
  ///   beginning of the new line for clarity and continuity of the expression.
  /// - If there is no "=" sign but the expression contains "+" or "-", the line
  ///   breaks at these operators instead. The "+" or "-" sign will appear at
  ///   the end of the current line and is also repeated at the beginning of
  ///   the new line for clarity and continuity of the expression.
  ///
  /// This approach helps in maintaining the mathematical integrity and readability
  /// of complex LaTeX expressions.
  smart,
}

/// An enumeration that specifies the alignment of multiline LaTeX text.
///
/// This enum controls the horizontal alignment of LaTeX content that spans
/// multiple lines within the available rendering space.
enum MultiLineTextAlign {
  /// Aligns the text to the left side of the rendering space.
  ///
  /// Each line of the LaTeX content starts at the left boundary of the container,
  /// creating a uniform alignment at the left edge.
  left,

  /// Aligns the text to the right side of the rendering space.
  ///
  /// Each line of the LaTeX content ends at the right boundary of the container,
  /// creating a uniform alignment at the right edge.
  right,

  /// Centers the text horizontally in the rendering space.
  ///
  /// Each line of the LaTeX content is centered within the container, ensuring that
  /// the text is evenly spaced from both the left and right edges.
  center,
}

/// An enumeration that defines the error handling strategies during LaTeX parsing.
///
/// This enum allows customization of how parsing errors—both minor and critical—are
/// managed during the rendering of LaTeX content.
enum ParsingMode {
  /// Minor errors are shown along with the invalid syntax; critical errors cause the parsing to fail.
  ///
  /// In this mode, the renderer displays the part of the LaTeX content that contains minor
  /// errors in its original, possibly incorrect syntax. This approach allows users to see
  /// and correct minor issues without interrupting the rendering of valid parts. However,
  /// critical errors that might affect the overall structure and rendering will stop the parsing process.
  minorErrorsAsInvalidSyntax,

  /// Minor errors are indicated with red placeholders; critical errors cause the parsing to fail.
  ///
  /// This mode enhances visibility of minor errors by marking them with red placeholders,
  /// making it easier to identify and correct them. Like the previous mode, any critical errors
  /// will halt the parsing process to prevent rendering incorrect or misleading mathematical expressions.
  minorErrorsAsRedPlaceholders,

  /// All errors, whether minor or critical, trigger strict error handling, typically resulting in exceptions.
  ///
  /// The strict mode enforces rigorous error checks, where any error—minor or significant—prevents
  /// the rendering of the LaTeX content. This mode is suitable for scenarios where accuracy and
  /// correctness are crucial, and any mistake (even minor) is not tolerable, likely leading to exceptions.
  strict,
}
