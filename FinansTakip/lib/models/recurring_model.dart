import '../core/constants/app_constants.dart';

class RecurringPaymentModel {
  final String id;
  final String? userId;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final int dueDay; // Ayın günü (1-31)
  final DateTime? dueDate; // İsteğe bağlı tam tarih
  final String repeatType; // 'Aylık', 'Yıllık', 'Haftalık'
  final bool isPaid; // Bu ay ödendi mi?
  final bool reminderEnabled; // Hatırlatıcı açık mı?
  final String iconKey; // 'netflix', 'spotify', 'rent', 'wifi', 'gym', 'bill', 'other'

  RecurringPaymentModel({
    required this.id,
    this.userId,
    required this.title,
    required this.amount,
    this.currency = AppConstants.currencyTRY,
    required this.category,
    required this.dueDay,
    this.dueDate,
    this.repeatType = 'Aylık',
    this.isPaid = false,
    this.reminderEnabled = true,
    this.iconKey = 'bill',
  });

  /// Bir sonraki ödeme tarihini hesaplar
  DateTime getNextDueDate(DateTime referenceDate) {
    if (dueDate != null && dueDate!.isAfter(referenceDate)) {
      return dueDate!;
    }

    int year = referenceDate.year;
    int month = referenceDate.month;
    int day = dueDay;

    int maxDays = DateTime(year, month + 1, 0).day;
    int validDay = day > maxDays ? maxDays : day;

    DateTime candidate = DateTime(year, month, validDay);
    if (candidate.isBefore(
        DateTime(referenceDate.year, referenceDate.month, referenceDate.day))) {
      month += 1;
      if (month > 12) {
        month = 1;
        year += 1;
      }
      int nextMaxDays = DateTime(year, month + 1, 0).day;
      validDay = day > nextMaxDays ? nextMaxDays : day;
      candidate = DateTime(year, month, validDay);
    }
    return candidate;
  }

  /// Kalan gün sayısı
  int daysRemaining(DateTime referenceDate) {
    final nextDate = getNextDueDate(referenceDate);
    final today =
        DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    return nextDate.difference(today).inDays;
  }

  RecurringPaymentModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    String? currency,
    String? category,
    int? dueDay,
    DateTime? dueDate,
    String? repeatType,
    bool? isPaid,
    bool? reminderEnabled,
    String? iconKey,
  }) {
    return RecurringPaymentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      dueDay: dueDay ?? this.dueDay,
      dueDate: dueDate ?? this.dueDate,
      repeatType: repeatType ?? this.repeatType,
      isPaid: isPaid ?? this.isPaid,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      iconKey: iconKey ?? this.iconKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'amount': amount,
      'currency': currency,
      'category': category,
      'due_day': dueDay,
      if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
      'repeat_type': repeatType,
      'is_paid': isPaid,
      'reminder_enabled': reminderEnabled,
      'icon_key': iconKey,
    };
  }

  factory RecurringPaymentModel.fromMap(Map<String, dynamic> map) {
    return RecurringPaymentModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      title: map['title']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
      category: map['category']?.toString() ?? 'Faturalar',
      dueDay: (map['due_day'] as int?) ?? (map['dueDay'] as int?) ?? 1,
      dueDate: map['due_date'] != null
          ? DateTime.tryParse(map['due_date'] as String)
          : null,
      repeatType: map['repeat_type']?.toString() ??
          map['repeatType']?.toString() ??
          'Aylık',
      isPaid: (map['is_paid'] as bool?) ?? (map['isPaid'] as bool?) ?? false,
      reminderEnabled: (map['reminder_enabled'] as bool?) ?? true,
      iconKey: map['icon_key']?.toString() ??
          map['iconKey']?.toString() ??
          'bill',
    );
  }
}
