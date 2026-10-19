import 'package:flutter/foundation.dart';

/// Takvim odak ayı ve seçili tarihi yöneten reaktif kontrolcü.
class CalendarController {
  final ValueNotifier<DateTime> focusedMonthNotifier;
  final ValueNotifier<DateTime> selectedDateNotifier;

  CalendarController({DateTime? initialDate})
      : focusedMonthNotifier = ValueNotifier<DateTime>(
          _normalizeMonth(initialDate ?? DateTime.now()),
        ),
        selectedDateNotifier = ValueNotifier<DateTime>(
          _normalizeDate(initialDate ?? DateTime.now()),
        );

  DateTime get focusedMonth => focusedMonthNotifier.value;
  DateTime get selectedDate => selectedDateNotifier.value;

  /// Tarihi yıl-ay-1 olacak şekilde normalleştirir.
  static DateTime _normalizeMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Tarihi yıl-ay-gün olacak şekilde normalleştirir.
  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Önceki aya geçer.
  void previousMonth() {
    final current = focusedMonthNotifier.value;
    focusedMonthNotifier.value = DateTime(current.year, current.month - 1, 1);
  }

  /// Sonraki aya geçer.
  void nextMonth() {
    final current = focusedMonthNotifier.value;
    focusedMonthNotifier.value = DateTime(current.year, current.month + 1, 1);
  }

  /// Belirtilen günü seçer ve gerekirse odak ayını günceller.
  void selectDate(DateTime date) {
    final normalized = _normalizeDate(date);
    selectedDateNotifier.value = normalized;

    // Eğer seçilen tarih odak ayının dışındaysa, odak ayını da güncelle
    if (date.year != focusedMonth.year || date.month != focusedMonth.month) {
      focusedMonthNotifier.value = _normalizeMonth(date);
    }
  }

  /// Bugünkü tarihe ve geçerli aya geri döner.
  void goToToday() {
    final now = DateTime.now();
    selectDate(now);
  }

  /// Notifier kaynaklarını serbest bırakır.
  void dispose() {
    focusedMonthNotifier.dispose();
    selectedDateNotifier.dispose();
  }
}
