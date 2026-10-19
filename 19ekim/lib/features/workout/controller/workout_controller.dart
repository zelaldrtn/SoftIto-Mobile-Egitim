import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';

/// Egzersiz ve kalori takibi için yerel durum yöneticisi.
class WorkoutController extends ChangeNotifier {
  WorkoutController({
    this.dailyCalorieTarget = 600,
    this.dailyDurationTargetMinutes = 45,
  });

  int dailyCalorieTarget;
  int dailyDurationTargetMinutes;
  final List<WorkoutSession> _sessions = <WorkoutSession>[];

  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

  int get totalCalories =>
      _sessions.fold<int>(0, (sum, item) => sum + item.caloriesBurned);

  int get totalMinutes =>
      _sessions.fold<int>(0, (sum, item) => sum + item.durationMinutes);

  double get calorieProgress => dailyCalorieTarget == 0
      ? 0.0
      : (totalCalories / dailyCalorieTarget).clamp(0.0, 1.0);

  double get durationProgress => dailyDurationTargetMinutes == 0
      ? 0.0
      : (totalMinutes / dailyDurationTargetMinutes).clamp(0.0, 1.0);

  int get remainingCalories =>
      (dailyCalorieTarget - totalCalories).clamp(0, dailyCalorieTarget);

  bool get isCalorieGoalReached => totalCalories >= dailyCalorieTarget;

  void addSession({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    WorkoutIntensity intensity = WorkoutIntensity.medium,
  }) {
    if (durationMinutes <= 0 || caloriesBurned <= 0) return;
    final session = WorkoutSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      intensity: intensity,
    );
    _sessions.insert(0, session);
    notifyListeners();
  }

  void removeSession(String id) {
    _sessions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void resetDaily() {
    _sessions.clear();
    notifyListeners();
  }
}
