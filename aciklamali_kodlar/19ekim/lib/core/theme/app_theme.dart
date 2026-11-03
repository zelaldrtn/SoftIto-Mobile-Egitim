import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Material 3 gece spor salonu (Dark Obsidian & Neon) teması.
// abstract final: yalnızca tema ayarlarını barındıran ve nesnesi üretilemeyen statik tema sınıfı
abstract final class AppTheme {
  // uygulamanın koyu tema yapılandırmasını döndüren getter
  static ThemeData get darkTheme {
    return ThemeData(
      // Material 3 tasarım sistemini etkinleştirir
      useMaterial3: true,
      // koyu renk düzenini aktif eder
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidianBackground,
      // ColorScheme.dark: Material 3 bileşenlerinin (butonlar, kartlar vb.) kullanacağı ana koyu renk paleti
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        onPrimary: AppColors.obsidianBackground,
        secondary: AppColors.neonLime,
        onSecondary: AppColors.obsidianBackground,
        tertiary: AppColors.neonAmber,
        surface: AppColors.obsidianCard,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        outline: AppColors.obsidianBorder,
      ),
      // Card bileşenlerinin uygulama genelindeki varsayılan stili
      cardTheme: const CardThemeData(
        color: AppColors.obsidianCard,
        // elevation: kartın gölge seviyesi (0 ile gölgesiz düz kart)
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.obsidianBorder, width: 1),
        ),
      ),
      // tüm sayfalardaki AppBar bileşenlerinin ortak görünümü
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.obsidianBackground,
        elevation: 0,
        // sayfa kaydırıldığında AppBar arkasında beliren gölgeyi sıfırlar
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      // alt gezinme çubuğunun (NavigationBar) ortak tema ayarları
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.obsidianCard,
        elevation: 0,
        indicatorColor: AppColors.neonCyan.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        // WidgetStateProperty.resolveWith: sekmenin durumuna göre (seçili mi değil mi) simge rengini belirler
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.neonCyan);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
        // sekmenin seçili olma durumuna göre metin rengi ve kalınlığını belirler
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.neonCyan,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          );
        }),
      ),
      // uygulamanın tipografi stilleri (başlıklar, gövde metinleri)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

