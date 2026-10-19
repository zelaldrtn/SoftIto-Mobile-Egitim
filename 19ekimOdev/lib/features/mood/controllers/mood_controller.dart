import 'package:flutter/foundation.dart';

/// Ruh hâli seçimini yöneten reaktif kontrolcü.
class MoodController {
  final ValueNotifier<String?> selectedMoodNotifier;

  MoodController([String? initialMood])
      : selectedMoodNotifier = ValueNotifier<String?>(initialMood);

  String? get selectedMood => selectedMoodNotifier.value;

  /// Ruh hâli emojisini seçer veya aynı emojiyse seçimi kaldırır (toggle).
  void toggleMood(String emoji) {
    if (selectedMoodNotifier.value == emoji) {
      selectedMoodNotifier.value = null;
    } else {
      selectedMoodNotifier.value = emoji;
    }
  }

  /// Doğrudan bir ruh hâli ayarlar.
  void setMood(String? emoji) {
    selectedMoodNotifier.value = emoji;
  }

  /// Seçimi temizler.
  void clear() {
    selectedMoodNotifier.value = null;
  }

  /// Notifier kaynaklarını serbest bırakır.
  void dispose() {
    selectedMoodNotifier.dispose();
  }
}
