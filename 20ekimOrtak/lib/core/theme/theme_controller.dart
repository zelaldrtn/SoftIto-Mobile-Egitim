import 'package:flutter/material.dart';

/// Tema durumunu `ValueNotifier<ThemeMode>` ile yöneten tekil controller.
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  /// Proje gereksinimi: Tema durumu `ValueNotifier<ThemeMode>` ile yönetilir.
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Aktif temanın karanlık olup olmadığını döner.
  bool isDarkMode(BuildContext context) {
    if (themeModeNotifier.value == ThemeMode.system) {
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
