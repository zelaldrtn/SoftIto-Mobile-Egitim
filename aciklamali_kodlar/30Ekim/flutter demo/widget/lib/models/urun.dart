// ürünün kimlik, isim ve fiyat bilgilerini tutan veri modeli
class Urun{
    final int id;
    final String isim;
    final double fiyat;

    // kurucu metotta tüm parametrelerin verilmesini zorunlu kılıyoruz
    Urun({
        required this.id,
        required this.isim,
        required this.fiyat,
    });
}

