import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';

extension AppThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  AppColorsPalette get colors => AppColorsPalette.of(this);
}

class AppColorsPalette {
  const AppColorsPalette._({
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.chevron,
    required this.dangerBg,
    required this.dangerBorder,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color chevron;
  final Color dangerBg;
  final Color dangerBorder;

  static AppColorsPalette of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (dark) {
      return const AppColorsPalette._(
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        card: AppColors.darkCard,
        border: AppColors.darkBorder,
        divider: AppColors.darkDivider,
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        textMuted: AppColors.darkTextMuted,
        chevron: AppColors.darkChevron,
        dangerBg: AppColors.darkDangerBg,
        dangerBorder: AppColors.darkDangerBorder,
      );
    }
    return const AppColorsPalette._(
      background: AppColors.background,
      surface: AppColors.bg,
      card: AppColors.card,
      border: AppColors.border,
      divider: AppColors.divider,
      textPrimary: AppColors.labelColor,
      textSecondary: AppColors.subtitleColor,
      textMuted: AppColors.chevronColor,
      chevron: AppColors.chevronColor,
      dangerBg: AppColors.logoutBg,
      dangerBorder: AppColors.logoutBorder,
    );
  }
}
