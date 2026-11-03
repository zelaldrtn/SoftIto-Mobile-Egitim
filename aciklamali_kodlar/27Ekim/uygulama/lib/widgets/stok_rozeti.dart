import 'package:flutter/material.dart';

// ürünün stok durumunu veya tükendi bilgisini renkli kutu içinde gösteren rozet
class StokRozeti extends StatelessWidget{
    final int stok;

    const StokRozeti({super.key,required this.stok});

    @override
    Widget build(BuildContext context){
        final tukendiMi=stok==0;

        // Container arka plan rengi, kenarlık ve iç boşluk verebildiğimiz temel kutu bileşenidir
        return Container(
            // yatayda 8, dikeyde 4 birim iç boşluk (padding)
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical:4),
            decoration: BoxDecoration(
                // tükendiyse açık kırmızı, stok varsa açık yeşil zemin rengi
                color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
                // köşeleri hafifçe yuvarlatıyoruz
                borderRadius: BorderRadius.circular(6),
                // kutunun etrafına ince kenarlık çizgisi çekiyoruz
                border: Border.all(
                    color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
                    width: 0.8,
                ),
            ),
            child: Text(
                tukendiMi ? "Tükendi" : 'Stok: $stok',
                style: TextStyle(
                    color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                ),
            ),
        );
    }
}

