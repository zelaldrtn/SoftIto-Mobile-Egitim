import 'package:flutter/foundation.dart';

/// Egzersiz yoğunluk seviyeleri.
enum WorkoutIntensity { low, medium, high }

/// Egzersiz ve antrenman seansı veri modeli.
@immutable
final class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    this.intensity = WorkoutIntensity.medium,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final WorkoutIntensity intensity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          durationMinutes == other.durationMinutes &&
          caloriesBurned == other.caloriesBurned &&
          timestamp == other.timestamp &&
          intensity == other.intensity;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        durationMinutes,
        caloriesBurned,
        timestamp,
        intensity,
      );
}
