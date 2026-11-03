import 'package:flutter/foundation.dart';

/// Takvim ızgarasındaki her bir günü temsil eden veri modeli.
// @immutable: gün hücre modelinin alanlarının sonradan değiştirilemeyeceğini belirtir
@immutable
class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEntry;
  final String? moodEmoji;

  // const constructor: sabit gün hücreleri üreterek performansı korur
  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    this.hasEntry = false,
    this.moodEmoji,
  });

  // ayın gün numarasını (1-31) veren pratik getter
  int get dayNumber => date.day;
}

