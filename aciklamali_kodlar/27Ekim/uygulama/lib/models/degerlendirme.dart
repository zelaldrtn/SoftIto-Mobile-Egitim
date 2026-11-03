// ürünün yıldız puanı ve yorum/oy sayısını tutan model sınıfı
class Degerlendirme{
    final double puan;
    final int oySayisi;

    // const kurucu nesnenin derleme anında sabit oluşturulabilmesini sağlar
    const Degerlendirme({
        required this.puan,
        required this.oySayisi,
    });

    // factory kurucusu gelen JSON haritasını ayrıştırıp Degerlendirme nesnesi üretir
    // dynamic değeri farklı tipler (int, double vb.) gelebileceği için kullanıyoruz
    factory Degerlendirme.fromJson(Map<String,dynamic> json) {
        return Degerlendirme(
            // num olarak alıp toDouble yapıyoruz, null ise 0.0 varsayıyoruz
            puan:(json['rate'] as num?)?.toDouble() ?? 0.0,
            oySayisi:(json['count'] as num?)?.toInt() ?? 0,
        );
    }

}

