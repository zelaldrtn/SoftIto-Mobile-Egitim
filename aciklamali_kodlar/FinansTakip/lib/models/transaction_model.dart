// finansal hareket türünü belirten enum
enum TransactionType {
  income, // Gelir
  expense, // Gider
  saving, // Birikim
}

// her bir gelir, gider ve birikim kaydını tutan model sınıfı
class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  // harcamanın zorunlu ihtiyaç mı yoksa keyfi istek mi olduğunu belirtir
  final bool isNeed; // true: İhtiyaç, false: İstek
  final String? note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.isNeed = true,
    this.note,
  });

  // mevcut nesneyi kopyalayıp sadece değişen alanları güncellemek için copyWith kullanıyoruz
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    TransactionType? type,
    bool? isNeed,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      isNeed: isNeed ?? this.isNeed,
      note: note ?? this.note,
    );
  }

  // veritabanına veya SharedPreferences'a kaydetmek için harita (Map) formatına çevirir
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type.name,
      'isNeed': isNeed,
      'note': note,
    };
  }

  // harita (Map) verisinden TransactionModel nesnesi üreten yapıcı (factory constructor)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      isNeed: map['isNeed'] is bool ? map['isNeed'] as bool : true,
      note: map['note'] as String?,
    );
  }
}

