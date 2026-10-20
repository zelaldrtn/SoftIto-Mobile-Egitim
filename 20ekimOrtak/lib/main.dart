import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/models/user_model.dart';
import 'features/auth/views/login_view.dart';
import 'features/projects/controllers/projects_controller.dart';
import 'features/projects/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ProjectsController.instance.initialize();
  runApp(const DestekBulApp());
}

/// Destek Bul ana uygulama kök widget'ı.
/// Yatırımcı & Girişimci login durumunu ve temayı reaktif yönetir.
class DestekBulApp extends StatelessWidget {
  const DestekBulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode themeMode, _) {
        return ValueListenableBuilder<UserModel?>(
          valueListenable: AuthController.instance.currentUserNotifier,
          builder: (BuildContext context, UserModel? user, _) {
            return MaterialApp(
              title: 'Destek Bul',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: user == null ? const LoginView() : const HomeView(),
            );
          },
        );
      },
    );
  }
}
