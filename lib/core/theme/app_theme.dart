import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ColorScheme _colorScheme(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          onPrimary: Colors.white,
          surface: AppColors.background,
        ),
      Brightness.dark => const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          onPrimary: Colors.white,
          surface: AppColors.darkBackground,
          surfaceContainerLow: AppColors.darkSurface,
          surfaceContainer: AppColors.darkCard,
          surfaceContainerHigh: AppColors.darkCard,
          surfaceContainerHighest: AppColors.darkCard,
        ),
    };
  }

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: brightness,
      colorScheme: _colorScheme(brightness),
      scaffoldBackgroundColor: dark ? AppColors.darkBackground : AppColors.background,
      primaryColor: AppColors.primary,

      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.darkBackground : AppColors.white,
        foregroundColor: dark ? AppColors.darkTextPrimary : AppColors.labelColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkSurface : Colors.grey.shade100,
        hintStyle: TextStyle(color: dark ? AppColors.darkTextMuted : AppColors.textGrey),
        labelStyle: TextStyle(color: dark ? AppColors.darkTextSecondary : AppColors.textGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.danger),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: dark ? AppColors.darkDivider : AppColors.divider,
        thickness: 1,
      ),

      cardTheme: CardThemeData(
        color: dark ? AppColors.darkCard : AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: dark ? AppColors.darkCard : AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.white : AppColors.textGrey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : (dark ? AppColors.darkBorder : AppColors.border),
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: dark ? AppColors.darkTextPrimary : AppColors.labelColor,
        contentTextStyle: TextStyle(color: dark ? AppColors.darkSurface : AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      textTheme: ThemeData().textTheme.apply(
        fontFamily: 'Manrope',
        bodyColor: dark ? AppColors.darkTextPrimary : AppColors.labelColor,
        displayColor: dark ? AppColors.darkTextPrimary : AppColors.labelColor,
      ),
    );

    return theme;
  }
}
