import '../models/category.dart';
import '../models/product.dart';

abstract class IProductService{

    Future<List<Urun>> tumUrunleriGetir();

    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

    Future<List<Urun>> adaGoreAra(String aramaMetni);

    

}