class RecurringPaymentModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final int dueDay; // Ayın günü (1-31)
  final String repeatType; // 'Aylık', 'Yıllık', 'Haftalık'
  final bool isPaid; // Bu ay ödendi mi?
  final String iconKey; // 'netflix', 'spotify', 'rent', 'wifi', 'gym', 'bill', 'other'

  RecurringPaymentModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.dueDay,
    this.repeatType = 'Aylık',
    this.isPaid = false,
    this.iconKey = 'bill',
  });

  /// Bir sonraki ödeme tarihini hesaplar
  DateTime getNextDueDate(DateTime referenceDate) {
    int year = referenceDate.year;
    int month = referenceDate.month;
    int day = dueDay;

    // Ayın kaç çektiğini kontrol et
    int maxDays = DateTime(year, month + 1, 0).day;
    int validDay = day > maxDays ? maxDays : day;

    DateTime candidate = DateTime(year, month, validDay);
    if (candidate.isBefore(DateTime(referenceDate.year, referenceDate.month, referenceDate.day))) {
      // Bir sonraki aya geç
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
    final today = DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    return nextDate.difference(today).inDays;
  }

  RecurringPaymentModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    int? dueDay,
    String? repeatType,
    bool? isPaid,
    String? iconKey,
  }) {
    return RecurringPaymentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      dueDay: dueDay ?? this.dueDay,
      repeatType: repeatType ?? this.repeatType,
      isPaid: isPaid ?? this.isPaid,
      iconKey: iconKey ?? this.iconKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'dueDay': dueDay,
      'repeatType': repeatType,
      'isPaid': isPaid,
      'iconKey': iconKey,
    };
  }

  factory RecurringPaymentModel.fromMap(Map<String, dynamic> map) {
    return RecurringPaymentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      dueDay: (map['dueDay'] as int?) ?? 1,
      repeatType: (map['repeatType'] as String?) ?? 'Aylık',
      isPaid: (map['isPaid'] as bool?) ?? false,
      iconKey: (map['iconKey'] as String?) ?? 'bill',
    );
  }
}
