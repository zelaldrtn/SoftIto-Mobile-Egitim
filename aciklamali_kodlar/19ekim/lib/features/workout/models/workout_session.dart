import 'package:flutter/foundation.dart';

/// Egzersiz yoğunluk seviyeleri.
// enum: önceden tanımlanmış sabit seçenekleri (düşük, orta, yüksek) güvenle kullanmayı sağlar
enum WorkoutIntensity { low, medium, high }

/// Egzersiz ve antrenman seansı veri modeli.
// @immutable: nesnenin verilerinin oluşturulduktan sonra değiştirilemeyeceğini belirtir
@immutable
// final class: bu model sınıfının miras alınmasını engeller
final class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    this.intensity = WorkoutIntensity.medium,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final WorkoutIntensity intensity;

  @override
  // iki seans nesnesinin tüm alanları aynı ise eşit sayılmasını sağlar
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          durationMinutes == other.durationMinutes &&
          caloriesBurned == other.caloriesBurned &&
          timestamp == other.timestamp &&
          intensity == other.intensity;

  @override
  // operator == ile uyumlu benzersiz karma kod üretir
  int get hashCode => Object.hash(
        id,
        title,
        durationMinutes,
        caloriesBurned,
        timestamp,
        intensity,
      );
}

