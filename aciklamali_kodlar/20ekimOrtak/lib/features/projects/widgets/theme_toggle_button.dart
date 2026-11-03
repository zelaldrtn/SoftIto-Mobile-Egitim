import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';

// kullanıcının tek tıkla karanlık ve aydınlık mod arasında geçiş yapmasını sağlayan buton
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // tema modundaki (Light/Dark/System) değişiklikleri dinliyoruz
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        // o anki temanın koyu modda olup olmadığını kontrol ediyoruz
        final bool isDark = ThemeController.instance.isDarkMode(context);
        return IconButton(
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          icon: Icon(
            // koyu moddaysa güneş ikonu, açık moddaysa ay ikonu gösteriyoruz
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? const Color(0xFFFACC15) : const Color(0xFF1D4ED8),
          ),
          onPressed: () {
            // temayı tersine çeviriyoruz
            ThemeController.instance.toggleTheme(context);
          },
        );
      },
    );
  }
}

