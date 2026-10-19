import 'package:flutter/material.dart';

/// Proje genelinde kullanılan renk sabitleri.
/// Karanlık Mod: Dark Obsidian & Neon gece spor salonu paleti
/// Aydınlık Mod: Light Snow & Dinamik Enerji açık tema paleti
abstract final class AppColors {
  // Karanlık Mod (Dark Obsidian & Neon)
  static const Color darkBackground = Color(0xFF0F111A);
  static const Color darkSurface = Color(0xFF181A26);
  static const Color darkCard = Color(0xFF202334);
  static const Color neonCyan = Color(0xFF00F5D4);
  static const Color neonPurple = Color(0xFF7B2CBF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Aydınlık Mod (Light Snow & Dinamik Enerji)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color dynamicBlue = Color(0xFF0284C7);
  static const Color dynamicCyan = Color(0xFF06B6D4);
  static const Color dynamicOrange = Color(0xFFEA580C);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
}
