import '../../../core/constants/app_constants.dart';

enum CardType {
  debit, // Banka / Maaş Kartı
  credit, // Kredi Kartı
}

class FinancialCard {
  final String id;
  final String? userId;
  final String cardName;
  final String bankName;
  final CardType cardType;
  final String currency;
  final double openingBalance;
  final double currentBalance;
  final double creditLimit;
  final double currentDebt;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FinancialCard({
    required this.id,
    this.userId,
    required this.cardName,
    required this.bankName,
    required this.cardType,
    this.currency = AppConstants.currencyTRY,
    this.openingBalance = 0.0,
    this.currentBalance = 0.0,
    this.creditLimit = 0.0,
    this.currentDebt = 0.0,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Kredi kartı için kullanılabilir limit
  double get availableLimit {
    if (cardType != CardType.credit) return 0.0;
    final diff = creditLimit - currentDebt;
    return diff > 0 ? diff : 0.0;
  }

  /// Kredi kartı kullanım oranı (0.0 - 1.0)
  double get debtUsageRatio {
    if (creditLimit <= 0) return 0.0;
    return (currentDebt / creditLimit).clamp(0.0, 1.0);
  }

  FinancialCard copyWith({
    String? id,
    String? userId,
    String? cardName,
    String? bankName,
    CardType? cardType,
    String? currency,
    double? openingBalance,
    double? currentBalance,
    double? creditLimit,
    double? currentDebt,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialCard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardName: cardName ?? this.cardName,
      bankName: bankName ?? this.bankName,
      cardType: cardType ?? this.cardType,
      currency: currency ?? this.currency,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      currentDebt: currentDebt ?? this.currentDebt,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'card_name': cardName,
      'bank_name': bankName,
      'card_type': cardType.name,
      'currency': currency,
      'opening_balance': openingBalance,
      'current_balance': currentBalance,
      'credit_limit': creditLimit,
      'current_debt': currentDebt,
      'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  factory FinancialCard.fromMap(Map<String, dynamic> map) {
    return FinancialCard(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      cardName: map['card_name']?.toString() ?? '',
      bankName: map['bank_name']?.toString() ?? '',
      cardType: (map['card_type'] == 'credit' || map['card_type'] == 'CardType.credit')
          ? CardType.credit
          : CardType.debit,
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
      openingBalance: (map['opening_balance'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (map['current_balance'] as num?)?.toDouble() ?? 0.0,
      creditLimit: (map['credit_limit'] as num?)?.toDouble() ?? 0.0,
      currentDebt: (map['current_debt'] as num?)?.toDouble() ?? 0.0,
      isDeleted: map['is_deleted'] as bool? ?? false,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at']) : null,
    );
  }
}

class CashAccount {
  final String id;
  final String? userId;
  final String accountName;
  final String currency;
  final double balance;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CashAccount({
    required this.id,
    this.userId,
    required this.accountName,
    this.currency = AppConstants.currencyTRY,
    this.balance = 0.0,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  CashAccount copyWith({
    String? id,
    String? userId,
    String? accountName,
    String? currency,
    double? balance,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CashAccount(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountName: accountName ?? this.accountName,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'account_name': accountName,
      'currency': currency,
      'balance': balance,
      'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  factory CashAccount.fromMap(Map<String, dynamic> map) {
    return CashAccount(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      accountName: map['account_name']?.toString() ?? '',
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      isDeleted: map['is_deleted'] as bool? ?? false,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at']) : null,
    );
  }
}

class CreditCardDebt {
  final String id;
  final String? userId;
  final String cardId;
  final String cardName;
  final double remainingDebt;
  final String currency;
  final bool isSettled;
  final DateTime? createdAt;

  CreditCardDebt({
    required this.id,
    this.userId,
    required this.cardId,
    required this.cardName,
    required this.remainingDebt,
    this.currency = AppConstants.currencyTRY,
    this.isSettled = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'card_id': cardId,
      'card_name': cardName,
      'remaining_debt': remainingDebt,
      'currency': currency,
      'is_settled': isSettled,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  factory CreditCardDebt.fromMap(Map<String, dynamic> map) {
    return CreditCardDebt(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      cardId: map['card_id']?.toString() ?? '',
      cardName: map['card_name']?.toString() ?? '',
      remainingDebt: (map['remaining_debt'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
      isSettled: map['is_settled'] as bool? ?? false,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
    );
  }
}

