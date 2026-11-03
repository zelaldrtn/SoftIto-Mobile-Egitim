import 'kategori.dart';
import 'degerlendirme.dart';

// mağazadaki ürünün tüm bilgilerini tutan ana model
class Urun {
  final int id;
  final String baslik;
  final double fiyat;
  final String aciklama;
  final Kategori kategori;
  final String resimUrl;
  final Degerlendirme degerlendirme;
  final bool stoktaVarMi;

  const Urun({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.aciklama,
    required this.kategori,
    required this.resimUrl,
    required this.degerlendirme,
    this.stoktaVarMi = true,
  });

  // API'den gelen dinamik Map verisini Urun modeline çeviren fabrika kurucu
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: (json['id'] as num).toInt(),
      // null kontrolü ile varsayılan değer atıyoruz
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      aciklama: json['description'] as String? ?? '',
      kategori: KategoriExtension.apiMetnindenUret(json['category'] as String? ?? ''),
      resimUrl: json['image'] as String? ?? '',
      // iç içe JSON nesnesini kendi fromJson fonksiyonuyla çözümlüyoruz
      degerlendirme: json['rating'] != null
          ? Degerlendirme.fromJson(json['rating'] as Map<String, dynamic>)
          : const Degerlendirme(puan: 0.0, oySayisi: 0),
      // API'de stok bilgisi olmadığı için oy sayısına göre temsili stok belirliyoruz
      stoktaVarMi: ((json['rating']?['count'] as num?)?.toInt() ?? 10) > 0,
    );
  }

  // nesnenin mevcut değerlerini koruyup sadece değişen alanları güncellemek için copyWith kullanıyoruz
  Urun copyWith({
    int? id,
    String? baslik,
    double? fiyat,
    String? aciklama,
    Kategori? kategori,
    String? resimUrl,
    Degerlendirme? degerlendirme,
    bool? stoktaVarMi,
  }) {
    return Urun(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      fiyat: fiyat ?? this.fiyat,
      aciklama: aciklama ?? this.aciklama,
      kategori: kategori ?? this.kategori,
      resimUrl: resimUrl ?? this.resimUrl,
      degerlendirme: degerlendirme ?? this.degerlendirme,
      stoktaVarMi: stoktaVarMi ?? this.stoktaVarMi,
    );
  }
}

