import 'package:flutter/foundation.dart';

/// Ruh hâli seçimini yöneten reaktif kontrolcü.
// MoodController: seçilen ruh hâli emojisini ValueNotifier ile tutan reaktif kontrolcü
class MoodController {
  // ValueNotifier: seçili emoji değiştiğinde (veya temizlendiğinde) dinleyicileri tetikler
  final ValueNotifier<String?> selectedMoodNotifier;

  MoodController([String? initialMood])
      : selectedMoodNotifier = ValueNotifier<String?>(initialMood);

  String? get selectedMood => selectedMoodNotifier.value;

  /// Ruh hâli emojisini seçer veya aynı emojiyse seçimi kaldırır (toggle).
  // aynı emojiye tekrar basıldığında seçimi iptal eder, farklıysa yeni emojiyi atar
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

