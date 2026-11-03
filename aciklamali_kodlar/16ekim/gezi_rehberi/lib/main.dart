import 'package:flutter/material.dart';
import 'screens/01_discover_screen.dart';
import 'screens/02_places_list_screen.dart';
import 'screens/03_add_place_screen.dart';

// uygulamanın başlangıç noktası, uygulama açılınca ilk bu fonksiyon çalışır
void main() {
  // kök widget'ı ekrana çizerek Flutter uygulamasını başlatır
  runApp(const GeziRehberiApp());
}

// StatelessWidget: ekran çizildikten sonra kendi kendine durumu (state) değişmeyen sabit widget
class GeziRehberiApp extends StatelessWidget {
  const GeziRehberiApp({super.key});

  @override
  // build metodu widget'ın ekrandaki görünümünü oluşturur
  Widget build(BuildContext context) {
    // MaterialApp: tema ve sayfa yönlendirmesi gibi temel Material Design ayarlarını tutar
    return MaterialApp(
      // sağ üstteki debug bandını gizler
      debugShowCheckedModeBanner: false,
      title: 'Gezi Rehberi',
      // uygulamanın genel görsel temasını belirler
      theme: ThemeData(
        // Material 3 tasarım sistemini aktif eder
        useMaterial3: true,
        // seçilen tohum renge (seedColor) göre tüm arayüz renk paletini otomatik üretir
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      // uygulama açıldığında ilk karşılanan ana sayfa
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel iskeletini (appBar, body vb.) oluşturur
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezi Rehberi & Rotalar'),
        // centerTitle: başlığı yatayda ortalar
        centerTitle: true,
        // geçerli temanın zıt renk tonunu AppBar arka planına verir
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          // EdgeInsets: dört bir taraftan 24 birim iç boşluk verir
          padding: const EdgeInsets.all(24.0),
          // Column: altındaki widget'ları dikey sırada alt alta dizer
          child: Column(
            // MainAxisAlignment: ana eksende (dikeyde) çocukları ortalar
            mainAxisAlignment: MainAxisAlignment.center,
            // CrossAxisAlignment: yan eksende (yatayda) çocukları tüm genişliğe yayar
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMenuButton(
                context,
                title: '1. Keşfet Paneli (Layout & Kartlar)',
                icon: Icons.explore_outlined,
                target: const DiscoverScreen(),
              ),
              // SizedBox: araya dikeyde sabit boşluk bırakır
              const SizedBox(height: 18),
              _buildMenuButton(
                context,
                title: '2. Gezilecek Mekanlar (List & Model)',
                icon: Icons.map_outlined,
                target: const PlacesListScreen(),
              ),
              const SizedBox(height: 18),
              _buildMenuButton(
                context,
                title: '3. Yeni Mekan Ekle (Form & Validation)',
                icon: Icons.add_location_alt_outlined,
                target: const AddPlaceScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // menü butonlarını tek yerden üreten yardımcı fonksiyon
  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required Widget target}) {
    // ElevatedButton.icon: ikonlu ve dolgulu buton yapısı
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(title, style: const TextStyle(fontSize: 15)),
      ),
      // butona basılınca hedef sayfaya geçişi tetikler
      onPressed: () {
        // Navigator.push: yeni sayfayı ekran yığınına ekler ve kullanıcıyı oraya taşır
        // MaterialPageRoute: platforma uygun yumuşak sayfa geçiş animasyonu sağlar
        Navigator.push(context, MaterialPageRoute(builder: (context) => target));
      },
    );
  }
}

