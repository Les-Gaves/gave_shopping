import 'package:flutter/material.dart';

class AppTheme {
  static const Color riverDark = Color(0xFF0A2E3B);
  static const Color riverPrimary = Color(0xFF0F5A71);
  static const Color riverTeal = Color(0xFF1B8A9E);
  static const Color riverFoam = Color(0xFFE4F3F7);
  static const Color safetyOrange = Color(0xFFF36434);
  static const Color safetyOrangeLight = Color(0xFFFFF0EA);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: riverPrimary,
        onPrimary: Colors.white,
        primaryContainer: riverFoam,
        onPrimaryContainer: riverDark,
        secondary: safetyOrange,
        onSecondary: Colors.white,
        secondaryContainer: safetyOrangeLight,
        onSecondaryContainer: Color(0xFF7A2508),
        surface: surfaceLight,
        onSurface: textDark,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: riverDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: riverPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: riverPrimary,
          side: const BorderSide(color: riverPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: riverPrimary,
        secondarySelectedColor: riverPrimary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
