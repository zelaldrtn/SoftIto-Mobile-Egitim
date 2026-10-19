import 'package:flutter/foundation.dart';
import '../models/diary_entry.dart';

/// Günlük verilerini bellek içinde yöneten reaktif kontrolcü.
class DiaryController {
  final ValueNotifier<Map<String, DiaryEntry>> _entriesNotifier;

  DiaryController({Map<String, DiaryEntry>? initialEntries})
      : _entriesNotifier = ValueNotifier<Map<String, DiaryEntry>>(
          initialEntries ?? _createInitialSamples(),
        );

  /// Günlük kayıtlarının dinlenebilir hali.
  ValueListenable<Map<String, DiaryEntry>> get entriesListenable =>
      _entriesNotifier;

  /// Tarihi YYYY-MM-DD standart anahtarına dönüştürür.
  static String dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Belirtilen tarihe ait günlük kaydını getirir.
  DiaryEntry? getEntry(DateTime date) {
    final key = dateToKey(date);
    return _entriesNotifier.value[key];
  }

  /// Belirtilen tarihte günlük kaydı olup olmadığını kontrol eder.
  bool hasEntry(DateTime date) {
    return getEntry(date) != null;
  }

  /// Günlük kaydını ekler veya günceller.
  /// Boş içerik kontrolü yapar; içerik boşsa false döner ve kaydetmez.
  bool saveEntry({
    required DateTime date,
    required String content,
    String? moodEmoji,
  }) {
    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty) {
      return false;
    }

    final key = dateToKey(date);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final entry = DiaryEntry(
      date: normalizedDate,
      content: trimmedContent,
      moodEmoji: moodEmoji,
      updatedAt: DateTime.now(),
    );

    final updatedMap = Map<String, DiaryEntry>.from(_entriesNotifier.value);
    updatedMap[key] = entry;
    _entriesNotifier.value = updatedMap;
    return true;
  }

  /// Belirtilen tarihteki günlüğü siler.
  bool deleteEntry(DateTime date) {
    final key = dateToKey(date);
    if (!_entriesNotifier.value.containsKey(key)) {
      return false;
    }

    final updatedMap = Map<String, DiaryEntry>.from(_entriesNotifier.value);
    updatedMap.remove(key);
    _entriesNotifier.value = updatedMap;
    return true;
  }

  /// Başlangıçta kullanıcıya canlı bir deneyim sunmak için örnek günlükler üretir.
  static Map<String, DiaryEntry> _createInitialSamples() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final sample1 = DiaryEntry(
      date: today,
      content:
          'Bugün DigiDia ile güne harika başladım! Pastel mor tasarım ve takvim üzerinden günlük tutmak çok huzur verici.',
      moodEmoji: '✨',
      updatedAt: now,
    );

    final sample2 = DiaryEntry(
      date: yesterday,
      content:
          'Dün akşam sakin bir kahve eşliğinde kitap okudum. Kendime vakit ayırmak iyi geldi.',
      moodEmoji: '☕',
      updatedAt: now.subtract(const Duration(days: 1)),
    );

    return {
      sample1.dateKey: sample1,
      sample2.dateKey: sample2,
    };
  }

  /// Notifier kaynaklarını serbest bırakır.
  void dispose() {
    _entriesNotifier.dispose();
  }
}
