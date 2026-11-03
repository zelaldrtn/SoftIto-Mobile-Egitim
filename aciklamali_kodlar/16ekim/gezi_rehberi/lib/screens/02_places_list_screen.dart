import 'package:flutter/material.dart';
import '../models/place_model.dart';

// StatelessWidget: listelenecek mekanları ekranda sabit gösteren sayfa
class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  // ekranda gösterilecek sabit örnek mekan verileri listesi
  final List<PlaceItem> places = const [
    PlaceItem(name: 'Galata Kulesi', city: 'İstanbul', category: 'Tarihi Kule', rating: 4.7, entryFee: 650.0),
    PlaceItem(name: 'Efes Antik Kenti', city: 'İzmir', category: 'Antik Şehir', rating: 4.9, entryFee: 700.0),
    PlaceItem(name: 'Göreme Açık Hava Müzesi', city: 'Nevşehir', category: 'Doğal & Tarih', rating: 4.8, entryFee: 480.0),
    PlaceItem(name: 'Uzungöl', city: 'Trabzon', category: 'Doğal Park', rating: 4.3, entryFee: 0.0),
    PlaceItem(name: 'Pamukkale Travertenleri', city: 'Denizli', category: 'Doğal Sit Alanı', rating: 4.6, entryFee: 700.0),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel iskeletini oluşturur
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezilecek Mekanlar'),
        // centerTitle: başlığı AppBar'ın ortasına alır
        centerTitle: true,
      ),
      // ListView.separated: elemanların arasına otomatik ayırıcı çizgi ekleyen performanslı liste yapısı
      body: ListView.separated(
        // EdgeInsets: listenin altına ve üstüne 8 birim boşluk bırakır
        padding: const EdgeInsets.symmetric(vertical: 8),
        // itemCount: listede kaç eleman gösterileceğini belirtir
        itemCount: places.length,
        // separatorBuilder: her eleman arasına konulacak ayırıcı çizgiyi (Divider) oluşturur
        separatorBuilder: (context, index) => const Divider(height: 1),
        // itemBuilder: ekranda beliren her bir satır için widget üretir
        itemBuilder: (context, index) {
          final place = places[index];
          // ListTile: sol ikon, başlık, alt başlık ve sağ alan için hazır Material satır bileşeni
          return ListTile(
            // leading: satırın en solundaki simge alanı
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: const Icon(Icons.place, color: Colors.teal),
            ),
            // title: ana başlık metni
            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            // subtitle: başlığın altındaki açıklama metni
            subtitle: Text('${place.city} • ${place.category}'),
            // trailing: satırın en sağındaki alan (puan ve ücret bilgisi)
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  // MainAxisSize.min: Row'un yatayda tüm alanı kaplamak yerine sadece içeriği kadar yer tutmasını sağlar
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    // SizedBox: araya yatayda sabit 4 birim boşluk bırakır
                    const SizedBox(width: 4),
                    Text('${place.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                // üçlü (ternary) koşul: ücret 0 ise 'Ücretsiz', değilse formatlanmış fiyatı yazar
                Text(
                  // toStringAsFixed: sayıyı virgülsüz tam sayı formatında metne çevirir
                  place.entryFee == 0 ? 'Ücretsiz' : '₺${place.entryFee.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: place.entryFee == 0 ? Colors.green : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

