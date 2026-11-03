// bir alışkanlığın belirli bir günde tamamlandığını kaydeden günlük geçmiş kaydı modeli
class HabitLog {
  final String id;
  final String habitId;
  final String date; // 'YYYY-MM-DD' formatında tarih dizesi
  final int pointsEarned;
  final DateTime completedAt;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.pointsEarned,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  // DateTime nesnesini 'YYYY-MM-DD' şeklinde sabit uzunluklu metne dönüştüren yardımcı fonksiyon
  static String formatDate(DateTime dt) {
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // veritabanına veya hafızaya yazmak için harita dönüştürücü
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date,
      'pointsEarned': pointsEarned,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  // haritadan HabitLog nesnesi inşa eden fabrika metodu
  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'] as String,
      habitId: map['habitId'] as String,
      date: map['date'] as String,
      pointsEarned: (map['pointsEarned'] as int?) ?? 0,
      completedAt: DateTime.tryParse(map['completedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

