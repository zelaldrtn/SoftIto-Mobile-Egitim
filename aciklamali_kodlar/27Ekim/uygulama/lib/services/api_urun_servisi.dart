import 'dart:convert';
import 'package:http/http.dart';
import '../models/product.dart';
import '../models/category.dart';
import 'i_product_service.dart';

// gerçek REST API üzerinden ürün verilerini çeken servis sınıfı
class ApiUrunServisi implements IProductService {
    // API'nin temel istek adresi
    static const String _baseUrl='https://fakestoreapi.com/products';

    @override
    Future<List<Urun>> tumUrunleriGetir() async{
        // string adresi Uri nesnesine dönüştürüyoruz
        final uri=Uri.parse(_baseUrl);

        try{
            // ağ isteğine 10 saniye süre sınırı koyuyoruz, yanıt gelmezse zaman aşımı fırlatır
            final yanit=await http.get(uri).timeout(
                const Duration(seconds:10),
                onTimeout:()=> throw Exception("Ağ isteği zaman aşımına uğradı (Timeout)"),
            );
            // 200 HTTP durum kodu isteğin başarıyla tamamlandığını gösterir
            if(yanit.statusCode==200){
                // utf8.decode ile Türkçe karakter bozulmalarını önleyip JSON dizisini çözümlüyoruz
                final List<dynamic> hamListe=jsonDecode(utf8.decode(yanit.bodyBytes));
                return hamListe.map((tekilJson)=>Urun.fromJson(tekilJson as Map<String,dynamic>)).toList();
            }else{
                throw Exception('Sunucu hatası oluştu! Durum kodu: ${yanit.statusCode}');
            }
        }catch(hata){
            throw Exception('İnternet Bağlantısı Kurulamadı: $hata');
        }
    }

    @override
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async{
        if(kategori==Kategori.hepsi){
            return tumUrunleriGetir();
        }
        String kategoriYolu;
        switch(kategori){
            case Kategori.elektronik:
                kategoriYolu='electronics';
                break;
            case Kategori.giyim:
                kategoriYolu="men's clothing";
                break;
            case Kategori.mobilya:
                kategoriYolu='jewelery';
                break;
            default:
                return tumUrunleriGetir();               
        }

        // seçilen kategori yolunu URL sonuna ekleyip istek atıyoruz
        final uri=Uri.parse('$_baseUrl/category/$kategoriYolu');
        final yanit=await http.get(uri);

        if(yanit.statusCode==200){
            final List<dynamic> hamListe=jsonDecode(utf8.decode(yanit.bodyBytes));
            return hamListe.map((j)=>Urun.fromJson(j as Map<String,dynamic>)).toList();
        }else{
            throw Exception('Kategori Filtreleme Hatası: ${yanit.statusCode}');
        }
    }

    @override
    Future<List<Urun>> adaGoreAra(String aramaMetni) async {
        final tumUrunler=await tumUrunleriGetir();
        if(aramaMetni.trim().isEmpty) return tumUrunler;

        // başlıkta veya açıklamada aranan metin geçiyor mu kontrol ediyoruz
        return tumUrunler.where((urun){
            return urun.baslik.toLowerCase().contains(aramaMetni.toLowerCase()) || urun.aciklama.toLowerCase().contains(aramaMetni.toLowerCase());
        }).toList();
    }
}

