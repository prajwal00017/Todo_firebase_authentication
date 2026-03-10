import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF3F3D56);
  static const Color backgroundColor = Color(0xFFF0F4FC);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF2D3142);
  static const Color textSecondaryColor = Color(0xFF9098B1);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF4CAF50);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: cardColor,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        bodyLarge: const TextStyle(color: textPrimaryColor),
        bodyMedium: const TextStyle(color: textSecondaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondaryColor),
        hintStyle: GoogleFonts.inter(color: textSecondaryColor),
      ),
    );
  }
}
