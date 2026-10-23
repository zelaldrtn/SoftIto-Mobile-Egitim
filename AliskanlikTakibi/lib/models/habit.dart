import 'package:flutter/material.dart';

enum HabitCategory {
  saglik('Sağlık', Icons.favorite_rounded, Color(0xFFE57373)),
  spor('Spor', Icons.fitness_center_rounded, Color(0xFF81C784)),
  ogrenme('Öğrenme & Kitap', Icons.menu_book_rounded, Color(0xFF64B5F6)),
  odaklanma('Odaklanma', Icons.timer_rounded, Color(0xFFFFB74D)),
  farkindalik('Farkındalık', Icons.spa_rounded, Color(0xFF4DB6AC)),
  yaraticilik('Yaratıcılık', Icons.palette_rounded, Color(0xFFBA68C8)),
  diger('Genel & Rutin', Icons.check_circle_outline_rounded, Color(0xFFA1887F));

  final String label;
  final IconData icon;
  final Color color;
  const HabitCategory(this.label, this.icon, this.color);
}

enum HabitFrequencyType {
  everyDay('Her Gün'),
  weekdays('Hafta İçi'),
  specificDays('Seçili Günler'),
  weeklyTarget('Haftalık Hedef');

  final String label;
  const HabitFrequencyType(this.label);
}

enum HabitDifficulty {
  veryEasy('Çok Kolay', 3),
  easy('Kolay', 5),
  medium('Orta', 10),
  hard('Zor', 15);

  final String label;
  final int points;
  const HabitDifficulty(this.label, this.points);
}

class Habit {
  final String id;
  final String name;
  final String goal;
  final HabitCategory category;
  final int iconCodePoint;
  final HabitFrequencyType frequencyType;
  final List<int> selectedDays; // 1 = Monday, 7 = Sunday
  final int targetDaysPerWeek; // e.g. 3 for weekly target
  final HabitDifficulty difficulty;
  final int points; // Automatically computed from difficulty
  final String? reminderTime; // e.g. "08:30"
  final bool isPaused;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.goal,
    required this.category,
    required this.iconCodePoint,
    required this.frequencyType,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    this.targetDaysPerWeek = 7,
    required this.difficulty,
    int? points,
    this.reminderTime,
    this.isPaused = false,
    DateTime? createdAt,
  })  : points = points ?? difficulty.points,
        createdAt = createdAt ?? DateTime.now();

  // Helper method to check if this habit is scheduled for a given date
  bool isScheduledForDate(DateTime date) {
    if (isPaused) return false;
    final weekday = date.weekday; // 1 (Mon) to 7 (Sun)
    switch (frequencyType) {
      case HabitFrequencyType.everyDay:
        return true;
      case HabitFrequencyType.weekdays:
        return weekday >= 1 && weekday <= 5;
      case HabitFrequencyType.specificDays:
        return selectedDays.contains(weekday);
      case HabitFrequencyType.weeklyTarget:
        return true;
    }
  }

  Habit copyWith({
    String? id,
    String? name,
    String? goal,
    HabitCategory? category,
    int? iconCodePoint,
    HabitFrequencyType? frequencyType,
    List<int>? selectedDays,
    int? targetDaysPerWeek,
    HabitDifficulty? difficulty,
    int? points,
    String? reminderTime,
    bool? isPaused,
    DateTime? createdAt,
  }) {
    final diff = difficulty ?? this.difficulty;
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      category: category ?? this.category,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      frequencyType: frequencyType ?? this.frequencyType,
      selectedDays: selectedDays ?? this.selectedDays,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      difficulty: diff,
      points: points ?? diff.points,
      reminderTime: reminderTime ?? this.reminderTime,
      isPaused: isPaused ?? this.isPaused,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'category': category.name,
      'iconCodePoint': iconCodePoint,
      'frequencyType': frequencyType.name,
      'selectedDays': selectedDays,
      'targetDaysPerWeek': targetDaysPerWeek,
      'difficulty': difficulty.name,
      'points': points,
      'reminderTime': reminderTime,
      'isPaused': isPaused,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    HabitCategory cat = HabitCategory.diger;
    try {
      cat = HabitCategory.values.firstWhere((e) => e.name == map['category']);
    } catch (_) {}

    HabitFrequencyType freq = HabitFrequencyType.everyDay;
    try {
      freq = HabitFrequencyType.values.firstWhere((e) => e.name == map['frequencyType']);
    } catch (_) {}

    HabitDifficulty diff = HabitDifficulty.easy;
    try {
      diff = HabitDifficulty.values.firstWhere((e) => e.name == map['difficulty']);
    } catch (_) {}

    return Habit(
      id: map['id'] as String,
      name: map['name'] as String,
      goal: (map['goal'] as String?) ?? '',
      category: cat,
      iconCodePoint: (map['iconCodePoint'] as int?) ?? Icons.star_rounded.codePoint,
      frequencyType: freq,
      selectedDays: (map['selectedDays'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [1, 2, 3, 4, 5, 6, 7],
      targetDaysPerWeek: (map['targetDaysPerWeek'] as int?) ?? 7,
      difficulty: diff,
      points: (map['points'] as int?) ?? diff.points,
      reminderTime: map['reminderTime'] as String?,
      isPaused: (map['isPaused'] as bool?) ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
