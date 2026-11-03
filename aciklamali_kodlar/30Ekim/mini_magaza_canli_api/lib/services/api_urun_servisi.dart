import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/urun.dart';
import 'i_urun_servisi.dart';

// FakeStore REST API ile internet üzerinden haberleşen servis
class ApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = 'https://fakestoreapi.com';
  // istek en fazla 10 saniye beklesin, aşarsa hata versin
  static const Duration _zamanAsimi = Duration(seconds: 10);

  // tüm ürünleri çeken asenkron metot
  @override
  Future<List<Urun>> urunleriGetir() async {
    try {
      final uri = Uri.parse('$_baseUrl/products');
      // zaman aşımı kontrollü HTTP GET isteği gönderiyoruz
      final yanit = await http.get(uri).timeout(_zamanAsimi);

      // istek başarılıysa (HTTP 200)
      if (yanit.statusCode == 200) {
        // Türkçe karakterlerin düzgün görünmesi için UTF-8 çözümü yapıyoruz
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        final List<dynamic> jsonListesi = jsonDecode(cozulmusGovde) as List<dynamic>;

        // her bir JSON elemanını Urun modeline dönüştürüyoruz
        return jsonListesi
            .map((oge) => Urun.fromJson(oge as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu hatası: HTTP ${yanit.statusCode}');
      }
    } catch (hata) {
      // hatayı ekranda yakalayıp göstermek için rethrow ile yukarı iletiyoruz
      rethrow;
    }
  }

  // belirli bir ürünün detayını ID ile çeker
  @override
  Future<Urun?> urunGetirById(int id) async {
    try {
      final uri = Uri.parse('$_baseUrl/products/$id');
      final yanit = await http.get(uri).timeout(_zamanAsimi);

      if (yanit.statusCode == 200) {
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        final Map<String, dynamic> jsonHaritasi = jsonDecode(cozulmusGovde) as Map<String, dynamic>;
        return Urun.fromJson(jsonHaritasi);
      } else {
        return null;
      }
    } catch (hata) {
      return null;
    }
  }
}

