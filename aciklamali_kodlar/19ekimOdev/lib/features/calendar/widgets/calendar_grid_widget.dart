import 'package:flutter/material.dart';
import '../../diary/controllers/diary_controller.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar_day.dart';
import 'calendar_day_cell_widget.dart';

/// Takvim ızgarasını oluşturan bileşen.
// StatelessWidget: ayın 42 günlük takvim matrisini 7 sütunlu ızgara olarak çizen widget
class CalendarGridWidget extends StatelessWidget {
  final CalendarController calendarController;
  final DiaryController diaryController;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarGridWidget({
    super.key,
    required this.calendarController,
    required this.diaryController,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: odak ayı, seçili gün veya günlük kayıtları değiştikçe ızgarayı otomatik günceller
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.focusedMonthNotifier,
      builder: (context, focusedMonth, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: calendarController.selectedDateNotifier,
          builder: (context, selectedDate, _) {
            return ValueListenableBuilder(
              valueListenable: diaryController.entriesListenable,
              builder: (context, entries, _) {
                final days = _calculateCalendarDays(focusedMonth, selectedDate, diaryController);
                return _buildGrid(days);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGrid(List<CalendarDay> days) {
    // GridView.builder: 42 günlük takvim hücrelerini performanslı çizen ızgara
    return GridView.builder(
      // shrinkWrap: GridView'in dikeyde yalnızca hücreleri kadar yer kaplamasını sağlar
      shrinkWrap: true,
      // NeverScrollableScrollPhysics: takvimin dış kaydırma ile çakışmasını engeller
      physics: const NeverScrollableScrollPhysics(),
      // EdgeInsets: ızgaranın sağına ve soluna 12 birim boşluk bırakır
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // crossAxisCount: haftanın 7 günü için 7 sütun açar
        crossAxisCount: 7,
        // childAspectRatio: 1.0 ile hücreleri tam kare yapar
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return CalendarDayCellWidget(
          day: day,
          onTap: () {
            calendarController.selectDate(day.date);
            onDaySelected(day.date);
          },
        );
      },
    );
  }

  // seçili ayın pazartesi başlangıçlı 42 günlük takvim matrisini hesaplar
  static List<CalendarDay> _calculateCalendarDays(
    DateTime month,
    DateTime selectedDate,
    DiaryController diaryController,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    
    // Pazartesi = 1, Pazar = 7. Pazartesiden önceki gün sayısı
    final daysBefore = firstDayOfMonth.weekday - 1;
    final gridStartDate = firstDayOfMonth.subtract(Duration(days: daysBefore));

    final days = <CalendarDay>[];
    // 6 satır x 7 gün = toplam 42 hücre üretir
    for (int i = 0; i < 42; i++) {
      final date = DateTime(
        gridStartDate.year,
        gridStartDate.month,
        gridStartDate.day + i,
      );
      final isCurrentMonth = date.month == month.month && date.year == month.year;
      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
      
      final entry = diaryController.getEntry(date);

      days.add(CalendarDay(
        date: date,
        isCurrentMonth: isCurrentMonth,
        isToday: isToday,
        isSelected: isSelected,
        hasEntry: entry != null,
        moodEmoji: entry?.moodEmoji,
      ));
    }
    return days;
  }
}

