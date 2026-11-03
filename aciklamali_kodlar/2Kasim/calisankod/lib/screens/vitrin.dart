import 'package:flutter/material.dart';
import 'sepet_kontrolu.dart';

// ürünlerin sergilendiği ve sepete ekleme yapılan vitrin ekranı
class VitrinEkrani extends StatelessWidget{
        const VitrinEkrani({super.key});
        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar:AppBar(title:const Text('Canlı Vitrin(ValueNotifier)')),
                body:Center(
                    // butona basıldığında singleton kontrolcüdeki sepeteEkle fonksiyonunu çağırıyoruz
                    child:ElevatedButton.icon(
                        onPressed:(){
                            SepetKontrolu.ornek.sepeteEkle();
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label:const Text('Sepete Ürün Ekle (+1)'),
                    ),
                ),
            );
        }
    }

