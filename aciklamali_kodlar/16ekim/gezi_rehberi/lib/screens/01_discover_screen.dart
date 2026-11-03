import 'package:flutter/material.dart';

// StatelessWidget: kullanıcı etkileşimiyle durumu değişmeyen sabit keşif sayfası
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel yapısını kurar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet & Rotalar'),
        // centerTitle: başlığı AppBar'ın ortasına hizalar
        centerTitle: true,
      ),
      // SingleChildScrollView: içerik ekrana sığmadığında dikeyde kaydırılabilmesini sağlar
      body: SingleChildScrollView(
        // EdgeInsets: sayfanın tüm kenarlarından 16 birim iç boşluk bırakır
        padding: const EdgeInsets.all(16.0),
        // Column: altındaki widget'ları dikey sırada alt alta dizer
        child: Column(
          // CrossAxisAlignment: yatay eksende tüm genişliği kaplayacak şekilde yayar
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Öne Çıkan Rota Kartı
            // Card: gölgeli ve yuvarlak köşeli hazır kart bileşeni
            Card(
              // elevation: kartın altına derinlik katan gölge seviyesini belirler
              elevation: 4,
              // RoundedRectangleBorder ve BorderRadius: kartın köşelerini yuvarlatır
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.teal.shade700,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: elemanları yatay sırada yan yana dizer
                    Row(
                      // MainAxisAlignment: yatayda elemanları iki uca yaslar
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container: rozet görünümü için stil verilen kutu
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          // BoxDecoration: kutuya arka plan rengi ve yuvarlak köşe verir
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Günün Rotası', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        const Icon(Icons.star, color: Colors.amberAccent),
                      ],
                    ),
                    // SizedBox: araya dikeyde sabit boşluk bırakır
                    const SizedBox(height: 12),
                    const Text('Kapadokya Vadileri', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Nevşehir, Türkiye', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 16),
                    const Text('Balon turları, peri bacaları ve yer altı şehirleriyle dolu 2 günlük rota.', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Kategoriler Başlığı
            const Text('Kategoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              // MainAxisAlignment.spaceAround: elemanların arasına ve kenarlarına eşit boşluk dağıtır
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryItem(Icons.museum, 'Müze', Colors.orange),
                _buildCategoryItem(Icons.park, 'Doğa', Colors.green),
                _buildCategoryItem(Icons.beach_access, 'Sahil', Colors.blue),
                _buildCategoryItem(Icons.restaurant, 'Tarih', Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // Seyahat İstatistiği Kartı
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('12', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                        Text('Gezilen Şehir', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('38', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                        Text('Görülen Mekan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('4.8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                        Text('Ortalama Puan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // kategori simgesi ve başlığını oluşturan yardımcı metot
  Widget _buildCategoryItem(IconData icon, String title, Color color) {
    return Column(
      children: [
        // CircleAvatar: yuvarlak simge veya profil alanı oluşturur
        CircleAvatar(
          radius: 26,
          // withOpacity: renge şeffaflık oranı katar (0.15 = %15 görünürlük)
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

