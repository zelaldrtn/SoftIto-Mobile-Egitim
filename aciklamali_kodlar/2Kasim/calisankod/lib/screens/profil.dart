import 'package:flutter/material.dart';

// kullanıcı profilini gösteren basit ekran
class ProfilEkrani extends StatelessWidget{
    const ProfilEkrani({super.key});
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(title:const Text('Kullanıcı Profili')),
            // Center içeriği hem yatay hem dikeyde ortalar
            body:Center(
                child:TextButton(
                onPressed:(){},
                child:const Text('Sepeti Temizle (0 Yap)'),
            ),
        ),
    );
}
}

