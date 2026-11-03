import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/models/user_model.dart';
import 'features/auth/views/login_view.dart';
import 'features/home/home_navigation_shell.dart';

void main() {
  // Flutter motoru ve widget bağlarını uygulama başlamadan önce güvenceye alıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // uygulamayı başlatan kök fonksiyon
  runApp(const AracKiralamaApp());
}

/// Araç Kiralama uygulaması kök widget'ı.
class AracKiralamaApp extends StatelessWidget {
  const AracKiralamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // tema modundaki (açık/koyu) değişiklikleri anlık dinleyip MaterialApp'ı yeniden oluşturan dinleyici
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode mode, _) {
        return MaterialApp(
          title: 'Araç Kiralama',
          // sağ üst köşedeki hata ayıklama bandını gizler
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // o an geçerli olan tema modu (light, dark ya da system)
          themeMode: mode,
          home: const _AuthGate(),
        );
      },
    );
  }
}

// oturum durumuna göre kullanıcıyı giriş sayfasına veya ana sayfaya yönlendiren kapı widget'ı
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    // aktif kullanıcı bilgisini dinliyoruz, kullanıcı değiştiğinde veya çıkış yaptığında ekran otomatik güncellenir
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        // henüz giriş yapılmamışsa giriş ekranı açılır
        if (user == null) {
          return const LoginView();
        }
        // oturum açılmışsa alt sekmeleri olan ana kabuk ekranına yönlendirilir
        return const HomeNavigationShell();
      },
    );
  }
}

