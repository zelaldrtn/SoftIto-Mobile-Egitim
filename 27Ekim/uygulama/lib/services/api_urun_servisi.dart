import 'dart:convert';
import 'package:http/http.dart';
import '../models/product.dart';
import '../models/category.dart';
import 'i_product_service.dart';

class ApiUrunServisi implements IProductService {
    static const String _baseUrl='https://fakestoreapi.com/products';

    @override
    Future<List<Urun>> tumUrunleriGetir() async{
        final uri=Uri.parse(_baseUrl);
        // uri: urlyi parse etmemizi sağlar.

        try{
            //herkes aynı anda çalışınca hata almayalım diye timeout ekliyoruz.  
            final yanit=await http.get(uri).timeout(
                const Duration(seconds:10),
                onTimeout:()=> throw Exception("Ağ isteği zaman aşımına uğradı (Timeout)"),
            ); // noktalı virgül olmasının sebebi: await kullanmamız. Noktalı virgül,awaited fonksiyon çağrısının bitmesini beklediği için koyulur.
            if(yanit.statusCode==200){
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

        //return içinde return olmasının sebebi: where filtreleme yaptı. diğer return ile onu listeye çeviriyoruz.
        return tumUrunler.where((urun){
            return urun.baslik.toLowerCase().contains(aramaMetni.toLowerCase()) || urun.aciklama.toLowerCase().contains(aramaMetni.toLowerCase());
        }).toList();
    }
}
