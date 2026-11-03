import '../models/urun.dart';

// ürün servisi soyut arayüzü (interface)
abstract class IUrunServisi{
    // tüm ürünleri getirme zorunluluğu koyan metot imzası
    Future<List<UrunModel>> urunleriGetir();
}

