// ürünün puan ve değerlendirme sayısını tutan alt model
class Degerlendirme {
  final double puan;
  final int oySayisi;

  // const kurucu ile nesnenin hafızada sabit kalmasını sağlıyoruz
  const Degerlendirme({
    required this.puan,
    required this.oySayisi,
  });

  // REST API'den gelen iç içe JSON verisini ayrıştıran fabrika metodu
  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    return Degerlendirme(
      // puan tamsayı veya ondalıklı gelse de num üzerinden güvenle double'a çeviriyoruz
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  // nesneyi API'ye göndermek gerekirse tekrar Map/JSON formatına çevirir
  Map<String, dynamic> toJson() {
    return {
      'rate': puan,
      'count': oySayisi,
    };
  }
}

