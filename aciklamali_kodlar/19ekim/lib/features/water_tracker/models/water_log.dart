import 'package:flutter/foundation.dart';

/// Su tüketim kaydı veri modeli.
// @immutable: bu sınıfın hiçbir alanının sonradan değiştirilemeyeceğini (değişmez/immutable olduğunu) garanti eder
@immutable
// final class: sınıfın dışarıdan miras (extend) alınmasını kısıtlar
final class WaterLog {
  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.label = 'Su',
  });

  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String label;

  // copyWith: var olan nesneyi bozmadan sadece değişen alanları güncelleyerek yeni bir kopya üretir
  WaterLog copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? label,
  }) {
    return WaterLog(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      label: label ?? this.label,
    );
  }

  @override
  // iki nesnenin bellek adresi farklı olsa bile alan değerleri aynıysa eşit sayılmasını sağlar
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLog &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amountMl == other.amountMl &&
          timestamp == other.timestamp;

  @override
  // operator == ile uyumlu çalışacak benzersiz karma sayı üretir
  int get hashCode => Object.hash(id, amountMl, timestamp);
}

