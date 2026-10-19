import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/home/view/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

/// Uygulama genelinde tema durumunu yöneten tekil denetleyici.
final ThemeController globalThemeController = ThemeController();

/// Uygulama kök widget'ı - sadece başlatma ve dinamik tema yapılandırmasını içerir.
class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: globalThemeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: HomeView(themeController: globalThemeController),
        );
      },
    );
  }
}
