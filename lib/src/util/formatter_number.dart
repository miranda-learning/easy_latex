import 'package:intl/number_symbols_data.dart';

import 'extensions.dart';

class NumberFormatter {
  /// input can be int, double or String
  static String? formattedNumber(dynamic number, {String? locale}) {
    locale ??= 'en';

    String numberText;
    String formattedNumberText = '';

    if (number is double || number is int) {
      numberText = number.toString();
    } else if (number is String) {
      if (double.tryParse(number) == null) return null;
      numberText = number;
    } else {
      return null;
    }

    List<String> s = numberText.split('.');

    if (s.twoOrMore) {
      String decimalSep = numberFormatSymbols[locale]?.DECIMAL_SEP ?? '.';
      formattedNumberText = decimalSep + s[1];
    }

    formattedNumberText = s[0] + formattedNumberText;
    return formattedNumberText;
  }

  static String decimalSeparator({String? locale}) {
    locale ??= 'en';
    return numberFormatSymbols[locale]?.DECIMAL_SEP ?? '.';
  }

  static String commaSeparator({String? locale}) {
    String decimalSep = decimalSeparator(locale: locale);
    return decimalSep == '.' ? ',' : ';';
  }
}