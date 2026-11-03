import 'package:flutter/material.dart';
import 'screens/ana_sayfa.dart';

// uygulamanın giriş noktası
void main() {
  runApp(const MyApp());
}

// uygulamanın kök widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp temel sayfa yönlendirmesi ve görsel yapıyı sağlar
    return MaterialApp(
      home: AnaSayfa(),
    );
  }
}

