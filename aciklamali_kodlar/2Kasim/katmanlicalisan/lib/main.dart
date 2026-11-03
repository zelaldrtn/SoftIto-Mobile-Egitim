import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

// uygulamanın giriş noktası
void main() {
  runApp(const MyApp());
}

// kök widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp ile uygulama genel temasını ayarlıyoruz
    return MaterialApp(
      title: 'Mini Mağaza Canlı API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material 3 tasarım dilini aktifleştiriyoruz
        useMaterial3: true,
        // seedColor tüm renk şemasını indigo renginden türetir
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const UrunListesiEkrani(),
    );
  }
}

