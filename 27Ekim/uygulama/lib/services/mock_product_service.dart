import '../models/category.dart';  //ordaki sözleşmeyi (interface) buraya çektik.
import '../models/product.dart';
import 'i_product_service.dart';

class MockProductService implements IProductService {
    
    final List<Urun> _urunDeposu=const[
        Urun(
            id:1,
            baslik:"Mackbook M5 Pro Laptop",
            aciklama:"Apple'ın en güçlü işlemcisine sahip yeni nesil Mackbook Pro",
            fiyat:179999.99,
            resimUrl: "https://picsum.photos/seed/macbook/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:5,
        ),
        Urun(
            id:2,
            baslik:"Apple Iphone 18 Pro Max",
            aciklama:"Apple'ın en güçlü işlemcisine sahip yeni nesil Iphone 18 Pro Max",
            fiyat:149999.99,
            resimUrl: "https://picsum.photos/seed/iphone/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:14,
        ),
        Urun(
            id:3,
            baslik:"Samsung S24 Ultra",
            aciklama:"Samsung'un en güçlü işlemcisine sahip yeni nesil Samsung S24 Ultra",
            fiyat:179999.99,
            resimUrl: "https://picsum.photos/seed/samsung/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:5,
        ),
        Urun(
            id:4,
            baslik:"Xiaomi 15 Ultra",
            aciklama:"Xiaomi'nin en güçlü işlemcisine sahip yeni nesil Xiaomi 15 Ultra",
            fiyat:149999.99,
            resimUrl: "https://picsum.photos/seed/xiaomi/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:14,
        ),
        Urun(
            id:5,
            baslik:"Dell XPS 15 2025",
            aciklama:"Dell'in en güçlü işlemcisine sahip yeni nesil Dell XPS 15 2025",
            fiyat:179999.99,
            resimUrl: "https://picsum.photos/seed/dell/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:5,
        ),
        Urun(
            id:6,
            baslik:"HP Spectre x360 2025",
            aciklama:"HP'nin en güçlü işlemcisine sahip yeni nesil HP Spectre x360 2025",
            fiyat:149999.99,
            resimUrl: "https://picsum.photos/seed/laptop/400/400",
            kategori: Kategori.elektronik,
            stokAdedi:14,
        ),
        Urun(
            id:7,
            baslik:"Kadın Kolye",
            aciklama:"Zarif ve şık kolye",
            fiyat:250.00,
            resimUrl: "https://picsum.photos/seed/necklace/400/400",
            kategori: Kategori.aksesuar,
            stokAdedi:170,
        ),
        Urun(
            id:8,
            baslik:"Kadın Beyaz Sneaker Ayakkabı",
            aciklama:"Kadınların tarzını tamamlayan şık sneaker ayakkabı",
            fiyat:2299.99,
            resimUrl: "https://picsum.photos/seed/shoes/400/400",
            kategori: Kategori.ayakkabi,
            stokAdedi:44,
        ),
        Urun(
            id:9,
            baslik:"Erkek Deri Ceket",
            aciklama:"Erkeklerin tarzını tamamlayan şık deri ceket",
            fiyat:1799.99,
            resimUrl: "https://picsum.photos/seed/jacket/400/400",
            kategori: Kategori.giyim,
            stokAdedi:35,
        ),      
        
    ];
@override
Future<List<Urun>> tumUrunleriGetir() async{
    await Future.delayed(const Duration(milliseconds:1500));
    return List.from(_urunDeposu);
}

@override
Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async{
    await Future.delayed(const Duration(milliseconds:400));
    if(kategori==Kategori.hepsi){
        return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun)=>urun.kategori==kategori).toList();
}

@override
Future<List<Urun>> adaGoreAra(String aramaMetni) async{
    await Future.delayed(const Duration(milliseconds:300));
    if(aramaMetni.trim().isEmpty){
        return List.from(_urunDeposu);
    }

    return _urunDeposu.where((urun){
        final baslikKucuk=urun.baslik.toLowerCase();
        final arananKucuk=aramaMetni.toLowerCase();
        return baslikKucuk.contains(arananKucuk);
    }).toList();
}
}