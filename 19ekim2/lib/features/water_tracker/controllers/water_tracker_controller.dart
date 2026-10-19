import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

/// Su ve hidrasyon takibini ValueNotifier durum mimarisiyle yöneten denetleyici.
class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(1250);
  final ValueNotifier<int> dailyGoalWater = ValueNotifier<int>(2500);
  final ValueNotifier<List<DrinkEntry>> history =
      ValueNotifier<List<DrinkEntry>>(<DrinkEntry>[]);
  final ValueNotifier<List<DailyWaterStats>> weeklyStats =
      ValueNotifier<List<DailyWaterStats>>(<DailyWaterStats>[]);

  WaterTrackerController() {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    final now = DateTime.now();
    history.value = [
      DrinkEntry(
        id: '1',
        title: 'Sabah Suyu',
        amountMl: 500,
        timestamp: now.subtract(const Duration(hours: 5)),
        iconCode: 0xe356, // local_drink
      ),
      DrinkEntry(
        id: '2',
        title: 'Maden Suyu',
        amountMl: 250,
        timestamp: now.subtract(const Duration(hours: 3)),
        iconCode: 0xe356,
      ),
      DrinkEntry(
        id: '3',
        title: 'Antrenman Öncesi Su',
        amountMl: 500,
        timestamp: now.subtract(const Duration(hours: 1)),
        iconCode: 0xe356,
      ),
    ];

    weeklyStats.value = const [
      DailyWaterStats(dayName: 'Pzt', totalMl: 2200, goalMl: 2500),
      DailyWaterStats(dayName: 'Sal', totalMl: 2600, goalMl: 2500),
      DailyWaterStats(dayName: 'Çar', totalMl: 1900, goalMl: 2500),
      DailyWaterStats(dayName: 'Per', totalMl: 2400, goalMl: 2500),
      DailyWaterStats(dayName: 'Cum', totalMl: 2750, goalMl: 2500),
      DailyWaterStats(dayName: 'Cmt', totalMl: 2100, goalMl: 2500),
      DailyWaterStats(dayName: 'Paz', totalMl: 1250, goalMl: 2500),
    ];
  }

  /// Hızlı su ekleme metodu.
  void addWater({int amountMl = 250, String title = 'Su', int iconCode = 0xe356}) {
    currentWater.value += amountMl;
    final newEntry = DrinkEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amountMl: amountMl,
      timestamp: DateTime.now(),
      iconCode: iconCode,
    );
    history.value = [newEntry, ...history.value];
    _updateTodayWeeklyStats();
  }

  /// Kullanıcının kendi belirlediği miktarda özel içecek eklemesi (örn: 300 ml).
  void addCustomDrink(String title, int amountMl, int iconCode) {
    if (amountMl <= 0) return;
    addWater(amountMl: amountMl, title: title, iconCode: iconCode);
  }

  /// Geçmişten içecek kaydını silme.
  void removeEntry(String id) {
    final entryIndex = history.value.indexWhere((e) => e.id == id);
    if (entryIndex != -1) {
      final removed = history.value[entryIndex];
      currentWater.value = (currentWater.value - removed.amountMl).clamp(0, 100000);
      final updatedList = List<DrinkEntry>.from(history.value)..removeAt(entryIndex);
      history.value = updatedList;
      _updateTodayWeeklyStats();
    }
  }

  /// Günlük suyu sıfırlama.
  void resetWater() {
    currentWater.value = 0;
    history.value = [];
    _updateTodayWeeklyStats();
  }

  /// Günlük hedefi güncelleme.
  void setDailyGoal(int newGoal) {
    if (newGoal > 0) {
      dailyGoalWater.value = newGoal;
      _updateTodayWeeklyStats();
    }
  }

  void _updateTodayWeeklyStats() {
    final list = List<DailyWaterStats>.from(weeklyStats.value);
    if (list.isNotEmpty) {
      final lastIndex = list.length - 1;
      list[lastIndex] = DailyWaterStats(
        dayName: list[lastIndex].dayName,
        totalMl: currentWater.value,
        goalMl: dailyGoalWater.value,
      );
      weeklyStats.value = list;
    }
  }

  /// Bellek sızıntılarını önlemek için tüm ValueNotifier nesnelerini dispose eder.
  void dispose() {
    currentWater.dispose();
    dailyGoalWater.dispose();
    history.dispose();
    weeklyStats.dispose();
  }
}
