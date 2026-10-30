import 'category.dart';
import 'degerlendirme.dart';
import '../services/i_product_service.dart';


class Urun{
    final int id;
    final String baslik;
    final String aciklama;
    final double fiyat;
    final String resimUrl;
    final Kategori kategori;
    final int stokAdedi;
    final bool favoriMi;
    final Degerlendirme degerlendirme;

    const Urun({
        required this.id,
        required this.baslik,
        required this.aciklama,
        required this.fiyat,
        required this.resimUrl,
        required this.kategori,
        required this.stokAdedi,
        required this.degerlendirme,
        this.favoriMi=false,
    });

    factory Urun.fromJson(Map<String,dynamic> json){
        return Urun(
            id: json['id'] as int,
            baslik:json['title'] as String,
            fiyat:(json['price'] as num).toDouble(),
            aciklama:json['description'] as String,
            kategori:KategoriExtension.apiMetindenUret(json['category'] as String),
            resimUrl:json['image'] as String,
            degerlendirme:Degerlendirme.fromJson(json['rating'] as Map<String,dynamic>),
            stokAdedi:json['stokAdedi'] as int,
            favoriMi:false,
        );
    }

    //copyWith neden kullanılır: favori kısmı için kullanacağız. Sadece favoriMi kısmını değiştirmek istiyoruz.   
    Urun copyWith({
        int? id,
        String? baslik,
        String? aciklama,
        double? fiyat,
        String? resimUrl,
        Kategori? kategori,
        int? stokAdedi,
        bool? favoriMi,
        Degerlendirme? degerlendirme,
    }){
        return Urun(
        id:id ?? this.id,
        baslik:baslik ?? this.baslik,
        aciklama:aciklama ?? this.aciklama,
        fiyat:fiyat ?? this.fiyat,
        resimUrl:resimUrl ?? this.resimUrl,
        kategori:kategori ?? this.kategori,
        stokAdedi:stokAdedi ?? this.stokAdedi,
        degerlendirme:degerlendirme ?? this.degerlendirme,
        favoriMi:favoriMi ?? this.favoriMi,
    );
    }

    @override
    String toString(){
        return 'Urun(id: $id, baslik: $baslik, aciklama: $aciklama, fiyat: $fiyat, favoriMi: $favoriMi)';
    }


}