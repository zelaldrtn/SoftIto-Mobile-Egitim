import 'package:flutter/foundation.dart';

@immutable
class WorkoutModel {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  WorkoutModel copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'timestamp': timestamp.toIso8601String(),
      };
}
