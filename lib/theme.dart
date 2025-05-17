import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkSlateGray = Color(0xFF1E293B);
const Color mintGreen = Color(0xFFD1FAE5);
const Color emeraldGreen = Color(0xFF10B981);
const Color darkGreen = Color(0xFF065F46);
const Color warmGold = Color(0xFFFBBF24);
const Color whiteColor = Color(0xFFF8FAFC);
const Color lightGrey = Color(0xFFE2E8F0);
const Color mediumGrey = Color(0xFF64748B);

LinearGradient premiumGradient = LinearGradient(
  colors: [emeraldGreen, mintGreen],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: emeraldGreen,
    scaffoldBackgroundColor: whiteColor,
    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkSlateGray,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: darkSlateGray,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.inter(color: darkSlateGray, fontSize: 16),
      titleMedium: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodyLarge: GoogleFonts.inter(color: darkSlateGray, fontSize: 18),
      titleLarge: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      displayMedium: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w700,
        fontSize: 30,
      ),
      headlineSmall: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      displaySmall: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      labelLarge: GoogleFonts.inter(
        color: darkSlateGray,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGrey.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: emeraldGreen,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      hintStyle: GoogleFonts.inter(
        color: mediumGrey,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: emeraldGreen,
        foregroundColor: whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: emeraldGreen.withOpacity(0.3),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: emeraldGreen,
        textStyle: GoogleFonts.inter(fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: emeraldGreen,
        side: const BorderSide(color: emeraldGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: darkSlateGray.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: whiteColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: emeraldGreen,
      unselectedItemColor: mediumGrey,
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),
  );
}