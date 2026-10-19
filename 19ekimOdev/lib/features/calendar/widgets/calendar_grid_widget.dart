import 'package:flutter/material.dart';
import '../../diary/controllers/diary_controller.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar_day.dart';
import 'calendar_day_cell_widget.dart';

/// Takvim ızgarasını oluşturan bileşen.
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
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
