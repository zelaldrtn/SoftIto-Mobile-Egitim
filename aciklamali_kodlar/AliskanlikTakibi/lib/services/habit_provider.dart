import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/room_item.dart';
import '../models/badge_item.dart';
import '../models/user_profile.dart';
import 'storage_service.dart';

// tüm alışkanlıkları, zincirleri (streak), oda eşyalarını ve puanları yöneten ana Provider sınıfı
class HabitProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<Habit> _habits = [];
  List<HabitLog> _logs = [];
  List<RoomItem> _roomItems = [];
  List<BadgeItem> _badges = [];
  UserProfile _profile = const UserProfile();
  int _pointsBalance = 0;
  bool _isLoading = true;

  HabitProvider(this._storageService) {
    _loadAll();
  }

  bool get isLoading => _isLoading;
  // dışarıdan listelerin doğrudan değiştirilmesini engellemek için unmodifiable kullanıyoruz
  List<Habit> get habits => List.unmodifiable(_habits);
  List<HabitLog> get logs => List.unmodifiable(_logs);
  List<RoomItem> get roomItems => List.unmodifiable(_roomItems);
  List<BadgeItem> get badges => List.unmodifiable(_badges);
  UserProfile get profile => _profile;
  int get pointsBalance => _pointsBalance;

  // profil ayarına göre ThemeMode döndüren getter
  ThemeMode get themeMode {
    switch (_profile.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // tüm verileri depolamadan yükler ve arayüzü günceller
  void _loadAll() {
    _habits = _storageService.loadHabits();
    _logs = _storageService.loadLogs();
    _roomItems = _storageService.loadRoomItems();
    _badges = _storageService.loadBadges();
    _profile = _storageService.loadProfile();
    _pointsBalance = _storageService.loadPoints();
    _isLoading = false;
    _checkBadges();
    notifyListeners();
  }

  // yeni alışkanlık ekler
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _storageService.saveHabits(_habits);
    _checkBadges();
    notifyListeners();
  }

  // mevcut alışkanlığı günceller
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _storageService.saveHabits(_habits);
      notifyListeners();
    }
  }

  // alışkanlığı duraklatır veya tekrar aktif eder
  Future<void> togglePauseHabit(String habitId) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final current = _habits[index];
      _habits[index] = current.copyWith(isPaused: !current.isPaused);
      await _storageService.saveHabits(_habits);
      notifyListeners();
    }
  }

  // alışkanlığı siler (geçmiş istatistiklerin bozulmaması için eski loglar korunur)
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await _storageService.saveHabits(_habits);
    notifyListeners();
  }

  // belirli bir tarihte alışkanlık tamamlanmış mı kontrol eder
  bool isHabitCompletedOnDate(String habitId, DateTime date) {
    final dateKey = HabitLog.formatDate(date);
    return _logs.any((log) => log.habitId == habitId && log.date == dateKey);
  }

  // tamamlama durumunu tersine çevirir (tamamlandıysa puan ekler, geri alınırsa puanı düşer)
  Future<bool> toggleCompletion(String habitId, DateTime date) async {
    final dateKey = HabitLog.formatDate(date);
    final existingIndex = _logs.indexWhere(
      (log) => log.habitId == habitId && log.date == dateKey,
    );

    if (existingIndex == -1) {
      final habit = _habits.firstWhere(
        (h) => h.id == habitId,
        orElse: () => Habit(
          id: '',
          name: '',
          goal: '',
          category: HabitCategory.diger,
          iconCodePoint: 0,
          frequencyType: HabitFrequencyType.everyDay,
          difficulty: HabitDifficulty.easy,
        ),
      );
      if (habit.id.isEmpty) return false;

      final earned = habit.points;
      final newLog = HabitLog(
        id: '${habitId}_${dateKey}_${DateTime.now().millisecondsSinceEpoch}',
        habitId: habitId,
        date: dateKey,
        pointsEarned: earned,
      );

      _logs.add(newLog);
      _pointsBalance += earned;

      await _storageService.saveLogs(_logs);
      await _storageService.savePoints(_pointsBalance);
      _checkBadges();
      notifyListeners();
      return true;
    } else {
      final logToRemove = _logs[existingIndex];
      _pointsBalance = (_pointsBalance - logToRemove.pointsEarned).clamp(0, 9999999);
      _logs.removeAt(existingIndex);

      await _storageService.saveLogs(_logs);
      await _storageService.savePoints(_pointsBalance);
      notifyListeners();
      return false;
    }
  }

  // bugün kazanılan toplam puanı hesaplar
  int getTodayEarnedPoints() {
    final todayKey = HabitLog.formatDate(DateTime.now());
    return _logs
        .where((log) => log.date == todayKey)
        .fold<int>(0, (sum, item) => sum + item.pointsEarned);
  }

  // belirli bir gün için planlanmış alışkanlıkları döndürür
  List<Habit> getScheduledHabitsForDate(DateTime date) {
    return _habits.where((h) => h.isScheduledForDate(date)).toList();
  }

  // o günkü tamamlama ilerleme oranını (0.0 ile 1.0 arası) hesaplar
  double getProgressForDate(DateTime date) {
    final scheduled = getScheduledHabitsForDate(date);
    if (scheduled.isEmpty) return 0.0;
    int completedCount = 0;
    for (final habit in scheduled) {
      if (isHabitCompletedOnDate(habit.id, date)) {
        completedCount++;
      }
    }
    return completedCount / scheduled.length;
  }

  // bir alışkanlığın kesintisiz zincir (streak) gün sayısını hesaplar
  int calculateHabitStreak(Habit habit) {
    final today = DateTime.now();
    int streak = 0;
    DateTime checkDate = today;

    final isCompletedToday = isHabitCompletedOnDate(habit.id, today);

    if (habit.isScheduledForDate(today)) {
      if (isCompletedToday) {
        streak = 1;
        checkDate = today.subtract(const Duration(days: 1));
      } else {
        checkDate = today.subtract(const Duration(days: 1));
      }
    } else {
      checkDate = today.subtract(const Duration(days: 1));
    }

    // geçmişe doğru geriye doğru tarama yapıyoruz
    for (int i = 0; i < 365; i++) {
      final habitCreatedDay = DateTime(
        habit.createdAt.year,
        habit.createdAt.month,
        habit.createdAt.day,
      );
      if (checkDate.isBefore(habitCreatedDay)) {
        break;
      }

      if (habit.isScheduledForDate(checkDate)) {
        if (isHabitCompletedOnDate(habit.id, checkDate)) {
          streak++;
        } else {
          break; // planlı günde yapılmadıysa zincir bozulur
        }
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  // o anki en yüksek aktif zinciri döndürür
  int get currentGlobalStreak {
    if (_habits.isEmpty) return 0;
    int maxStreak = 0;
    for (final habit in _habits.where((h) => !h.isPaused)) {
      final s = calculateHabitStreak(habit);
      if (s > maxStreak) {
        maxStreak = s;
      }
    }
    return maxStreak;
  }

  // geçmiş tüm kayıtlardaki en uzun ardışık aktivite rekorunu hesaplar
  int get longestHistoricalStreak {
    if (_logs.isEmpty) return 0;
    final uniqueDates = _logs.map((l) => l.date).toSet().toList()..sort();
    if (uniqueDates.isEmpty) return 0;

    int longest = 1;
    int current = 1;
    for (int i = 1; i < uniqueDates.length; i++) {
      final prev = DateTime.tryParse(uniqueDates[i - 1]);
      final curr = DateTime.tryParse(uniqueDates[i]);
      if (prev != null && curr != null) {
        final diff = curr.difference(prev).inDays;
        if (diff == 1) {
          current++;
          if (current > longest) longest = current;
        } else if (diff > 1) {
          current = 1;
        }
      }
    }
    final bestHabit = currentGlobalStreak;
    return longest > bestHabit ? longest : bestHabit;
  }

  // mobilya yuvasının 3D sahnedeki varsayılan koordinatlarını verir
  static ({double x, double z, double rot}) getDefaultSlotCoordinates(RoomSlotType slot) {
    switch (slot) {
      case RoomSlotType.desk:
        return (x: -1.6, z: 1.8, rot: 0.0);
      case RoomSlotType.chair:
        return (x: -1.6, z: 0.6, rot: 0.0);
      case RoomSlotType.sofa:
        return (x: 1.6, z: -1.2, rot: -45.0);
      case RoomSlotType.bed:
        return (x: 1.8, z: 1.6, rot: 0.0);
      case RoomSlotType.wardrobe:
        return (x: 2.4, z: -0.4, rot: -90.0);
      case RoomSlotType.bookshelf:
        return (x: -2.8, z: -1.2, rot: 90.0);
      case RoomSlotType.rug:
        return (x: 0.0, z: -0.4, rot: 0.0);
      case RoomSlotType.plant:
        return (x: 2.4, z: 2.4, rot: 0.0);
      case RoomSlotType.lamp:
        return (x: -2.6, z: 2.4, rot: 0.0);
      case RoomSlotType.wallArt:
        return (x: -3.8, z: 0.0, rot: 90.0);
      case RoomSlotType.trophy:
        return (x: 0.8, z: 2.6, rot: 0.0);
    }
  }

  // mağazadan eşya satın alma işlemi
  bool buyRoomItem(String itemId) {
    final index = _roomItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return false;

    final item = _roomItems[index];

    if (item.isOwned) return false;

    // zincir şartı kontrolü
    if (item.streakRequirement > 0) {
      if (currentGlobalStreak < item.streakRequirement) {
        return false;
      }
    }

    // bakiye kontrolü
    if (_pointsBalance < item.price) {
      return false;
    }

    _pointsBalance -= item.price;

    double targetX = item.positionX;
    double targetZ = item.positionZ;
    double targetRot = item.rotationY;

    // aynı yuvadaki eski eşyayı odadan kaldırıyoruz
    for (int i = 0; i < _roomItems.length; i++) {
      if (i != index && _roomItems[i].slotType == item.slotType && _roomItems[i].isPlaced) {
        targetX = _roomItems[i].positionX;
        targetZ = _roomItems[i].positionZ;
        targetRot = _roomItems[i].rotationY;
        _roomItems[i] = _roomItems[i].copyWith(isPlaced: false);
      }
    }

    if (targetX == 0.0 && targetZ == 0.0) {
      final defCoord = getDefaultSlotCoordinates(item.slotType);
      targetX = defCoord.x;
      targetZ = defCoord.z;
      targetRot = defCoord.rot;
    }

    _roomItems[index] = item.copyWith(
      isOwned: true,
      isPlaced: true,
      positionX: targetX,
      positionZ: targetZ,
      rotationY: targetRot,
    );

    _storageService.savePoints(_pointsBalance);
    _storageService.saveRoomItems(_roomItems);
    _checkBadges();
    notifyListeners();
    return true;
  }

  // eşyanın odadaki yerleşim durumunu açıp kapatır
  void toggleItemPlacement(String itemId) {
    final index = _roomItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final item = _roomItems[index];
    if (!item.isOwned) return;

    final willPlace = !item.isPlaced;
    double targetX = item.positionX;
    double targetZ = item.positionZ;
    double targetRot = item.rotationY;

    if (willPlace) {
      for (int i = 0; i < _roomItems.length; i++) {
        if (_roomItems[i].slotType == item.slotType && _roomItems[i].isPlaced) {
          if (targetX == 0.0 && targetZ == 0.0) {
            targetX = _roomItems[i].positionX;
            targetZ = _roomItems[i].positionZ;
            targetRot = _roomItems[i].rotationY;
          }
          _roomItems[i] = _roomItems[i].copyWith(isPlaced: false);
        }
      }

      if (targetX == 0.0 && targetZ == 0.0) {
        final defCoord = getDefaultSlotCoordinates(item.slotType);
        targetX = defCoord.x;
        targetZ = defCoord.z;
        targetRot = defCoord.rot;
      }
    }

    _roomItems[index] = item.copyWith(
      isPlaced: willPlace,
      positionX: targetX,
      positionZ: targetZ,
      rotationY: targetRot,
    );
    _storageService.saveRoomItems(_roomItems);
    notifyListeners();
  }

  // test veya ödül amaçlı puan ekler
  void addPoints(int amount) {
    _pointsBalance += amount;
    _storageService.savePoints(_pointsBalance);
    notifyListeners();
  }

  // eşyanın odadaki konumunu günceller
  void updateRoomItemPosition(String itemId, double x, double z, {double? rotationY}) {
    final index = _roomItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final clampedX = x.clamp(-3.2, 3.2);
    final clampedZ = z.clamp(-3.2, 3.2);

    _roomItems[index] = _roomItems[index].copyWith(
      positionX: clampedX,
      positionZ: clampedZ,
      rotationY: rotationY ?? _roomItems[index].rotationY,
    );
    _storageService.saveRoomItems(_roomItems);
    notifyListeners();
  }

  // eşyayı 90 derece döndürür
  void rotateRoomItem(String itemId) {
    final index = _roomItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final currentRot = _roomItems[index].rotationY;
    final nextRot = (currentRot + 90.0) % 360.0;

    _roomItems[index] = _roomItems[index].copyWith(rotationY: nextRot);
    _storageService.saveRoomItems(_roomItems);
    notifyListeners();
  }

  // eşyayı belirli koordinatlarla odaya koyar veya kaldırır
  void setItemPlacement(String itemId, bool isPlaced, {double? x, double? z}) {
    final index = _roomItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final item = _roomItems[index];
    if (!item.isOwned) return;

    double posX = x ?? item.positionX;
    double posZ = z ?? item.positionZ;
    double posRot = item.rotationY;

    if (isPlaced) {
      for (int i = 0; i < _roomItems.length; i++) {
        if (i != index && _roomItems[i].slotType == item.slotType && _roomItems[i].isPlaced) {
          if (posX == 0.0 && posZ == 0.0) {
            posX = _roomItems[i].positionX;
            posZ = _roomItems[i].positionZ;
            posRot = _roomItems[i].rotationY;
          }
          _roomItems[i] = _roomItems[i].copyWith(isPlaced: false);
        }
      }

      if (posX == 0.0 && posZ == 0.0) {
        final defCoord = getDefaultSlotCoordinates(item.slotType);
        posX = defCoord.x;
        posZ = defCoord.z;
        posRot = defCoord.rot;
      }
    }

    _roomItems[index] = item.copyWith(
      isPlaced: isPlaced,
      positionX: posX,
      positionZ: posZ,
      rotationY: posRot,
    );
    _storageService.saveRoomItems(_roomItems);
    notifyListeners();
  }

  // tema modunu günceller
  Future<void> setThemeMode(dynamic mode) async {
    final String modeStr = mode is ThemeMode
        ? (mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system')
        : mode.toString();
    _profile = _profile.copyWith(themeMode: modeStr);
    await _storageService.saveProfile(_profile);
    notifyListeners();
  }

  // rozet kilit şartlarını kontrol edip hak edilenleri açar
  void _checkBadges() {
    bool hasUpdates = false;
    final totalCompletions = _logs.length;
    final streak = currentGlobalStreak;
    final ownedRoomCount = _roomItems.where((i) => i.isOwned).length;

    for (int i = 0; i < _badges.length; i++) {
      final b = _badges[i];
      if (b.isUnlocked) continue;

      bool shouldUnlock = false;

      if (b.id == 'badge_first_habit' && _habits.isNotEmpty) {
        shouldUnlock = true;
      } else if (b.requiredTotalCompletions > 0 && totalCompletions >= b.requiredTotalCompletions) {
        shouldUnlock = true;
      } else if (b.requiredStreak > 0 && streak >= b.requiredStreak) {
        shouldUnlock = true;
      } else if (b.requiredPoints > 0 && _pointsBalance >= b.requiredPoints) {
        shouldUnlock = true;
      } else if (b.requiredRoomItems > 0 && ownedRoomCount >= b.requiredRoomItems) {
        shouldUnlock = true;
      }

      if (shouldUnlock) {
        _badges[i] = b.copyWith(isUnlocked: true, unlockedAt: DateTime.now());
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      _storageService.saveBadges(_badges);
    }
  }

  // profili günceller
  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    await _storageService.saveProfile(_profile);
    notifyListeners();
  }

  // en istikrarlı (en çok tamamlanan) alışkanlığı bulur
  Habit? getMostConsistentHabit() {
    if (_habits.isEmpty || _logs.isEmpty) return null;
    final Map<String, int> counts = {};
    for (final log in _logs) {
      counts[log.habitId] = (counts[log.habitId] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;

    String? topHabitId;
    int maxCount = -1;
    counts.forEach((id, count) {
      if (count > maxCount) {
        maxCount = count;
        topHabitId = id;
      }
    });

    if (topHabitId == null) return null;
    try {
      return _habits.firstWhere((h) => h.id == topHabitId);
    } catch (_) {
      return null;
    }
  }

  // son 7 günün tamamlama istatistiklerini hesaplar
  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> dailyStats = [];
    int totalScheduled = 0;
    int totalDone = 0;

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayKey = HabitLog.formatDate(day);
      final scheduled = getScheduledHabitsForDate(day);
      final done = scheduled.where((h) => isHabitCompletedOnDate(h.id, day)).length;

      totalScheduled += scheduled.length;
      totalDone += done;

      dailyStats.add({
        'date': day,
        'dateKey': dayKey,
        'scheduled': scheduled.length,
        'done': done,
        'rate': scheduled.isEmpty ? 0.0 : done / scheduled.length,
      });
    }

    return {
      'daily': dailyStats,
      'overallRate': totalScheduled == 0 ? 0.0 : totalDone / totalScheduled,
      'totalDone': totalDone,
    };
  }

  // aylık özet (Wrapped) verilerini hesaplar
  Map<String, dynamic> getWrappedData({int? year, int? month}) {
    final targetDate = DateTime(year ?? DateTime.now().year, month ?? DateTime.now().month);
    final targetMonthStr = targetDate.month.toString().padLeft(2, '0');
    final targetYearStr = targetDate.year.toString();

    final monthLogs = _logs.where((l) {
      return l.date.startsWith('$targetYearStr-$targetMonthStr');
    }).toList();

    final activeDays = monthLogs.map((l) => l.date).toSet().length;
    final earnedPoints = monthLogs.fold<int>(0, (sum, l) => sum + l.pointsEarned);

    final Map<String, int> monthHabitCounts = {};
    for (final l in monthLogs) {
      monthHabitCounts[l.habitId] = (monthHabitCounts[l.habitId] ?? 0) + 1;
    }

    String? topHabitName;
    int topHabitCount = 0;
    monthHabitCounts.forEach((id, count) {
      if (count > topHabitCount) {
        topHabitCount = count;
        try {
          topHabitName = _habits.firstWhere((h) => h.id == id).name;
        } catch (_) {}
      }
    });

    final newHabitsCreatedThisMonth = _habits.where((h) {
      return h.createdAt.year == targetDate.year && h.createdAt.month == targetDate.month;
    }).length;

    return {
      'monthName': _getMonthName(targetDate.month),
      'year': targetDate.year,
      'totalLogs': monthLogs.length,
      'activeDays': activeDays,
      'earnedPoints': earnedPoints,
      'topHabitName': topHabitName,
      'topHabitCount': topHabitCount,
      'newHabitsCount': newHabitsCreatedThisMonth,
      'hasData': monthLogs.isNotEmpty,
    };
  }

  static String _getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}

