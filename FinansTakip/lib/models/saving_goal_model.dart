import '../core/constants/app_constants.dart';

class SavingGoalModel {
  final String id;
  final String? userId;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final String currency;
  final DateTime? targetDate;
  final int priority; // 1: En yüksek, 2: Orta, 3: Düşük
  final String iconKey; // 'travel', 'car', 'house', 'laptop', 'wedding', 'emergency'
  final String? quote; // Motive edici söz/not
  final String? colorHex; // Özel renk vurgusu
  final String? imagePath; // Kullanıcının galeriden seçtiği fotoğraf yolu

  SavingGoalModel({
    required this.id,
    this.userId,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
    this.currency = AppConstants.currencyTRY,
    this.targetDate,
    this.priority = 1,
    this.iconKey = 'laptop',
    this.quote,
    this.colorHex,
    this.imagePath,
  });

  double get progressRatio {
    if (targetAmount <= 0) return 0.0;
    final ratio = savedAmount / targetAmount;
    return ratio.clamp(0.0, 1.0);
  }

  double get remainingAmount {
    final diff = targetAmount - savedAmount;
    return diff > 0 ? diff : 0.0;
  }

  bool get isCompleted => savedAmount >= targetAmount && targetAmount > 0;

  SavingGoalModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? targetAmount,
    double? savedAmount,
    String? currency,
    DateTime? targetDate,
    int? priority,
    String? iconKey,
    String? quote,
    String? colorHex,
    String? imagePath,
  }) {
    return SavingGoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      currency: currency ?? this.currency,
      targetDate: targetDate ?? this.targetDate,
      priority: priority ?? this.priority,
      iconKey: iconKey ?? this.iconKey,
      quote: quote ?? this.quote,
      colorHex: colorHex ?? this.colorHex,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'currency': currency,
      if (targetDate != null) 'target_date': targetDate!.toIso8601String(),
      'priority': priority,
      'iconKey': iconKey,
      'quote': quote,
      'colorHex': colorHex,
      'imagePath': imagePath,
    };
  }

  factory SavingGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingGoalModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      title: map['title']?.toString() ?? '',
      targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (map['savedAmount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency']?.toString() ?? AppConstants.currencyTRY,
      targetDate: map['target_date'] != null
          ? DateTime.tryParse(map['target_date'] as String)
          : null,
      priority: (map['priority'] as int?) ?? 1,
      iconKey: (map['iconKey'] as String?) ?? 'laptop',
      quote: map['quote'] as String?,
      colorHex: map['colorHex'] as String?,
      imagePath: map['imagePath'] as String?,
    );
  }
}
