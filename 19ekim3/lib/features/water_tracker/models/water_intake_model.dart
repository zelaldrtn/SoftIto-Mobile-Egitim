import 'package:flutter/foundation.dart';

@immutable
class WaterIntakeModel {
  final String id;
  final String beverageName;
  final int amountMl;
  final DateTime timestamp;

  const WaterIntakeModel({
    required this.id,
    required this.beverageName,
    required this.amountMl,
    required this.timestamp,
  });

  WaterIntakeModel copyWith({
    String? id,
    String? beverageName,
    int? amountMl,
    DateTime? timestamp,
  }) {
    return WaterIntakeModel(
      id: id ?? this.id,
      beverageName: beverageName ?? this.beverageName,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      id: json['id'] as String? ?? '',
      beverageName: json['beverageName'] as String? ?? 'Su',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'beverageName': beverageName,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
      };
}
