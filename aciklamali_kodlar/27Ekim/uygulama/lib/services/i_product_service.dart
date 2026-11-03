import '../models/category.dart';
import '../models/product.dart';

// ürün verisi sağlayan servisler için ortak kuralları belirleyen soyut sınıf (arayüz / interface)
abstract class IProductService{

    // tüm ürünleri liste olarak getirmeyi taahhüt eden metot
    Future<List<Urun>> tumUrunleriGetir();

    // belirli bir kategoriye ait ürünleri getiren metot
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

    // ürün başlığı veya açıklamasında arama yapan metot
    Future<List<Urun>> adaGoreAra(String aramaMetni);

}

