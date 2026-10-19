import 'package:flutter/foundation.dart';

/// Takvim ızgarasındaki her bir günü temsil eden veri modeli.
@immutable
class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEntry;
  final String? moodEmoji;

  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    this.hasEntry = false,
    this.moodEmoji,
  });

  int get dayNumber => date.day;
}
