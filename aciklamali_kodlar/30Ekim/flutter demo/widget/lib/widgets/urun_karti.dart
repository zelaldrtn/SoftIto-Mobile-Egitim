import 'package:flutter/material.dart';
import '../models/urun.dart';

// tek bir ürünü simge, başlık ve fiyatıyla gösteren kart bileşeni
class UrunKarti extends StatelessWidget{
    final Urun urun;

    const UrunKarti({
        super.key,
        required this.urun,
    });

    @override
    Widget build(BuildContext context){
        // Card gölgeli ve yuvarlak hatlı bir kutu oluşturur
        return Card(
            child: Padding(
                // her kenardan 16 birim iç boşluk bırakıyoruz
                padding: const EdgeInsets.all(16),
                child: Column(
                    // Column dikeyde tüm ekranı kaplamak yerine sadece içindeki elemanlar kadar yer tutsun
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Icon(Icons.shopping_bag, size:50),
                        Text(urun.isim),
                        Text("${urun.fiyat} TL"),
                    ],
                ),
            ),
        );
    }
}

