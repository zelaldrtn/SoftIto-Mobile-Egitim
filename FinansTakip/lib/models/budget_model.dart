import '../core/constants/app_constants.dart';

class BudgetLimitModel {
  final String id;
  final String? userId;
  final String month; // '2026-10' veya '2026-11' gibi
  final String category; // 'Genel Bütçe', 'Market', 'Yemek', 'Ulaşım' vs.
  final double limitAmount;
  final String currency;

  BudgetLimitModel({
    required this.id,
    this.userId,
    required this.month,
    required this.category,
    required this.limitAmount,
    this.currency = AppConstants.currencyTRY,
  });

  BudgetLimitModel copyWith({
    String? id,
    String? userId,
    String? month,
    String? category,
    double? limitAmount,
    String? currency,
  }) {
    return BudgetLimitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'month': month,
      'category': category,
      'limit_amount': limitAmount,
      'currency': currency,
    };
  }

  factory BudgetLimitModel.fromMap(Map<String, dynamic> map) {
    return BudgetLimitModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      month: map['month']?.toString() ?? '',
      category: map['category']?.toString() ?? 'Genel Bütçe',
      limitAmount: (map['limit_amount'] as num?)?.toDouble() ??
          (map['limitAmount'] as num?)?.toDouble() ??
          0.0,
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
    );
  }
}
