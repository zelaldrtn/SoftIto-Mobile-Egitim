import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

/// Su tüketim modülü için hafif, yerel durum yöneticisi.
class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({this.dailyTargetMl = 3000});

  int dailyTargetMl;
  final List<WaterLog> _logs = <WaterLog>[];

  List<WaterLog> get logs => List.unmodifiable(_logs);

  int get currentMl =>
      _logs.fold<int>(0, (sum, item) => sum + item.amountMl);

  double get progressRatio =>
      dailyTargetMl == 0 ? 0.0 : (currentMl / dailyTargetMl).clamp(0.0, 1.0);

  int get remainingMl =>
      (dailyTargetMl - currentMl).clamp(0, dailyTargetMl);

  int get percentage =>
      dailyTargetMl == 0 ? 0 : ((currentMl / dailyTargetMl) * 100).toInt();

  bool get isGoalReached => currentMl >= dailyTargetMl;

  void addWater(int amountMl, {String label = 'Su'}) {
    if (amountMl <= 0) return;
    final log = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );
    _logs.insert(0, log);
    notifyListeners();
  }

  void removeLog(String id) {
    _logs.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void resetDaily() {
    _logs.clear();
    notifyListeners();
  }

  void updateTarget(int newTarget) {
    if (newTarget > 0 && newTarget != dailyTargetMl) {
      dailyTargetMl = newTarget;
      notifyListeners();
    }
  }
}
