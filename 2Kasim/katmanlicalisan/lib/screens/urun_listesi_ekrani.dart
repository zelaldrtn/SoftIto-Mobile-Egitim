import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/api_urun_servisi.dart';
import 'package:flutter/material.dart';

class UrunListesiEkrani extends StatefulWidget {
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

    @override
    void initState(){
        super.initState();
        _urunleriYukle();
    }
}

Future<void> _urunleriYukle() async {

    try {

      final urunler = await _servis.urunleriGetir();
      if (!mounted) return;
      setState(() {
        _tumUrunler = urunler;
      });
    } catch (hata) {
      if (!mounted) return;
    }
}