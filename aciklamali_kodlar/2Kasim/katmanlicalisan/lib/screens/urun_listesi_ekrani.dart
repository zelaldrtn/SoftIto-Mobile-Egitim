import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/api_urun_servisi.dart';
import 'package:flutter/material.dart';

// ürünlerin listelendiği ekran
class UrunListesiEkrani extends StatefulWidget {
  // dışarıdan servis nesnesi kabul eden parametre
  final IUrunServisi urunServisi;

  const UrunListesiEkrani({
    super.key,
    required this.urunServisi,
  });

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani>{
    List<UrunModel> _tumUrunler=[];

    // ekran ilk ayağa kalktığında çalışır
    @override
    void initState(){
        super.initState();
        _urunleriYukle();
    }
}

// ürünleri servisten asenkron çeken fonksiyon
Future<void> _urunleriYukle() async {

    try {

      final urunler = await _servis.urunleriGetir();
      // ekran kapandıysa setState çağırmamak için kontrol
      if (!mounted) return;
      setState(() {
        _tumUrunler = urunler;
      });
    } catch (hata) {
      if (!mounted) return;
    }
}

