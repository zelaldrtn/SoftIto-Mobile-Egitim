import 'package:flutter/material.dart';

/// Tema durumunu `ValueNotifier<ThemeMode>` ile yöneten tekil controller.
class ThemeController {
  // Singleton deseni: uygulamanın her yerinden aynı tekil instance'a erişilmesini sağlar
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  /// Proje gereksinimi: Tema durumu `ValueNotifier<ThemeMode>` ile yönetilir.
  // ValueNotifier: tema modu (system, light, dark) her değiştiğinde arayüze haber verir
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Aktif temanın karanlık olup olmadığını döner.
  bool isDarkMode(BuildContext context) {
    if (themeModeNotifier.value == ThemeMode.system) {
      // sistem genel teması karanlık mı kontrol eder
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return themeModeNotifier.value == ThemeMode.dark;
  }

  /// Tek tıkla aydınlık ve karanlık mod arasında geçiş yapar.
  void toggleTheme(BuildContext context) {
    final bool currentIsDark = isDarkMode(context);
    themeModeNotifier.value = currentIsDark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir tema modunu ayarlar.
  void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}

