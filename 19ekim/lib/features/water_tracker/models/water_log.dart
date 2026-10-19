import 'package:flutter/foundation.dart';

/// Su tüketim kaydı veri modeli.
@immutable
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLog &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amountMl == other.amountMl &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(id, amountMl, timestamp);
}
