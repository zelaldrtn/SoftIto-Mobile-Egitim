import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/calendar/controllers/calendar_controller.dart';
import 'features/calendar/views/calendar_page.dart';
import 'features/diary/controllers/diary_controller.dart';

// uygulamanın giriş noktası
void main() {
  // Flutter motoru ile widget ağacı arasındaki bağlantının hazır olmasını sağlar
  WidgetsFlutterBinding.ensureInitialized();
  // kök widget'ı ekrana çizerek uygulamayı başlatır
  runApp(const DigiDiaApp());
}

/// DigiDia v1 ana uygulama kök widget'ı.
// StatefulWidget: tema, takvim ve günlük durum yöneticilerini (controller) yaşam döngüsünde tutan ana yapı
class DigiDiaApp extends StatefulWidget {
  const DigiDiaApp({super.key});

  @override
  State<DigiDiaApp> createState() => _DigiDiaAppState();
}

class _DigiDiaAppState extends State<DigiDiaApp> {
  // late: controller nesnelerinin hemen değil initState içinde başlatılacağını belirtir
  late final ThemeController _themeController;
  late final DiaryController _diaryController;
  late final CalendarController _calendarController;

  @override
  // initState: uygulama açıldığında bir kez çalışır ve durum yöneticilerini ayağa kaldırır
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _diaryController = DiaryController();
    _calendarController = CalendarController();
  }

  @override
  // dispose: uygulama kapandığında controller'ları kapatıp bellek sızıntısını önler
  void dispose() {
    _themeController.dispose();
    _diaryController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: _themeController değeri (açık/koyu tema) her değiştiğinde MaterialApp'i yeniler
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, themeMode, _) {
        // MaterialApp: genel tema, gezinme ve başlık ayarlarını tutan çatı widget
        return MaterialApp(
          title: 'DigiDia v1',
          // sağ üstteki debug bandını gizler
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // seçili olan tema modunu (light/dark) uygular
          themeMode: themeMode,
          // uygulamanın başlangıç sayfası (Takvim Sayfası)
          home: CalendarPage(
            calendarController: _calendarController,
            diaryController: _diaryController,
            themeController: _themeController,
          ),
        );
      },
    );
  }
}

