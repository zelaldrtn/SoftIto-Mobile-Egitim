import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../widgets/urun_karti.dart';

class AnaSayfa extends StatelessWidget {
  AnaSayfa({super.key});

  final List<Urun> urunler = [
    Urun(id: 1, isim: "Kulaklık", fiyat: 1500),
    Urun(id: 2, isim: "Akıllı Saat", fiyat: 2500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürünlerim"),
      ),
      body: Row(
        children: [
          Expanded(
            child: UrunKarti(urun: urunler[0]),
          ),
          Expanded(
            child: UrunKarti(urun: urunler[1]),
          ),
        ],
      ),
    );
  }
}