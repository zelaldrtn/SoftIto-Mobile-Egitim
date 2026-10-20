import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk paleti ve tasarım belirteçleri.
/// project.md kurallarına uygun olarak:
/// - Koyu Mod: Siyah, gri, sarı (#FBBF24 / #F59E0B) ve yeşil (#10B981 / #34D399) tonları.
/// - Açık Mod: Temiz beyaz, sarı, yeşil ve mavi (#1E40AF / #2563EB) tonları.
abstract final class AppColors {
  // Ortak Renkler
  static const Color primaryYellow = Color(0xFFF59E0B);
  static const Color accentYellowLight = Color(0xFFFBBF24);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color(0xFF34D399);
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningOrange = Color(0xFFF97316);

  // Açık Tema Renkleri
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Koyu Tema Renkleri
  static const Color darkBg = Color(0xFF0B0F17);
  static const Color darkCard = Color(0xFF131B2E);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
}
