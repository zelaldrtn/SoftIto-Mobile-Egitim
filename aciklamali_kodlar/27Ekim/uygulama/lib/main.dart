import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

// uygulamanın başlangıç noktası, ana widget'ı ayağa kaldırır
void main() {
  runApp(const MiniMagazaUygulamasi());
}

// StatelessWidget durum tutmayan, arayüzü sabit widget'lar içindir
// StatefulWidget ise kullanıcının etkileşimiyle durumu (state) değişebilen widget'lar içindir
class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp Material Design tasarım sisteminin temel yapı taşlarını sunar
    return MaterialApp(
      // sağ üstteki hata ayıklama (debug) bandını gizler
      debugShowCheckedModeBanner: false,
      title:"Mini Mağaza",
      // theme ile uygulamanın genel görsel temasını yapılandırıyoruz
      theme:ThemeData(
        // useMaterial3 en güncel Material 3 tasarım kurallarını etkinleştirir
        useMaterial3: true,
        // seedColor verilen ana renkten tüm renk paletini otomatik türetir
        colorScheme:ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          // uygulamanın açık (light) modda çalışacağını belirtiyoruz
          brightness:Brightness.light,
        ),
      ),

      // uygulamanın ilk açılış ekranı
      home:const UrunListesiEkrani(),
    );
  }
}

