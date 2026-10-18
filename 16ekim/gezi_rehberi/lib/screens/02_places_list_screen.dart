import 'package:flutter/material.dart';
import '../models/place_model.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  final List<PlaceItem> places = const [
    PlaceItem(name: 'Galata Kulesi', city: 'İstanbul', category: 'Tarihi Kule', rating: 4.7, entryFee: 650.0),
    PlaceItem(name: 'Efes Antik Kenti', city: 'İzmir', category: 'Antik Şehir', rating: 4.9, entryFee: 700.0),
    PlaceItem(name: 'Göreme Açık Hava Müzesi', city: 'Nevşehir', category: 'Doğal & Tarih', rating: 4.8, entryFee: 480.0),
    PlaceItem(name: 'Uzungöl', city: 'Trabzon', category: 'Doğal Park', rating: 4.3, entryFee: 0.0),
    PlaceItem(name: 'Pamukkale Travertenleri', city: 'Denizli', category: 'Doğal Sit Alanı', rating: 4.6, entryFee: 700.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezilecek Mekanlar'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: places.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final place = places[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: const Icon(Icons.place, color: Colors.teal),
            ),
            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${place.city} • ${place.category}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${place.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
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