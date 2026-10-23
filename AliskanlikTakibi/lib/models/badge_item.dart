import 'package:flutter/material.dart';

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final int iconCodePoint;
  final int requiredStreak;
  final int requiredTotalCompletions;
  final int requiredPoints;
  final int requiredRoomItems;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    this.requiredStreak = 0,
    this.requiredTotalCompletions = 0,
    this.requiredPoints = 0,
    this.requiredRoomItems = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  BadgeItem copyWith({
    String? id,
    String? title,
    String? description,
    int? iconCodePoint,
    int? requiredStreak,
    int? requiredTotalCompletions,
    int? requiredPoints,
    int? requiredRoomItems,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return BadgeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      requiredStreak: requiredStreak ?? this.requiredStreak,
      requiredTotalCompletions: requiredTotalCompletions ?? this.requiredTotalCompletions,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      requiredRoomItems: requiredRoomItems ?? this.requiredRoomItems,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'requiredStreak': requiredStreak,
      'requiredTotalCompletions': requiredTotalCompletions,
      'requiredPoints': requiredPoints,
      'requiredRoomItems': requiredRoomItems,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory BadgeItem.fromMap(Map<String, dynamic> map) {
    return BadgeItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      iconCodePoint: (map['iconCodePoint'] as int?) ?? Icons.emoji_events_rounded.codePoint,
      requiredStreak: (map['requiredStreak'] as int?) ?? 0,
      requiredTotalCompletions: (map['requiredTotalCompletions'] as int?) ?? 0,
      requiredPoints: (map['requiredPoints'] as int?) ?? 0,
      requiredRoomItems: (map['requiredRoomItems'] as int?) ?? 0,
      isUnlocked: (map['isUnlocked'] as bool?) ?? false,
      unlockedAt: DateTime.tryParse(map['unlockedAt'] as String? ?? ''),
    );
  }
}
