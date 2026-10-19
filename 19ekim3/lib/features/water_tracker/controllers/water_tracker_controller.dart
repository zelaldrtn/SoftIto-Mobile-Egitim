import 'package:flutter/foundation.dart';
import '../models/water_intake_model.dart';

class WaterTrackerController {
  static const int dailyGoalMl = 2000;

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterIntakeModel>> intakeHistory =
      ValueNotifier<List<WaterIntakeModel>>(const []);

  // Son 7 günün su tüketim verileri (grafik için ml cinsinden)
  final ValueNotifier<List<int>> weeklyIntakeData =
      ValueNotifier<List<int>>([1400, 1800, 2200, 1950, 2100, 1750, 0]);

  void addWater([int amountMl = 250]) {
    if (amountMl <= 0) return;
    currentWater.value += amountMl;
    _updateWeeklyToday(amountMl);
    _recordIntake('Su', amountMl);
  }

  void addCustomBeverage(String name, int amountMl) {
    if (amountMl <= 0) return;
    final cleanName = name.trim().isEmpty ? 'Özel İçecek' : name.trim();
    currentWater.value += amountMl;
    _updateWeeklyToday(amountMl);
    _recordIntake(cleanName, amountMl);
  }

  void resetWater() {
    currentWater.value = 0;
    intakeHistory.value = const [];
    final currentList = List<int>.from(weeklyIntakeData.value);
    if (currentList.isNotEmpty) {
      currentList[currentList.length - 1] = 0;
      weeklyIntakeData.value = currentList;
    }
  }

  void _updateWeeklyToday(int amount) {
    final currentList = List<int>.from(weeklyIntakeData.value);
    if (currentList.isNotEmpty) {
      currentList[currentList.length - 1] += amount;
      weeklyIntakeData.value = currentList;
    }
  }

  void _recordIntake(String name, int amountMl) {
    final newEntry = WaterIntakeModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      beverageName: name,
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    intakeHistory.value = [newEntry, ...intakeHistory.value];
  }

  void dispose() {
    currentWater.dispose();
    intakeHistory.dispose();
    weeklyIntakeData.dispose();
  }
}
