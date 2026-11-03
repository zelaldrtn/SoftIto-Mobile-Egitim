import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'sepet_kontrolu.dart';

// alt menü barını sabit tutup sayfaları ortada değiştiren ana kabuk (shell) ekranı
class AnaKasaEkrani extends StatelessWidget{
    final Widget ekranGovdesi;
    const AnaKasaEkrani({super.key,required this.ekranGovdesi});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            // o an seçili rotanın sayfası ekranGovdesi olarak buraya yerleşir
            body:ekranGovdesi,
            // NavigationBar Material 3 standartlarında alt gezinme çubuğudur
            bottomNavigationBar:NavigationBar(
                selectedIndex:_aktifIndexiBul(context),
                onDestinationSelected:(yeniIndex){
                    // tıklanan sekmeye göre rotayı değiştiriyoruz
                    if(yeniIndex==0)context.go('/vitrin');
                    if(yeniIndex==1)context.go('/profil');
                },
                destinations:[
                    const NavigationDestination(icon:Icon(Icons.store),label:'Vitrin'),
                        NavigationDestination(
                            // sepet sayısını dinleyip profil ikonu üzerindeki rozeti (Badge) güncelliyoruz
                            icon:ValueListenableBuilder<int>(
                                valueListenable:SepetKontrolu.ornek.urunSayisi,
                                builder:(context,sayi,child){
                                    return Badge(
                                        label:Text('$sayi'),
                                        // sayı 0 ise rozeti gizliyoruz
                                        isLabelVisible:sayi>0,
                                        child:const Icon(Icons.person),
                                    );
                                },
                            ),
                            label:'Profil',

                        ),
                ],
            ),
        );
    }

    // o anki rotaya göre hangi sekmenin aktif olduğunu tespit eder
    int _aktifIndexiBul(BuildContext context){
        final String konum = GoRouterState.of(context).uri.toString();
        if(konum.startsWith('/profil')) return 1;
        return 0;
    }

}

