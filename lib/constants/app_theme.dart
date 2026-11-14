import 'package:flutter/material.dart';

/// AppTheme enforces the strict Adobe/iLovePDF inspired professional
/// White-Theme design language:
/// - Primary PDF Red: #E5322D
/// - Main Background: #FFFFFF
/// - Secondary Surfaces: #F7F7F7
/// - Main Typography: #242424
/// - Secondary Typography: #777777
/// - Borders: #EAEAEA
/// - Disabled: #BDBDBD
class AppTheme {
  AppTheme._();

  static const Color primaryRed = Color(0xFFE5322D);
  static const Color primaryRedDark = Color(0xFFC72824);
  static const Color primaryRedLight = Color(0xFFFDECEB);

  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF7F7F7);
  static const Color surfaceGreyDarker = Color(0xFFEEEEEE);

  static const Color textMain = Color(0xFF242424);
  static const Color textSecondary = Color(0xFF777777);
  static const Color textDisabled = Color(0xFFBDBDBD);

  static const Color borderGrey = Color(0xFFEAEAEA);
  static const Color borderSubtle = Color(0xFFE0E0E0);

  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningOrange = Color(0xFFED6C02);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: backgroundWhite,
      canvasColor: backgroundWhite,
      cardColor: surfaceGrey,
      dividerColor: borderGrey,

      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        onPrimary: Colors.white,
        primaryContainer: primaryRedLight,
        onPrimaryContainer: primaryRedDark,
        secondary: primaryRed,
        onSecondary: Colors.white,
        surface: surfaceGrey,
        onSurface: textMain,
        error: primaryRed,
        onError: Colors.white,
        outline: borderGrey,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        foregroundColor: textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textMain, size: 22),
        shape: Border(
          bottom: BorderSide(color: borderGrey, width: 1),
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceGrey,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textMain,
          side: const BorderSide(color: borderGrey, width: 1.2),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed, width: 1.5),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGrey),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textMain,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: textMain,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          color: textMain,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: textMain,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textMain,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
