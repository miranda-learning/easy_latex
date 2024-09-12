/// An exception class for handling errors during LaTeX parsing.
///
/// This is the base class for all LaTeX parser exceptions, and it captures the underlying
/// cause of the error in a human-readable format.
class LatexParserException implements Exception {
  /// Constructs a [LatexParserException] with a message that explains the cause.
  LatexParserException(this.cause);

  /// The message describing the cause of the error.
  final String cause;

  @override
  String toString() => cause;
}

/// An exception for unrecognized commands within the LaTeX input.
///
/// This exception is thrown when the parser encounters a command or a syntax that
/// it does not recognize or that is not supported.
class UnknownCommandException extends LatexParserException {
  UnknownCommandException(super.cause);

  @override
  String toString() => 'Unknown command: $cause';
}

/// An exception related to incorrect grouping or braces in LaTeX content.
///
/// This exception is raised when there are errors in the structure of groups or
/// misplaced/missing braces, which are critical for correct LaTeX parsing.
class GroupingException extends LatexParserException {
  GroupingException(super.cause);

  @override
  String toString() => 'Grouping error: $cause';
}

/// An exception for errors related to incorrect or missing arguments in LaTeX functions.
///
/// This type of error occurs when a function is called with the wrong number of arguments,
/// or when an argument is of an incorrect type or format.
class ArgumentsException extends LatexParserException {
  ArgumentsException(super.cause);

  @override
  String toString() => 'Latex function error: $cause';
}
