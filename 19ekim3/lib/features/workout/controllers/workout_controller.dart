import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<int> totalCalories = ValueNotifier<int>(0);
  final ValueNotifier<int> totalMinutes = ValueNotifier<int>(0);
  final ValueNotifier<List<WorkoutModel>> workouts =
      ValueNotifier<List<WorkoutModel>>(const []);

  // Son 7 günün yakılan kalori verileri (grafik için)
  final ValueNotifier<List<int>> weeklyCalorieData =
      ValueNotifier<List<int>>([350, 420, 500, 300, 600, 450, 0]);

  void addWorkout(String title, int durationMinutes, int calories) {
    if (durationMinutes <= 0 || calories <= 0) return;

    final entry = WorkoutModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Genel Egzersiz' : title.trim(),
      durationMinutes: durationMinutes,
      caloriesBurned: calories,
      timestamp: DateTime.now(),
    );

    totalCalories.value += calories;
    totalMinutes.value += durationMinutes;
    workouts.value = [entry, ...workouts.value];

    final currentList = List<int>.from(weeklyCalorieData.value);
    if (currentList.isNotEmpty) {
      currentList[currentList.length - 1] += calories;
      weeklyCalorieData.value = currentList;
    }
  }

  void resetWorkouts() {
    totalCalories.value = 0;
    totalMinutes.value = 0;
    workouts.value = const [];
    final currentList = List<int>.from(weeklyCalorieData.value);
    if (currentList.isNotEmpty) {
      currentList[currentList.length - 1] = 0;
      weeklyCalorieData.value = currentList;
    }
  }

  void dispose() {
    totalCalories.dispose();
    totalMinutes.dispose();
    workouts.dispose();
    weeklyCalorieData.dispose();
  }
}
