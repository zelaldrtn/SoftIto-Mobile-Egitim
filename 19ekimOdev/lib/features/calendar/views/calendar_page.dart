import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../diary/controllers/diary_controller.dart';
import '../../diary/views/diary_editor_page.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/calendar_grid_widget.dart';
import '../widgets/calendar_header_widget.dart';
import '../widgets/calendar_weekday_headers_widget.dart';
import '../widgets/selected_day_preview_widget.dart';

/// DigiDia v1 ana takvim ve günlük ekranı.
class CalendarPage extends StatelessWidget {
  final CalendarController calendarController;
  final DiaryController diaryController;
  final ThemeController themeController;

  const CalendarPage({
    super.key,
    required this.calendarController,
    required this.diaryController,
    required this.themeController,
  });

  void _openDiary(BuildContext context, DateTime date) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryEditorPage(
          date: date,
          diaryController: diaryController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CalendarAppBar(themeController: themeController),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              CalendarHeaderWidget(controller: calendarController),
              const CalendarWeekdayHeadersWidget(),
              CalendarGridWidget(
                calendarController: calendarController,
                diaryController: diaryController,
                onDaySelected: (date) {},
              ),
              const SizedBox(height: 12),
              SelectedDayPreviewWidget(
                calendarController: calendarController,
                diaryController: diaryController,
                onOpenDiary: () => _openDiary(context, calendarController.selectedDate),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDiary(context, calendarController.selectedDate),
        icon: const Icon(Icons.edit_note, size: 24),
        label: const Text('Günlük Yaz'),
      ),
    );
  }
}

class _CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeController themeController;

  const _CalendarAppBar({required this.themeController});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/icons/app_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.book_rounded),
          ),
        ),
      ),
      title: const Text('DigiDia v1'),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeController,
          builder: (context, currentMode, _) {
            final isDark = currentMode == ThemeMode.dark;
            return IconButton(
              tooltip: isDark ? 'Gündüz Temasına Geç' : 'Gece Temasına Geç',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.amberAccent : Theme.of(context).colorScheme.primary,
              ),
              onPressed: themeController.toggleTheme,
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
