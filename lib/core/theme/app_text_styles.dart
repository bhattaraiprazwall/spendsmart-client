import 'package:flutter/material.dart';

class AppTextStyles {
  // NB: colors intentionally inherit the ambient themed text color.
  static const TextStyle headline = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    fontWeight: FontWeight.bold,

  );

  static const TextStyle body=TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
  );

  static const TextStyle label=TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w500
  );
}