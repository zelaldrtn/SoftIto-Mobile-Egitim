import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';

/// Kullanıcının tek tıkla karanlık ve aydınlık mod arasında geçiş yapmasını sağlayan buton.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        final bool isDark = ThemeController.instance.isDarkMode(context);
        return IconButton(
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? const Color(0xFFFACC15) : const Color(0xFF1D4ED8),
          ),
          onPressed: () {
            ThemeController.instance.toggleTheme(context);
          },
        );
      },
    );
  }
}
