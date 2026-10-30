class Urun{
    final int id;
    final String isim;
    final double fiyat;

    Urun({
        required this.id,
        required this.isim,
        required this.fiyat,
    });
}

//Bu urun sınıfı, veri yapısını oluşturur.
//Urun, ID, isim ve fiyat bilgilerini tutar.
//Constructor, bu değerlerin dışarıdan alınmasını zorunlu kılar. 