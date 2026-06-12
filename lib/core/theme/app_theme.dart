import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_system.dart';

class RunQuestTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RunQuestDesignSystem.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: RunQuestDesignSystem.primaryOrange,
        secondary: RunQuestDesignSystem.secondaryCyan,
        surface: RunQuestDesignSystem.darkCard,
        error: RunQuestDesignSystem.enemyCrimson,
      ),

      // Text Theme
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: RunQuestDesignSystem.darkTextPrimary,
            ),
            displayMedium: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: RunQuestDesignSystem.darkTextPrimary,
            ),
            titleLarge: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: RunQuestDesignSystem.darkTextPrimary,
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 16,
              color: RunQuestDesignSystem.darkTextPrimary,
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 14,
              color: RunQuestDesignSystem.darkTextSecondary,
            ),
          ),

      // Input Decoration (Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RunQuestDesignSystem.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.darkBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.enemyCrimson,
            width: 1,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          color: RunQuestDesignSystem.darkTextSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          color: RunQuestDesignSystem.darkTextSecondary.withValues(alpha: 0.5),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: RunQuestDesignSystem.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: RunQuestDesignSystem.darkBorder,
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RunQuestDesignSystem.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: RunQuestDesignSystem.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: RunQuestDesignSystem.darkTextPrimary,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: RunQuestDesignSystem.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: RunQuestDesignSystem.primaryOrange,
        secondary: RunQuestDesignSystem.secondaryCyan,
        surface: RunQuestDesignSystem.lightCard,
        error: RunQuestDesignSystem.enemyCrimson,
      ),

      // Text Theme
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: RunQuestDesignSystem.lightTextPrimary,
            ),
            displayMedium: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: RunQuestDesignSystem.lightTextPrimary,
            ),
            titleLarge: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: RunQuestDesignSystem.lightTextPrimary,
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 16,
              color: RunQuestDesignSystem.lightTextPrimary,
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 14,
              color: RunQuestDesignSystem.lightTextSecondary,
            ),
          ),

      // Input Decoration (Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RunQuestDesignSystem.lightCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.lightBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: RunQuestDesignSystem.enemyCrimson,
            width: 1,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          color: RunQuestDesignSystem.lightTextSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          color: RunQuestDesignSystem.lightTextSecondary.withValues(alpha: 0.5),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: RunQuestDesignSystem.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: RunQuestDesignSystem.lightBorder,
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RunQuestDesignSystem.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: RunQuestDesignSystem.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: RunQuestDesignSystem.lightTextPrimary,
        ),
      ),
    );
  }
}
