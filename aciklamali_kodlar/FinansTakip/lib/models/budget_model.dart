// aylık kategori bütçe limitlerini saklayan model sınıfı
class BudgetLimitModel {
  final String id;
  // ilgili yıl ve ay bilgisi (örn: '2026-10')
  final String month; // '2026-10' gibi
  final String category; // 'Genel Bütçe', 'Market', 'Yemek', 'Ulaşım' vs.
  final double limitAmount;

  BudgetLimitModel({
    required this.id,
    required this.month,
    required this.category,
    required this.limitAmount,
  });

  // mevcut bütçe limitini kopyalayıp güncelleyen copyWith metodu
  BudgetLimitModel copyWith({
    String? id,
    String? month,
    String? category,
    double? limitAmount,
  }) {
    return BudgetLimitModel(
      id: id ?? this.id,
      month: month ?? this.month,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'category': category,
      'limitAmount': limitAmount,
    };
  }

  // harita (Map) verisinden nesne üreten factory constructor
  factory BudgetLimitModel.fromMap(Map<String, dynamic> map) {
    return BudgetLimitModel(
      id: map['id'] as String,
      month: map['month'] as String,
      category: map['category'] as String,
      limitAmount: (map['limitAmount'] as num).toDouble(),
    );
  }
}

