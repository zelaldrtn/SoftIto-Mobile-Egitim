import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve yakılan kalori durumunu ValueNotifier ile yöneten denetleyici.
class WorkoutController {
  final ValueNotifier<int> todayCalories = ValueNotifier<int>(420);
  final ValueNotifier<int> todayMinutes = ValueNotifier<int>(55);
  final ValueNotifier<int> dailyCalorieGoal = ValueNotifier<int>(600);
  final ValueNotifier<List<WorkoutEntry>> workouts =
      ValueNotifier<List<WorkoutEntry>>(<WorkoutEntry>[]);
  final ValueNotifier<List<DailyWorkoutStats>> weeklyStats =
      ValueNotifier<List<DailyWorkoutStats>>(<DailyWorkoutStats>[]);

  WorkoutController() {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    final now = DateTime.now();
    workouts.value = [
      WorkoutEntry(
        id: '1',
        title: 'Sabah Koşusu',
        durationMinutes: 25,
        caloriesBurned: 240,
        timestamp: now.subtract(const Duration(hours: 4)),
        intensity: 'Yüksek',
      ),
      WorkoutEntry(
        id: '2',
        title: 'Ağırlık & Hiit',
        durationMinutes: 30,
        caloriesBurned: 180,
        timestamp: now.subtract(const Duration(hours: 2)),
        intensity: 'Orta',
      ),
    ];

    weeklyStats.value = const [
      DailyWorkoutStats(dayName: 'Pzt', calories: 520, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Sal', calories: 650, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Çar', calories: 480, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Per', calories: 590, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Cum', calories: 710, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Cmt', calories: 450, targetCalories: 600),
      DailyWorkoutStats(dayName: 'Paz', calories: 420, targetCalories: 600),
    ];
  }

  /// Yeni egzersiz ekleme metodu.
  void addWorkout(
    String title,
    int durationMinutes,
    int caloriesBurned,
    String intensity,
  ) {
    final newEntry = WorkoutEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      intensity: intensity,
    );

    workouts.value = [newEntry, ...workouts.value];
    todayCalories.value += caloriesBurned;
    todayMinutes.value += durationMinutes;
    _updateTodayWeeklyStats();
  }

  /// Egzersiz kaydı silme.
  void removeWorkout(String id) {
    final index = workouts.value.indexWhere((w) => w.id == id);
    if (index != -1) {
      final removed = workouts.value[index];
      todayCalories.value =
          (todayCalories.value - removed.caloriesBurned).clamp(0, 100000);
      todayMinutes.value =
          (todayMinutes.value - removed.durationMinutes).clamp(0, 100000);
      final list = List<WorkoutEntry>.from(workouts.value)..removeAt(index);
      workouts.value = list;
      _updateTodayWeeklyStats();
    }
  }

  /// Günlük egzersizleri sıfırlama.
  void resetWorkout() {
    todayCalories.value = 0;
    todayMinutes.value = 0;
    workouts.value = [];
    _updateTodayWeeklyStats();
  }

  void _updateTodayWeeklyStats() {
    final list = List<DailyWorkoutStats>.from(weeklyStats.value);
    if (list.isNotEmpty) {
      final lastIndex = list.length - 1;
      list[lastIndex] = DailyWorkoutStats(
        dayName: list[lastIndex].dayName,
        calories: todayCalories.value,
        targetCalories: dailyCalorieGoal.value,
      );
      weeklyStats.value = list;
    }
  }

  /// Kaynakları serbest bırakma.
  void dispose() {
    todayCalories.dispose();
    todayMinutes.dispose();
    dailyCalorieGoal.dispose();
    workouts.dispose();
    weeklyStats.dispose();
  }
}
