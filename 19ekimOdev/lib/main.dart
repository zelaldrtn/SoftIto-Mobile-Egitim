import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/calendar/controllers/calendar_controller.dart';
import 'features/calendar/views/calendar_page.dart';
import 'features/diary/controllers/diary_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigiDiaApp());
}

/// DigiDia v1 ana uygulama kök widget'ı.
class DigiDiaApp extends StatefulWidget {
  const DigiDiaApp({super.key});

  @override
  State<DigiDiaApp> createState() => _DigiDiaAppState();
}

class _DigiDiaAppState extends State<DigiDiaApp> {
  late final ThemeController _themeController;
  late final DiaryController _diaryController;
  late final CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _diaryController = DiaryController();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _diaryController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'DigiDia v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
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
