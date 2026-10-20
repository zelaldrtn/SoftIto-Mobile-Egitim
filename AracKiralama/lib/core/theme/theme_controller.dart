import 'package:flutter/material.dart';

/// Tema durumunu `ValueNotifier<ThemeMode>` ile yöneten denetleyici.
/// Kullanıcının arayüzden tek tıkla Aydınlık ve Karanlık mod arasında
/// anında geçiş yapmasını sağlar.
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  /// Uygulamanın anlık tema modu. Varsayılan olarak koyu mod başlar.
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  ThemeMode get currentThemeMode => themeModeNotifier.value;
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;
  bool get isLightMode => themeModeNotifier.value == ThemeMode.light;
  bool get isSystemMode => themeModeNotifier.value == ThemeMode.system;

  /// Temayı tek tıkla aydınlık / karanlık arasında değiştirir.
  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.dark) {
      themeModeNotifier.value = ThemeMode.light;
    } else {
      themeModeNotifier.value = ThemeMode.dark;
    }
  }

  /// Temayı doğrudan belirtilen moda geçirir.
  void setThemeMode(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }
}
