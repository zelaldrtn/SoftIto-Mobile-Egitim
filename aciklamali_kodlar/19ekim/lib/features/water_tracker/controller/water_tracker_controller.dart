import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

/// Su tüketim modülü için hafif, yerel durum yöneticisi.
// ChangeNotifier: içindeki veriler değiştiğinde dinleyen widget'lara haber verip arayüzü güncelleyen temel sınıf
class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({this.dailyTargetMl = 3000});

  int dailyTargetMl;
  final List<WaterLog> _logs = <WaterLog>[];

  // List.unmodifiable: listenin dışarıdan doğrudan değiştirilmesini engelleyip salt okunur erişim sunar
  List<WaterLog> get logs => List.unmodifiable(_logs);

  // fold: listedeki tüm kayıtların mililitre değerlerini 0'dan başlayarak toplar
  int get currentMl =>
      _logs.fold<int>(0, (sum, item) => sum + item.amountMl);

  // clamp: ilerleme oranının 0.0 ile 1.0 aralığı dışına taşmasını engeller
  double get progressRatio =>
      dailyTargetMl == 0 ? 0.0 : (currentMl / dailyTargetMl).clamp(0.0, 1.0);

  // hedefe ulaşmak için kalan su miktarını hesaplar
  int get remainingMl =>
      (dailyTargetMl - currentMl).clamp(0, dailyTargetMl);

  // hedefin yüzde kaçının tamamlandığını hesaplar
  int get percentage =>
      dailyTargetMl == 0 ? 0 : ((currentMl / dailyTargetMl) * 100).toInt();

  // günlük hedefin yakalanıp yakalanmadığını kontrol eder
  bool get isGoalReached => currentMl >= dailyTargetMl;

  // yeni su tüketim kaydı ekler
  void addWater(int amountMl, {String label = 'Su'}) {
    if (amountMl <= 0) return;
    final log = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );
    // insert: yeni kaydı listenin en başına (0. indexe) ekler
    _logs.insert(0, log);
    // notifyListeners: bu controller'ı dinleyen widget'ları tetikleyip arayüzün yenilenmesini sağlar
    notifyListeners();
  }

  // seçilen kaydı listeden siler
  void removeLog(String id) {
    _logs.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // günün tüm su kayıtlarını temizler
  void resetDaily() {
    _logs.clear();
    notifyListeners();
  }

  // günlük su hedefini günceller
  void updateTarget(int newTarget) {
    if (newTarget > 0 && newTarget != dailyTargetMl) {
      dailyTargetMl = newTarget;
      notifyListeners();
    }
  }
}

