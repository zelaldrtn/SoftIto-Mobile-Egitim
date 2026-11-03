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
// StatelessWidget: takvim bileşenlerini ve günlük özetini ekranda toplayan ana sayfa
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

  // günlük yazma sayfasına geçişi sağlayan yardımcı yönlendirme fonksiyonu
  void _openDiary(BuildContext context, DateTime date) {
    // Navigator.push: kullanıcıyı günlük düzenleme ekranına taşır
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
    // Scaffold: sayfanın temel yapısını (appBar, body, floatingActionButton) kurar
    return Scaffold(
      appBar: _CalendarAppBar(themeController: themeController),
      // SafeArea: çentik ve alt navigasyon çubuğu gibi sistem alanlarına taşmayı önler
      body: SafeArea(
        // SingleChildScrollView: küçük ekranlarda taşmayı önleyerek kaydırma imkanı tanır
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox: araya 8 birim dikey boşluk bırakır
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
      // FloatingActionButton.extended: simgeli ve etiketli genişletilmiş yüzen aksiyon butonu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDiary(context, calendarController.selectedDate),
        icon: const Icon(Icons.edit_note, size: 24),
        label: const Text('Günlük Yaz'),
      ),
    );
  }
}

// PreferredSizeWidget: AppBar'ın standart yükseklik (kToolbarHeight) bilgisine sahip olmasını sağlar
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
        // ClipRRect: köşe yuvarlatılmış logo alanı
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/icons/app_logo.png',
            fit: BoxFit.cover,
            // errorBuilder: resim dosyası bulunamazsa varsayılan kitap ikonu gösterir
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.book_rounded),
          ),
        ),
      ),
      title: const Text('DigiDia v1'),
      actions: [
        // ValueListenableBuilder: tema değiştiğinde sadece tema değiştirme butonunu günceller
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

