import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RunQuestDesignSystem {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFFF5A36); // Electric Orange
  static const Color secondaryCyan = Color(0xFF00F2FE); // Quest Cyan Accent
  static const Color accentBlue = Color(0xFF4FACFE); // Quest Blue Accent
  static const Color enemyCrimson = Color(0xFFFF2E93); // Rage Crimson

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0A0E1A); // Space Navy
  static const Color darkCard = Color(0xFF151D33); // Slate Card
  static const Color darkBorder = Color(0xFF1E294B); // Deep Border
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // White/Off-white
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate Grey

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF5F8FA); // Ivory Light
  static const Color lightCard = Color(0xFFFFFFFF); // Clean White
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Border
  static const Color lightTextPrimary = Color(0xFF0F172A); // Midnight Slate
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate Grey

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryOrange, Color(0xFFFF8E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient territoryGradient = LinearGradient(
    colors: [secondaryCyan, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient enemyGradient = LinearGradient(
    colors: [enemyCrimson, Color(0xFFFF5E62)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF10162A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> neonShadow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x05000000),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // Glassmorphic Container Decoration Helper
  static BoxDecoration glassDecoration({
    required bool isDark,
    double borderRadius = 16.0,
    double borderOpacity = 0.1,
  }) {
    return BoxDecoration(
      color: isDark
          ? const Color(0xFF151D33).withValues(alpha: 0.7)
          : const Color(0xFFFFFFFF).withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: (isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A))
            .withValues(alpha: borderOpacity),
        width: 1.0,
      ),
      boxShadow: cardShadow,
    );
  }

  // Typography - Outfit for Headers, Inter for Body
  static TextStyle headingStyle({
    required bool isDark,
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? (isDark ? darkTextPrimary : lightTextPrimary),
    );
  }

  static TextStyle bodyStyle({
    required bool isDark,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double height = 1.4,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? (isDark ? darkTextSecondary : lightTextSecondary),
      height: height,
    );
  }
}
