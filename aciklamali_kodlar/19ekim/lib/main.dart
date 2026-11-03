import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

// uygulamanın başlangıç noktası
void main() {
  // ana widget'ı ekrana çizerek uygulamayı başlatır
  runApp(const SusadimApp());
}

/// Susadım uygulaması kök widget'ı.
// StatelessWidget: durumu değişmeyen ana uygulama çatısı
class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  // build metodu widget'ın ekrandaki görünümünü kurar
  Widget build(BuildContext context) {
    // MaterialApp: uygulamanın tema, sayfa yönlendirme ve başlık gibi temel ayarlarını barındırır
    return MaterialApp(
      title: 'Susadım',
      // sağ üstteki debug bandını gizler
      debugShowCheckedModeBanner: false,
      // uygulamanın varsayılan koyu temasını belirler
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      // tema modunu zorunlu olarak koyu (dark) yapar
      themeMode: ThemeMode.dark,
      // uygulama açıldığında ilk açılacak ana sayfa
      home: const HomeScreen(),
    );
  }
}

