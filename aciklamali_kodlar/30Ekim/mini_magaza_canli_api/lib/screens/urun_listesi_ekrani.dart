import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../services/i_urun_servisi.dart';
import '../services/api_urun_servisi.dart';
import '../widgets/urun_karti.dart';
import 'urun_detay_ekrani.dart';

// API'den ürünleri çeken, arama ve filtreleme durumlarını yöneten ana ekran
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // bağımlılığı azaltmak için somut sınıfı soyut arayüz (IUrunServisi) tipinde tutuyoruz
  final IUrunServisi _servis = ApiUrunServisi();

  final TextEditingController _aramaKontrolcusu = TextEditingController();

  List<Urun> _tumUrunler = [];
  List<Urun> _filtrelenmisUrunler = [];

  bool _yukleniyor = true;
  String? _hataMesaji;
  Kategori _seciliKategori = Kategori.hepsi;

  // sayfa ilk açıldığında verileri çekiyoruz
  @override
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  // bellek sızıntısını önlemek için kontrolcüyü serbest bırakıyoruz
  @override
  void dispose() {
    _aramaKontrolcusu.dispose();
    super.dispose();
  }

  // REST API'den asenkron ürün çeken fonksiyon
  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
    });

    try {
      final urunler = await _servis.urunleriGetir();
      // işlem bittiğinde kullanıcı başka sayfaya geçmiş olabilir, mounted kontrolü yapıyoruz
      if (!mounted) return;

      setState(() {
        _tumUrunler = urunler;
        _filtrelenmisUrunler = urunler;
        _yukleniyor = false;
      });
      _filtreleriUygula();
    } catch (hata) {
      if (!mounted) return;
      setState(() {
        _hataMesaji = 'Ürünler yüklenirken bir sorun oluştu.\nİnternet bağlantınızı kontrol edin.';
        _yukleniyor = false;
      });
    }
  }

  // hem arama metnine hem de seçilen kategoriye göre filtreleme yapar
  void _filtreleriUygula() {
    final aramaMetni = _aramaKontrolcusu.text.toLowerCase().trim();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        final kategoriUygun = _seciliKategori == Kategori.hepsi || urun.kategori == _seciliKategori;
        final aramaUygun = aramaMetni.isEmpty || urun.baslik.toLowerCase().contains(aramaMetni);
        return kategoriUygun && aramaUygun;
      }).toList();
    });
  }

  // kategori çipine tıklandığında seçimi günceller
  void _kategoriDegistir(Kategori yeniKategori) {
    setState(() {
      _seciliKategori = yeniKategori;
    });
    _filtreleriUygula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Mağaza (Canlı API)'),
        centerTitle: true,
        actions: [
          // elle yenileme butonu
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _urunleriYukle,
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: Column(
        children: [
          // arama alanı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _aramaKontrolcusu,
              onChanged: (_) => _filtreleriUygula(),
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                // metin kutusunu temizleme butonu
                suffixIcon: _aramaKontrolcusu.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaKontrolcusu.clear();
                          _filtreleriUygula();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // yatay kaydırılabilir kategori filtre listesi
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: Kategori.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final kategori = Kategori.values[index];
                final seciliMi = _seciliKategori == kategori;

                return ChoiceChip(
                  label: Text(kategori.gorunenAd),
                  selected: seciliMi,
                  onSelected: (secildi) {
                    if (secildi) _kategoriDegistir(kategori);
                  },
                  selectedColor: Colors.indigo.shade100,
                  labelStyle: TextStyle(
                    color: seciliMi ? Colors.indigo.shade900 : Colors.grey.shade800,
                    fontWeight: seciliMi ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          // kalan tüm alanı dolduran gövde
          Expanded(
            child: _durumaGoreGovdeyiOlustur(),
          ),
        ],
      ),
    );
  }

  // yüklenme, hata, boş veya başarılı durumlara göre uygun widget'ı çizer
  Widget _durumaGoreGovdeyiOlustur() {
    // 1. Durum: Veriler yükleniyor
    if (_yukleniyor) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('FakeStore API\'den ürünler yükleniyor...'),
          ],
        ),
      );
    }

    // 2. Durum: Hata oluştu
    if (_hataMesaji != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _hataMesaji!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _urunleriYukle,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Durum: Sonuç bulunamadı
    if (_filtrelenmisUrunler.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Aradığınız kriterlere uygun ürün bulunamadı.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // 4. Durum: Başarılı liste görünümü (aşağı çekince yenileme özellikli)
    return RefreshIndicator(
      onRefresh: _urunleriYukle,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _filtrelenmisUrunler.length,
        itemBuilder: (context, index) {
          final urun = _filtrelenmisUrunler[index];
          return UrunKarti(
            urun: urun,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UrunDetayEkrani(urun: urun),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

