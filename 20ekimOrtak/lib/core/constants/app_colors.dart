import 'package:flutter/material.dart';

/// Destek Bul uygulaması merkezi renk paleti.
/// Proje kurallarına uygun olarak:
/// - Aydınlık Mod: Göz yormayan beyaz, sarı, yeşil, mavi renkleri
/// - Karanlık Mod: Göz yormayan siyah, gri, sarı, yeşil renkleri
class AppColors {
  AppColors._();

  // Aydınlık Mod Renkleri
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimaryBlue = Color(0xFF1D4ED8);
  static const Color lightPrimaryContainer = Color(0xFFDBEAFE);
  static const Color lightYellow = Color(0xFFEAB308);
  static const Color lightGreen = Color(0xFF10B981);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Karanlık Mod Renkleri
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkPrimaryYellow = Color(0xFFFACC15);
  static const Color darkSecondaryGreen = Color(0xFF34D399);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);

  // Ortak Vurgu Renkleri
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color solarYellow = Color(0xFFF59E0B);
  static const Color oceanBlue = Color(0xFF2563EB);
  static const Color softRed = Color(0xFFEF4444);
}
