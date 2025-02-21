// lib/config/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor:const Color(0xFF1A237E),
      secondaryHeaderColor:const Color(0xFF303F9F),
      scaffoldBackgroundColor:const Color(0xFFF5F6FA),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side:const BorderSide(
            color: Color(0xFFE3E3E3),
            width: 1,
          ),
        ),
        shadowColor: Colors.black26,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color:const Color(0xFF1A237E),
        ),
        titleLarge: GoogleFonts.sourceSans3(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color:const Color(0xFF2C3E50),
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          color:const Color(0xFF34495E),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:const Color(0xFF1A237E),
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}