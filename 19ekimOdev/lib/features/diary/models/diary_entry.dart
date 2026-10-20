import 'package:flutter/foundation.dart';

/// Günlük girdisi veri modeli.
/// İlgili tarih, içerik, isteğe bağlı ruh hâli emojisi ve güncellenme zamanını barındırır.
@immutable
class DiaryEntry {
  final DateTime date;
  final String content;
  final String? moodEmoji;
  final DateTime updatedAt;

  const DiaryEntry({
    required this.date,
    required this.content,
    this.moodEmoji,
    required this.updatedAt,
  });

  /// Tarihi YYYY-MM-DD biçiminde benzersiz anahtara dönüştürür.
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Modelin güncellenmiş yeni bir kopyasını üretir.
  DiaryEntry copyWith({
    DateTime? date,
    String? content,
    String? moodEmoji,
    bool clearMood = false,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      date: date ?? this.date,
      content: content ?? this.content,
      moodEmoji: clearMood ? null : (moodEmoji ?? this.moodEmoji),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntry &&
          runtimeType == other.runtimeType &&
          dateKey == other.dateKey &&
          content == other.content &&
          moodEmoji == other.moodEmoji;

  @override
  int get hashCode => dateKey.hashCode ^ content.hashCode ^ moodEmoji.hashCode;
}
