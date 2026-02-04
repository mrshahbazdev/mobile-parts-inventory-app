import 'package:flutter/material.dart';

class AppTheme {
  // Professional Color Palette
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep Navy Blue
  static const Color secondaryColor = Color(0xFF3B82F6); // Bright Blue
  static const Color accentColor = Color(0xFF10B981); // Emerald Green (Success/Action)
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color backgroundColor = Color(0xFFF3F4F6); // Light Grey Background
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF1F2937); // Dark Grey Text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),

      // Card Theme
      // Card Theme (Removed to fix build error)
      // cardTheme: CardTheme(...),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: TextStyle(fontSize: 14, color: textColor),
      ),
    );
  }
}
