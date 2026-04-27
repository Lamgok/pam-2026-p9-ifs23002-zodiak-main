import 'package:flutter/material.dart';

class AppTheme {
  // Tema LOTM: Gelap, Misterius, Elegan
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Hitam pekat
    primaryColor: const Color(0xFF8B0000), // Merah darah pekat (Crimson)
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4AF37), // Emas kuno untuk aksen
      secondary: Color(0xFF4A0E4E), // Ungu gelap rahasia
      surface: Color(0xFF1E1E1E), // Abu-abu tua untuk Card
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFD4AF37), // Teks AppBar warna emas
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
  );

  // Paksa aplikasi selalu menggunakan tema gelap ini
  static ThemeData light = dark;
}