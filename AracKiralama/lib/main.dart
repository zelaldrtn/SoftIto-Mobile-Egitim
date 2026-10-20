import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/models/user_model.dart';
import 'features/auth/views/login_view.dart';
import 'features/home/home_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AracKiralamaApp());
}

/// Araç Kiralama uygulaması kök widget'ı.
class AracKiralamaApp extends StatelessWidget {
  const AracKiralamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode mode, _) {
        return MaterialApp(
          title: 'Araç Kiralama',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const _AuthGate(),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        if (user == null) {
          return const LoginView();
        }
        return const HomeNavigationShell();
      },
    );
  }
}
