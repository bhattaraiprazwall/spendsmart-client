import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.neutral

  );

  static const TextStyle body=TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    color: AppColors.neutral
  );

  static const TextStyle label=TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w500
  );
}