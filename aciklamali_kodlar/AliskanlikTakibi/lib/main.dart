import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/storage_service.dart';
import 'services/habit_provider.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

// uygulamanın asenkron başlangıç noktası
void main() async {
  // asenkron işlemler başlamadan önce Flutter motorunun hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // Türkçe tarih formatlama desteğini (gün ve ay isimleri) yüklüyoruz
  await initializeDateFormatting('tr_TR', null);

  // SharedPreferences tabanlı yerel depolama servisini başlatıyoruz
  final storageService = await StorageService.init();

  // MultiProvider ile durum yönetimi sağlayıcılarını tüm uygulama ağacının tepesine bağlıyoruz
  runApp(
    MultiProvider(
      providers: [
        // HabitProvider değiştiğinde dinleyen tüm ekranların yeniden çizilmesini sağlar
        ChangeNotifierProvider(
          create: (_) => HabitProvider(storageService),
        ),
      ],
      child: const DoItApp(),
    ),
  );
}

// uygulamanın ana kök widget'ı
class DoItApp extends StatelessWidget {
  const DoItApp({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch ile tema modundaki değişimleri dinliyoruz
    final provider = context.watch<HabitProvider>();

    return MaterialApp(
      title: 'DO IT',
      debugShowCheckedModeBanner: false,
      // aydınlık ve karanlık tema tanımları
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // kullanıcının seçtiği sistem, açık veya koyu mod
      themeMode: provider.themeMode,
      // uygulamanın ana ekranı
      home: const MainNavigationScreen(),
    );
  }
}

