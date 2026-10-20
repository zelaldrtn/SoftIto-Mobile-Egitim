import 'package:flutter/material.dart';

/// DigiDia v1 renk paleti sabitleri.
/// Gündüz teması: Pastel mor, lavanta ve lila tonları.
/// Gece teması: Koyu mor, ametist ve derin gece tonları.
abstract final class AppColors {
  // Gündüz Teması (Pastel Mor & Lavanta)
  static const Color lightPrimary = Color(0xFF8A4FFF);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightPrimaryContainer = Color(0xFFF1E9FE);
  static const Color lightOnPrimaryContainer = Color(0xFF381E72);
  
  static const Color lightSecondary = Color(0xFF9D65C9);
  static const Color lightSecondaryContainer = Color(0xFFF7F2FD);
  
  static const Color lightBackground = Color(0xFFFAF7FF);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF3EEFA);
  
  static const Color lightTextPrimary = Color(0xFF231B32);
  static const Color lightTextSecondary = Color(0xFF6B5E82);
  static const Color lightBorder = Color(0xFFE5DCF2);

  // Gece Teması (Koyu Mor & Ametist)
  static const Color darkPrimary = Color(0xFFB794F6);
  static const Color darkOnPrimary = Color(0xFF1B0E33);
  static const Color darkPrimaryContainer = Color(0xFF38235C);
  static const Color darkOnPrimaryContainer = Color(0xFFEEDCFF);
  
  static const Color darkSecondary = Color(0xFFD6BCFA);
  static const Color darkSecondaryContainer = Color(0xFF271A3F);
  
  static const Color darkBackground = Color(0xFF120E1D);
  static const Color darkSurface = Color(0xFF1B152B);
  static const Color darkSurfaceVariant = Color(0xFF261E3B);
  
  static const Color darkTextPrimary = Color(0xFFF5EFFF);
  static const Color darkTextSecondary = Color(0xFFAFA2C7);
  static const Color darkBorder = Color(0xFF3C3058);

  // Ortak Vurgular
  static const Color accentGold = Color(0xFFFFB703);
  static const Color accentPink = Color(0xFFFF6584);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
}
