import 'package:flutter/material.dart';

/// Karanlık ve Aydınlık tema durumunu ValueNotifier mimarisiyle yöneten denetleyici.
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  bool get isDark => themeMode.value == ThemeMode.dark;

  /// Temalar arasında tek tıkla geçiş yapar.
  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir tema modunu ayarlar.
  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
  }

  /// Bellek sızıntılarını önlemek için dispose eder.
  void dispose() {
    themeMode.dispose();
  }
}
