import 'package:flutter/material.dart';

class InAppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final List<InAppNotification> _notifications = [];
  List<InAppNotification> get notifications => List.unmodifiable(_notifications);

  final Set<String> _notifiedEventKeys = {};

  bool notifyBudgetEnabled = true;
  bool notifyRecurringEnabled = true;
  bool notifySavingsEnabled = true;

  Future<void> init() async {
    debugPrint('🔔 [NotificationService] Yerel bildirim servisi başlatıldı (Web uyumlu).');
  }

//bu fonksiyon ile bildirimleri ekliyoruz.
  void addNotification({
    required String title,
    required String message,
    IconData icon = Icons.notifications_active_outlined,
    Color color = const Color(0xFF1E5638),
  }) {
    final notif = InAppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      icon: icon,
      color: color,
    );
    _notifications.insert(0, notif);
  }

  /// Bütçe limit uyarıları (%80 ve %100)
  void checkBudgetLimit({
    required String category,
    required double spent,
    required double limit,
  }) {
    if (!notifyBudgetEnabled || limit <= 0) return;
    final ratio = spent / limit;
    final monthKey = '${DateTime.now().year}-${DateTime.now().month}';

    if (ratio >= 1.0) {
      final key = 'budget_100_${category}_$monthKey';
      if (!_notifiedEventKeys.contains(key)) {
        _notifiedEventKeys.add(key);
        addNotification(
          title: '🚨 Bütçe Aşıldı!',
          message: '$category bütçeniz %100 oranında aşıldı! Harcama kontrolü yapmanız önerilir.',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFE26D5C),
        );
      }
    } else if (ratio >= 0.8) {
      final key = 'budget_80_${category}_$monthKey';
      if (!_notifiedEventKeys.contains(key)) {
        _notifiedEventKeys.add(key);
        addNotification(
          title: '⚠️ Bütçe Uyarısı (%80)',
          message: '$category bütçenizin %80\'ine ulaştınız. Kalan bütçenize dikkat ediniz.',
          icon: Icons.info_outline_rounded,
          color: const Color(0xFFF7D965),
        );
      }
    }
  }

  /// Birikim hedefi tamamlandı uyarısı
  void notifyGoalCompleted(String goalTitle) {
    if (!notifySavingsEnabled) return;
    final key = 'goal_completed_${goalTitle}_${DateTime.now().year}';
    if (!_notifiedEventKeys.contains(key)) {
      _notifiedEventKeys.add(key);
      addNotification(
        title: '🎉 Tebrikler! Hedef Tamamlandı',
        message: '"$goalTitle" hedefinizi başarıyla tamamladınız!',
        icon: Icons.military_tech_rounded,
        color: const Color(0xFF1E5638),
      );
    }
  }

  /// Düzenli ödeme hatırlatıcısı (1 gün önce)
  void checkRecurringReminder({
    required String title,
    required int daysRemaining,
  }) {
    if (!notifyRecurringEnabled) return;
    if (daysRemaining == 1) {
      final key = 'rec_1day_${title}_${DateTime.now().year}_${DateTime.now().month}';
      if (!_notifiedEventKeys.contains(key)) {
        _notifiedEventKeys.add(key);
        addNotification(
          title: '⏰ Ödeme Hatırlatması',
          message: '$title ödemenizin son gününe 1 gün kaldı.',
          icon: Icons.alarm,
          color: const Color(0xFF9D84B7),
        );
      }
    }
  }
}
