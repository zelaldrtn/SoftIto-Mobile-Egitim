// hayal panosu ve birikim hedeflerini (tatil, araba, laptop vb.) tutan model
class SavingGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  // hedefin önem derecesi: 1 en yüksek, 2 orta, 3 düşük
  final int priority; // 1: En yüksek, 2: Orta, 3: Düşük
  final String iconKey; // 'travel', 'car', 'house', 'laptop', 'wedding', 'emergency'
  final String? quote; // Motive edici söz/not
  final String? colorHex; // Özel renk vurgusu

  // kurucu metod
  SavingGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
    this.priority = 1,
    this.iconKey = 'laptop',
    this.quote,
    this.colorHex,
  });

  // ilerleme yüzdesini 0.0 ile 1.0 arasında progress bar için oranlar
  double get progressRatio {
    if (targetAmount <= 0) return 0.0;
    final ratio = savedAmount / targetAmount;
    // clamp değeri belirtilen alt ve üst sınırlar arasında tutar, taşmayı engeller
    return ratio.clamp(0.0, 1.0);
  }

  // hedefe ulaşmak için kalan para miktarını verir
  double get remainingAmount {
    final diff = targetAmount - savedAmount;
    return diff > 0 ? diff : 0.0;
  }

  // hedeflenen tutara ulaşılıp ulaşılmadığını kontrol eden getter
  bool get isCompleted => savedAmount >= targetAmount && targetAmount > 0;

  // mevcut nesneyi koruyup sadece değişen alanları güncellemek için kopyalama fonksiyonu
  SavingGoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    int? priority,
    String? iconKey,
    String? quote,
    String? colorHex,
  }) {
    return SavingGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      priority: priority ?? this.priority,
      iconKey: iconKey ?? this.iconKey,
      quote: quote ?? this.quote,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  // modeli map yapısına çevirir
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'priority': priority,
      'iconKey': iconKey,
      'quote': quote,
      'colorHex': colorHex,
    };
  }

  // map verisini modele dönüştüren fabrika kurucu
  factory SavingGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingGoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      savedAmount: (map['savedAmount'] as num?)?.toDouble() ?? 0.0,
      priority: (map['priority'] as int?) ?? 1,
      iconKey: (map['iconKey'] as String?) ?? 'laptop',
      quote: map['quote'] as String?,
      colorHex: map['colorHex'] as String?,
    );
  }
}

