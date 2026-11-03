import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../widgets/stok_rozeti.dart';

// ürünün detaylı bilgilerini, büyük görselini ve sepete ekleme butonunu gösteren ekran
class UrunDetayEkrani extends StatelessWidget {
  final Urun urun;

  const UrunDetayEkrani({
    super.key,
    required this.urun,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold ekranın temel iskeletini oluşturur
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        centerTitle: true,
      ),
      // taşmaları önlemek için kaydırılabilir gövde kullanıyoruz
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // önceki ekrandaki resimle akıcı geçiş animasyonu sağlamak için Hero kullanıyoruz
            Hero(
              tag: 'urun_resim_${urun.id}',
              child: Center(
                child: SizedBox(
                  height: 240,
                  child: Image.network(
                    urun.resimUrl,
                    // resmi oranını bozmadan belirlenen alana sığdırır
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // kategori adı ve stok rozetini yan yana iki uca yaslıyoruz
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    urun.kategori.gorunenAd,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                StokRozeti(stoktaVarMi: urun.stoktaVarMi),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              urun.baslik,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // puan ve değerlendirme sayısını gösteren satır
            Row(
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  urun.degerlendirme.puan.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${urun.degerlendirme.oySayisi} değerlendirme)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // araya ince yatay çizgi çekiyoruz
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Ürün Açıklaması',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              urun.aciklama,
              style: TextStyle(
                fontSize: 14,
                // satırlar arasındaki boşluk katsayısı
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),
            // alttaki çubuğun içeriği kapatmaması için boşluk bırakıyoruz
            const SizedBox(height: 40),
          ],
        ),
      ),
      // ekranın altına sabitlenen fiyat ve sepete ekle alanı
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          // üste doğru hafif gölge efekti
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        // alt ekran çentiği olan telefonlarda içeriğin alta sıkışmasını önler
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toplam Fiyat',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${urun.fiyat.toStringAsFixed(2)} ₺',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
              // stokta ürün varsa tıklanabilir buton, yoksa null vererek devre dışı bırakıyoruz
              ElevatedButton.icon(
                onPressed: urun.stoktaVarMi
                    ? () {
                        // ekranın altında bilgilendirme mesajı gösteriyoruz
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${urun.baslik} sepete eklendi!'),
                            backgroundColor: Colors.green.shade700,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(urun.stoktaVarMi ? 'Sepete Ekle' : 'Tükendi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

