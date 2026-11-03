import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../widgets/urun_karti.dart';

// ürünlerin yan yana gösterildiği basit ana ekran
class AnaSayfa extends StatelessWidget {
  AnaSayfa({super.key});

  // ekranda göstereceğimiz örnek ürün listesi
  final List<Urun> urunler = [
    Urun(id: 1, isim: "Kulaklık", fiyat: 1500),
    Urun(id: 2, isim: "Akıllı Saat", fiyat: 2500),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold ekranın temel düzenini sağlar
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürünlerim"),
      ),
      // Row içindeki çocukları yatayda yan yana dizer
      body: Row(
        children: [
          // Expanded ile yatay alanı iki kart arasında eşit paylaştırıyoruz
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

