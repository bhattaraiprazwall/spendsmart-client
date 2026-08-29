class CurrencyUtil {
  static const Map<String, String> _symbols = {
    'USD': r'$',
    'NPR': 'Rs',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
  };

  static const List<String> supportedCodes = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'NPR',
  ];

  /// Returns the symbol for a currency code, or the code itself as a fallback.
  static String symbolFor(String code) {
    return _symbols[code] ?? code;
  }

  /// Formats a numeric value with the currency symbol and thousand separators.
  ///
  /// [value] may be a [num], a [String] number, or already a [String] with a
  /// prefix (e.g. "USD123.45"). When it is a plain numeric string, it is
  /// parsed and reformatted; otherwise it is used verbatim.
  static String format(dynamic value, String code) {
    final symbol = symbolFor(code);
    final normalized = value.toString();
    final parsed = double.tryParse(normalized);
    if (parsed == null) return '$symbol$normalized';
    return '$symbol${_grouped(parsed)}';
  }

  /// Formats a signed amount with +/-, symbol, and thousand separators.
  static String signed(double amount, String code) {
    final sign = amount >= 0 ? '+' : '-';
    return '$sign${symbolFor(code)}${_grouped(amount.abs())}';
  }

  static String _grouped(double value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final intPart = parts[0];
    final decimal = parts.length > 1 ? parts[1] : '';
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    if (decimal.isNotEmpty) {
      buffer.write('.');
      buffer.write(decimal);
    }
    return buffer.toString();
  }
}
