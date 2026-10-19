import 'package:flutter/material.dart';

/// Proje genelinde kullanılan Karanlık (Dark Obsidian & Neon) ve
/// Aydınlık (Light Snow & Dinamik Enerji) paleti renk sabitleri.
class AppColors {
  const AppColors._();

  // --- KARANLIK TEMA RENKLERİ ---
  static const Color darkBackground = Color(0xFF0D0E12);
  static const Color darkSurface = Color(0xFF161922);
  static const Color darkSurfaceElevated = Color(0xFF1F2430);
  static const Color darkCardBorder = Color(0xFF282F3E);

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonCyanDark = Color(0xFF00B4D8);
  static const Color darkWaterGlass = Color(0x3300E5FF);

  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonLime = Color(0xFF76FF03);
  static const Color darkWorkoutGlass = Color(0x3300E676);

  static const Color neonOrange = Color(0xFFFF6D00);
  static const Color neonCoral = Color(0xFFFF5252);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkTextMuted = Color(0xFF6B7280);

  // --- AYDINLIK TEMA RENKLERİ ---
  static const Color lightBackground = Color(0xFFF1F5F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF8FAFC);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  static const Color lightCyan = Color(0xFF0284C7);
  static const Color lightWaterGlass = Color(0x220284C7);

  static const Color lightGreen = Color(0xFF059669);
  static const Color lightWorkoutGlass = Color(0x22059669);

  static const Color lightOrange = Color(0xFFEA580C);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Geriye dönük uyumluluk sabitleri (Dark tema varsayılanları)
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceElevated = darkSurfaceElevated;
  static const Color cardBorder = darkCardBorder;
  static const Color waterGlass = darkWaterGlass;
  static const Color workoutGlass = darkWorkoutGlass;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // --- GRADIENTLER ---
  static const LinearGradient waterGradient = LinearGradient(
    colors: [neonCyan, Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient workoutGradient = LinearGradient(
    colors: [neonGreen, Color(0xFF009688)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF191D26), Color(0xFF12141B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- TEMA UYUMLU DİNAMİK YARDIMCILAR ---
  static LinearGradient cardGradientFor(bool isDark) =>
      isDark ? cardGradient : lightCardGradient;

  static Color surfaceElevatedFor(bool isDark) =>
      isDark ? darkSurfaceElevated : lightSurfaceElevated;

  static Color cardBorderFor(bool isDark) =>
      isDark ? darkCardBorder : lightCardBorder;

  static Color waterGlassFor(bool isDark) =>
      isDark ? darkWaterGlass : lightWaterGlass;

  static Color workoutGlassFor(bool isDark) =>
      isDark ? darkWorkoutGlass : lightWorkoutGlass;

  static Color primaryFor(bool isDark) =>
      isDark ? neonCyan : lightCyan;

  static Color secondaryFor(bool isDark) =>
      isDark ? neonGreen : lightGreen;

  static Color textPrimaryFor(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondaryFor(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color textMutedFor(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;
}
