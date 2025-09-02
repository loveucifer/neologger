import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF000000); // Pitch black
  static const Color cardBackground = Color(0xFF111111); // Dark grey
  static const Color cardBackgroundSecondary = Color(
    0xFF0a0a0a,
  ); // ever more darker grey
  static const Color textPrimary = Color(0xFFffffff); // White text
  static const Color textSecondary = Color(0xFFaaaaaa); // Grey text
  static const Color border = Color(0xFF1a1a1a); // Subtle border
  static const Color accent = Color(
    0xFFffffff,
  ); // White accent (for highlights)
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppFonts {
  static const double headline1 = 32.0;
  static const double headline2 = 24.0;
  static const double headline3 = 20.0;
  static const double bodyLarge = 18.0;
  static const double bodyMedium = 16.0;
  static const double bodySmall = 14.0;
  static const double caption = 12.0;

  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;
}
