import '../core/constants/app_constants.dart';

enum TransactionType {
  income, // Gelir
  expense, // Gider
  saving, // Birikim
  debtPayment, // Kredi Kartı Borç Ödemesi (Raporlarda çift gider sayılmaz)
}

class TransactionModel {
  final String id;
  final String? userId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final bool isNeed; // true: İhtiyaç, false: İstek
  final String? note;

  // Hesap ve Kart Entegrasyonu
  final String? cardId;
  final String? cashAccountId;
  final String? accountName;

  // Çoklu Para Birimi Entegrasyonu
  final String currency;
  final double exchangeRate;
  final double amountInPrimary;
  final String primaryCurrency;

  TransactionModel({
    required this.id,
    this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.isNeed = true,
    this.note,
    this.cardId,
    this.cashAccountId,
    this.accountName,
    this.currency = AppConstants.currencyTRY,
    this.exchangeRate = 1.0,
    double? amountInPrimary,
    this.primaryCurrency = AppConstants.currencyTRY,
  }) : amountInPrimary = amountInPrimary ?? (amount * exchangeRate);

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    TransactionType? type,
    bool? isNeed,
    String? note,
    String? cardId,
    String? cashAccountId,
    String? accountName,
    String? currency,
    double? exchangeRate,
    double? amountInPrimary,
    String? primaryCurrency,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      isNeed: isNeed ?? this.isNeed,
      note: note ?? this.note,
      cardId: cardId ?? this.cardId,
      cashAccountId: cashAccountId ?? this.cashAccountId,
      accountName: accountName ?? this.accountName,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      amountInPrimary: amountInPrimary ?? this.amountInPrimary,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type.name,
      'isNeed': isNeed,
      'note': note,
      'card_id': cardId,
      'cash_account_id': cashAccountId,
      'account_name': accountName,
      'currency': currency,
      'exchange_rate': exchangeRate,
      'amount_in_primary': amountInPrimary,
      'primary_currency': primaryCurrency,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      title: map['title']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category']?.toString() ?? 'Diğer',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      isNeed: map['isNeed'] is bool ? map['isNeed'] as bool : true,
      note: map['note'] as String?,
      cardId: map['card_id'] as String?,
      cashAccountId: map['cash_account_id'] as String?,
      accountName: map['account_name'] as String?,
      currency: map['currency'] as String? ?? AppConstants.currencyTRY,
      exchangeRate: (map['exchange_rate'] as num?)?.toDouble() ?? 1.0,
      amountInPrimary: (map['amount_in_primary'] as num?)?.toDouble() ??
          ((map['amount'] as num?)?.toDouble() ?? 0.0),
      primaryCurrency:
          map['primary_currency'] as String? ?? AppConstants.currencyTRY,
    );
  }
}
