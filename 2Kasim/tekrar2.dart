import 'package:flutter/material.dart';

class HataliveDogruRow extends StatelessWidget{
    const HataliveDogruRow({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(title:const Text("Row ve Layout")),
            body:Padding(
                padding:const EdgeInsets.all(16),
                child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start, //crossAxis : en üstten alta doğru olan eksen. childrenlar bu eksene göre hizalanır
                    children:[
                        const Text(
                            'Hatalı Yapı: A overflowed by *** pixels (sarı siyah şerit)',
                            style:TextStyle(fontWeight:FontWeight.bold,color:Colors.red),
                        ),
                        const SizedBox(height:8),

                        //HATA OLAN KISIM: Uzun metin gelirse sonsuz genislik hesaplayıp patlar.
                        Container(
                            color:Colors.amber.shade100,
                            child:Row(
                                children:[
                                    const Icon(Icons.warning, color:Colors.red),
                                    const SizedBox(width:8),
                                    const Text('Kısa Metin (hata vermez ama uzarsa Render Patlar)'),
                                ],
                            ),
                        ),

                        //DOGRU YAPI: Expanded, sinirlandirma saglar. Uzun metni sıkıştırır.
                        const SizedBox(height:32),
                        const Text('Doğru yapı: Flexible ve expanded ile sınırlandırılmıştır.',
                        style:TextStyle(fontWeight:FontWeight.bold,color:Colors.green),
                        ),
                    ],
                ),


                Container(
                    padding:const EdgeInsets.all(12),
                    decoration:BoxDecoration(
                        color:Colors.green.shade50,
                        borderRadius:BorderRadius.circular(8),
                        border:Border.all(color:Colors.green),
                    ),
                    child:Row(
                        children:[
                            const CircleAvatar(
                                backgroundColor:Colors.green,
                                child:Icon(Icons.check, color:Colors.white),
                            ),
                            const SizedBox(width:12),

                            //Bu kısımda da dikeyde hizalama yaptırmak istiyoruz.
                            //1) crossAxisAlignment.start: başlık ve açıklama metinlerini sola yaslar.
                            //2) expanded: Row'da kalan tüm boşluğu doldurur.
                            Expanded(
                                child:Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children:const[
                                        Text('Softito 4. dönem mobil standartı',
                                        style:TextStylw(fontWeight:FontWeight.bold),
                                        ),
                                        SizedBox(height:4),
                                        Text('Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez',
                                        style:TextStyle(color:Colors.black87),
                                        )
                                    ]
                                )
                            )
                        ]
                    )
                )
            )
        )
    }
}