import 'package:flutter/foundation.dart';

/// Ruh hâli seçeneği modeli.
@immutable
class MoodItem {
  final String emoji;
  final String label;

  const MoodItem({
    required this.emoji,
    required this.label,
  });

  /// Varsayılan sevimli ruh hâli listesi.
  static const List<MoodItem> defaultMoods = [
    MoodItem(emoji: '😊', label: 'Mutlu'),
    MoodItem(emoji: '🥰', label: 'Huzurlu'),
    MoodItem(emoji: '✨', label: 'Heyecanlı'),
    MoodItem(emoji: '🌿', label: 'Rahat'),
    MoodItem(emoji: '☕', label: 'Sakin'),
    MoodItem(emoji: '🤔', label: 'Düşünceli'),
    MoodItem(emoji: '😴', label: 'Yorgun'),
    MoodItem(emoji: '😢', label: 'Hüzünlü'),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodItem &&
          runtimeType == other.runtimeType &&
          emoji == other.emoji &&
          label == other.label;

  @override
  int get hashCode => emoji.hashCode ^ label.hashCode;
}
