import 'package:flutter/material.dart';

/// Gece spor salonu (Dark Obsidian & Neon) renk paleti sabitleri.
abstract final class AppColors {
  // Obsidian Arka Plan Tonları
  static const Color obsidianBackground = Color(0xFF0D1117);
  static const Color obsidianCard = Color(0xFF161B22);
  static const Color obsidianSurface = Color(0xFF21262D);
  static const Color obsidianBorder = Color(0xFF30363D);

  // Neon Vurgu Renkleri (Su, Egzersiz, Kalori)
  static const Color neonCyan = Color(0xFF00E5FF);       // Su takibi ana renk
  static const Color neonCyanLight = Color(0xFF80F2FF);
  static const Color neonLime = Color(0xFF39FF14);       // Egzersiz & Enerji
  static const Color neonAmber = Color(0xFFFF9E00);      // Kalori & Hedef
  static const Color neonCoral = Color(0xFFFF3366);      // Nabız & Yoğunluk

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  // Durum Renkleri
  static const Color success = Color(0xFF238636);
  static const Color warning = Color(0xFFD29922);
  static const Color error = Color(0xFFDA3633);
}
