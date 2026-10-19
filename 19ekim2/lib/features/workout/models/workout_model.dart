/// Egzersiz ve antrenman kayıtları modeli.
class WorkoutEntry {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final String intensity;

  const WorkoutEntry({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    required this.intensity,
  });

  WorkoutEntry copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
    String? intensity,
  }) {
    return WorkoutEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      intensity: intensity ?? this.intensity,
    );
  }

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Antrenman',
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      caloriesBurned: json['caloriesBurned'] as int? ?? 200,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      intensity: json['intensity'] as String? ?? 'Orta',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(),
      'intensity': intensity,
    };
  }
}

/// Haftalık yakılan kalori istatistik veri noktası modeli.
class DailyWorkoutStats {
  final String dayName;
  final int calories;
  final int targetCalories;

  const DailyWorkoutStats({
    required this.dayName,
    required this.calories,
    required this.targetCalories,
  });
}
