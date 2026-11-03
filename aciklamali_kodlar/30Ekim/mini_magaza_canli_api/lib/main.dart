import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

// uygulamanın başlangıç noktası
void main() {
  runApp(
    const MiniMagazaApiUygulamasi(),
  );
}

// uygulamanın kök widget'ı, tema ve başlangıç sayfasını yapılandırır
class MiniMagazaApiUygulamasi extends StatelessWidget {
  const MiniMagazaApiUygulamasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // MaterialApp ile genel tasarım ayarlarını ve renk şemasını belirliyoruz
    return MaterialApp(
      title: 'Mini Mağaza Canlı API',
      // sağ üstteki debug bandını kaldırır
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material 3 tasarım dilini etkinleştiriyoruz
        useMaterial3: true,
        // seedColor verilen renge göre tüm buton ve zemin tonlarını otomatik üretir
        colorSchemeSeed: Colors.indigo,
        // uygulama genelindeki tüm AppBar'lar için ortak tema
        appBarTheme: const AppBarTheme(
          // başlığı ortalar
          centerTitle: true,
          // elevation 0 ile üst çubuğun gölgesini sıfırlayıp düz görünüm sağlıyoruz
          elevation: 0,
        ),
      ),
      // ilk açılacak ekran
      home: const UrunListesiEkrani(),
    );
  }
}

