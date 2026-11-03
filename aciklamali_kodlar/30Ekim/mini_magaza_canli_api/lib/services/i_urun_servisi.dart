import '../models/urun.dart';

// ürün servisi için metot sözleşmesini tanımlayan soyut sınıf
abstract class IUrunServisi {
  // tüm ürünleri getirme kuralı
  Future<List<Urun>> urunleriGetir();

  // id ile tek bir ürün getirme kuralı
  Future<Urun?> urunGetirById(int id);
}

