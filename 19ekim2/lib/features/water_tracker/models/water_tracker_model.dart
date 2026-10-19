/// Su ve içecek kayıtları için veri modeli.
class DrinkEntry {
  final String id;
  final String title;
  final int amountMl;
  final DateTime timestamp;
  final int iconCode;

  const DrinkEntry({
    required this.id,
    required this.title,
    required this.amountMl,
    required this.timestamp,
    required this.iconCode,
  });

  DrinkEntry copyWith({
    String? id,
    String? title,
    int? amountMl,
    DateTime? timestamp,
    int? iconCode,
  }) {
    return DrinkEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  factory DrinkEntry.fromJson(Map<String, dynamic> json) {
    return DrinkEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Su',
      amountMl: json['amountMl'] as int? ?? 250,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      iconCode: json['iconCode'] as int? ?? 0xe356, // Icons.local_drink_rounded
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'iconCode': iconCode,
    };
  }
}

/// Haftalık su takip grafiği veri noktası modeli.
class DailyWaterStats {
  final String dayName;
  final int totalMl;
  final int goalMl;

  const DailyWaterStats({
    required this.dayName,
    required this.totalMl,
    required this.goalMl,
  });

  double get progressRatio => goalMl > 0 ? (totalMl / goalMl).clamp(0.0, 1.5) : 0.0;
}
