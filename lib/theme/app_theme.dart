import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color neon = Color(0xFFC1FF00);
  static const Color purple = Color(0xFF7B61FF);

  // Semantic aliases used across widgets
  static const Color background = white;
  static const Color backgroundAlt = Color(0xFFF4F4F4);
  static const Color surface = white;
  static const Color surfaceDark = black;
  static const Color textPrimary = black;
  static const Color textSecondary = Color(0xFF444444);
  static const Color textMuted = Color(0xFF888888);
  static const Color border = Color(0xFFE0E0E0);
  static const Color accent = neon;
  static const Color accentPurple = purple;

  static const LinearGradient brandGradient = LinearGradient(
    colors: [neon, purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [purple, Color(0xFF5A45CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color sectionBg(bool dark) => dark ? black : white;
  static Color onSection(bool dark) => dark ? white : black;
  static Color onSectionMuted(bool dark) =>
      dark ? white.withValues(alpha: 0.65) : textSecondary;
  static Color sectionBorder(bool dark) =>
      dark ? white.withValues(alpha: 0.15) : border;

  static ThemeData get theme {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.light(
        primary: neon,
        secondary: purple,
        surface: white,
        onPrimary: black,
        onSurface: black,
      ),
      textTheme: base.copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w900,
          fontSize: 72,
          height: 1.0,
          letterSpacing: -2,
          color: white,
        ),
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w900,
          fontSize: 48,
          height: 1.05,
          letterSpacing: -1.5,
          color: black,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 36,
          height: 1.1,
          letterSpacing: -0.5,
          color: black,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: black,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 17,
          height: 1.65,
          color: textSecondary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          height: 1.55,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 2,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: white,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: neon,
          foregroundColor: black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  static BoxDecoration pillDecoration({Color? bg, bool dark = false}) =>
      BoxDecoration(
        color: bg ?? (dark ? white.withValues(alpha: 0.1) : backgroundAlt),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: sectionBorder(dark)),
      );

  static BoxDecoration cardDecoration({bool dark = false, Color? fill}) =>
      BoxDecoration(
        color: fill ?? (dark ? const Color(0xFF111111) : white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: sectionBorder(dark)),
      );
}
