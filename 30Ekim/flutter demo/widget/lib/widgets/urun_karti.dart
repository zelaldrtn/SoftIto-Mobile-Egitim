import 'package:flutter/material.dart';  //Flutterin material design bileşenlerini getirir.
import '../moels/urun.dart'; //kendi oluşturduğumuz ürün dart dosyasını içeri aktarıyoruz.

class UrunKarti extends StatelessWidget{
    final Urun urun; //

    const UrunKarti({
        super.key,
        required this.urun,
    });

    @override
    Widget build(BuildContext context){
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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