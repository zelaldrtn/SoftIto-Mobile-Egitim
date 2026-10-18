import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet & Rotalar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Öne Çıkan Rota Kartı
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.teal.shade700,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Günün Rotası', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        const Icon(Icons.star, color: Colors.amberAccent),
                      ],
                    ),
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

  Widget _buildCategoryItem(IconData icon, String title, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}