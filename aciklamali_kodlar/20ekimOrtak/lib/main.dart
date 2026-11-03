import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/models/user_model.dart';
import 'features/auth/views/login_view.dart';
import 'features/projects/controllers/projects_controller.dart';
import 'features/projects/views/home_view.dart';

// uygulamanın başlangıç noktası
void main() {
  // Flutter motoru ve widget ağacı köprüsünün hazır olmasını garanti eder
  WidgetsFlutterBinding.ensureInitialized();
  // projeler kontrolcüsünü ayağa kaldırıp başlangıç verilerini yükler
  ProjectsController.instance.initialize();
  // kök widget'ı ekrana çizerek uygulamayı başlatır
  runApp(const DestekBulApp());
}

/// Destek Bul ana uygulama kök widget'ı.
/// Yatırımcı & Girişimci login durumunu ve temayı reaktif yönetir.
// StatelessWidget: tema ve kullanıcı oturumu durumuna göre ana çatıyı kuran sabit widget
class DestekBulApp extends StatelessWidget {
  const DestekBulApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: tema modu (açık/koyu) değiştikçe MaterialApp'i yeniler
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode themeMode, _) {
        // ValueListenableBuilder: kullanıcı giriş/çıkış yaptıkça sayfayı otomatik değiştirir
        return ValueListenableBuilder<UserModel?>(
          valueListenable: AuthController.instance.currentUserNotifier,
          builder: (BuildContext context, UserModel? user, _) {
            // MaterialApp: temel tema, sayfa yönlendirme ve başlık ayarlarını tutar
            return MaterialApp(
              title: 'Destek Bul',
              // sağ üstteki debug bandını gizler
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              // kullanıcı giriş yapmamışsa LoginView, yapmışsa HomeView ekranını gösterir
              home: user == null ? const LoginView() : const HomeView(),
            );
          },
        );
      },
    );
  }
}

