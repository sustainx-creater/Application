import 'package:flutter/material.dart';

const Color darkSlateGray = 
Color(0xFF334155);
const Color mintGreen = Color(0xFFCCFBF1);
const Color emeraldGreen = Color(0xFF14B8A6);
const Color darkGreen = Color(0xFF104E44);
const Color warmGold = Color(0xFFF59E0B);
const Color whiteColor = Colors.white;
const Color lightGrey = Color(0xFFF1F5F9);
const Color mediumGrey = Color(0xFF94A3B8);

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: emeraldGreen,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: emeraldGreen,
      foregroundColor: whiteColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: whiteColor,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: darkSlateGray, fontSize: 16),
      titleMedium: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodyLarge: TextStyle(color: darkSlateGray, fontSize: 18),
      titleLarge: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      displayMedium: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
      headlineSmall: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      displaySmall: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      labelLarge: TextStyle(
        color: darkSlateGray,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGrey,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: mediumGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: mediumGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: emeraldGreen,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      hintStyle: const TextStyle(
        color: mediumGrey,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: emeraldGreen,
        foregroundColor: whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: emeraldGreen,
        textStyle: const TextStyle(fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: emeraldGreen,
        side: const BorderSide(color: emeraldGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: emeraldGreen,
      unselectedItemColor: mediumGrey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),
  );
}