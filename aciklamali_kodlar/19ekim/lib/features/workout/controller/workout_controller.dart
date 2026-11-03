import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';

/// Egzersiz ve kalori takibi için yerel durum yöneticisi.
// ChangeNotifier: egzersiz eklendiğinde veya silindiğinde dinleyicileri tetikleyip arayüzü günceller
class WorkoutController extends ChangeNotifier {
  WorkoutController({
    this.dailyCalorieTarget = 600,
    this.dailyDurationTargetMinutes = 45,
  });

  int dailyCalorieTarget;
  int dailyDurationTargetMinutes;
  final List<WorkoutSession> _sessions = <WorkoutSession>[];

  // List.unmodifiable: listenin dışarıdan doğrudan müdahaleyle bozulmasını engelleyen salt okunur liste
  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

  // fold: listedeki tüm antrenmanların harcanan kalorilerini toplayarak günün toplamını verir
  int get totalCalories =>
      _sessions.fold<int>(0, (sum, item) => sum + item.caloriesBurned);

  // fold: listedeki tüm seansların sürelerini toplayarak toplam egzersiz dakikasını verir
  int get totalMinutes =>
      _sessions.fold<int>(0, (sum, item) => sum + item.durationMinutes);

  // clamp: kalori hedefine ulaşma oranını 0.0 ile 1.0 arasında tutar
  double get calorieProgress => dailyCalorieTarget == 0
      ? 0.0
      : (totalCalories / dailyCalorieTarget).clamp(0.0, 1.0);

  // egzersiz süresi hedefinin tamamlanma oranını hesaplar
  double get durationProgress => dailyDurationTargetMinutes == 0
      ? 0.0
      : (totalMinutes / dailyDurationTargetMinutes).clamp(0.0, 1.0);

  // hedefe ulaşmak için kalan kalori miktarını hesaplar
  int get remainingCalories =>
      (dailyCalorieTarget - totalCalories).clamp(0, dailyCalorieTarget);

  // günlük kalori hedefinin aşılıp aşılmadığını kontrol eder
  bool get isCalorieGoalReached => totalCalories >= dailyCalorieTarget;

  // yeni antrenman seansı ekleme metodu
  void addSession({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    WorkoutIntensity intensity = WorkoutIntensity.medium,
  }) {
    if (durationMinutes <= 0 || caloriesBurned <= 0) return;
    final session = WorkoutSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      intensity: intensity,
    );
    // insert: yeni seansı listenin en üstüne (0. sıraya) koyar
    _sessions.insert(0, session);
    // notifyListeners: bu controller'a bağlı widget'ların ekranını yeniler
    notifyListeners();
  }

  // seçilen antrenmanı listeden siler
  void removeSession(String id) {
    _sessions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // günün tüm antrenman kayıtlarını temizler
  void resetDaily() {
    _sessions.clear();
    notifyListeners();
  }
}

