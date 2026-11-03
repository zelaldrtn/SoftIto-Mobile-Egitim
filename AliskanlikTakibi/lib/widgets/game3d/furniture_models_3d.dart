import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'mesh3d.dart';

/// Tüm Gerçek 3D Mobilya Modellerini Üreten Fabrika Sınıfı
class Furniture3DFactory {
  /// Mobilya ID veya SlotType'a göre 3D yüzeyleri üretir ve dünya koordinatlarına yerleştirir
  static List<Polygon3D> createFurnitureMesh({
    required String itemId,
    required double posX,
    required double posZ,
    required double rotationYDeg,
    required bool isNight,
  }) {
    List<Polygon3D> localPolygons = [];

    if (itemId.startsWith('desk')) {
      localPolygons = _buildDesk(isNight: isNight);
    } else if (itemId.startsWith('chair')) {
      localPolygons = _buildChair(isNight: isNight);
    } else if (itemId.startsWith('sofa')) {
      localPolygons = _buildSofa(isNight: isNight);
    } else if (itemId.startsWith('bed')) {
      localPolygons = _buildBed(isNight: isNight);
    } else if (itemId.startsWith('wardrobe')) {
      localPolygons = _buildWardrobe(isNight: isNight);
    } else if (itemId.startsWith('bookshelf')) {
      localPolygons = _buildBookshelf(isNight: isNight);
    } else if (itemId.startsWith('rug')) {
      localPolygons = _buildRug(isNight: isNight);
    } else if (itemId.startsWith('plant')) {
      localPolygons = _buildPlant(isNight: isNight);
    } else if (itemId.startsWith('lamp')) {
      localPolygons = _buildLamp(isNight: isNight);
    } else if (itemId.startsWith('art')) {
      localPolygons = _buildWallArt(isNight: isNight);
    } else if (itemId.startsWith('trophy')) {
      localPolygons = _buildTrophy(isNight: isNight);
    } else {
      // Varsayılan sevimli komodin/kutu
      localPolygons = createBox3D(
        position: Vector3(0, 0, 0),
        size: Vector3(0.8, 0.8, 0.8),
        color: const Color(0xFFC7A779),
      );
    }

    // Yerel poligonları dünya koordinatlarına ve rotasyonuna dönüştür
    return localPolygons.map((p) {
      return p.transformed(
        rotationYDeg: rotationYDeg,
        dx: posX,
        dy: 0.0,
        dz: posZ,
      );
    }).toList();
  }

  /// Tıklama ve sürükleme seçim yarıçapı
  static double getSelectionRadius(String itemId) {
    if (itemId.startsWith('bed')) return 1.35;
    if (itemId.startsWith('sofa')) return 1.1;
    if (itemId.startsWith('desk')) return 1.15;
    if (itemId.startsWith('wardrobe')) return 1.1;
    if (itemId.startsWith('rug')) return 1.3;
    if (itemId.startsWith('bookshelf')) return 1.0;
    return 0.75;
  }

  // --- 1. ÇALIŞMA MASASI & BİLGİSAYAR ---
  static List<Polygon3D> _buildDesk({required bool isNight}) {
    final list = <Polygon3D>[];
    final woodColor = isNight ? const Color(0xFF5D4037) : const Color(0xFFC48A54);
    final legColor = isNight ? const Color(0xFF263238) : const Color(0xFF37474F);

    // Üst Ahşap Tabla (Genişlik: 2.0, Kalınlık: 0.12, Derinlik: 1.1, Y: 1.24)
    list.addAll(createBox3D(
      position: Vector3(0, 1.24, 0),
      size: Vector3(2.0, 0.12, 1.1),
      color: woodColor,
      specular: 0.15,
    ));

    // 4 Sağlam Metal Ayak (Zeminden Y: 1.24'e kadar)
    final legOffsets = [
      Vector3(-0.85, 0.0, -0.42),
      Vector3(0.85, 0.0, -0.42),
      Vector3(-0.85, 0.0, 0.42),
      Vector3(0.85, 0.0, 0.42),
    ];
    for (final off in legOffsets) {
      list.addAll(createBox3D(
        position: off,
        size: Vector3(0.1, 1.24, 0.1),
        color: legColor,
      ));
    }

    // Açık Dizüstü Bilgisayar (Laptop)
    // Klavye Gövdesi
    list.addAll(createBox3D(
      position: Vector3(0, 1.36, -0.05),
      size: Vector3(0.65, 0.03, 0.45),
      color: const Color(0xFFB0BEC5),
    ));
    // Parlayan Ekran
    list.addAll(createBox3D(
      position: Vector3(0, 1.38, 0.18),
      size: Vector3(0.65, 0.45, 0.04),
      color: isNight ? const Color(0xFF80DEEA) : const Color(0xFFECEFF1),
      specular: 0.4,
    ));

    // Kupa / Kalemlik
    list.addAll(createBox3D(
      position: Vector3(0.65, 1.36, 0.15),
      size: Vector3(0.18, 0.22, 0.18),
      color: const Color(0xFFFFB74D),
    ));

    return list;
  }

  // --- 2. SANDALYE ---
  static List<Polygon3D> _buildChair({required bool isNight}) {
    final list = <Polygon3D>[];
    final cushionColor = isNight ? const Color(0xFF455A64) : const Color(0xFF63856B);
    final frameColor = isNight ? const Color(0xFF1E272C) : const Color(0xFF263238);

    // Oturma Minderi (Y: 0.60)
    list.addAll(createBox3D(
      position: Vector3(0, 0.60, 0),
      size: Vector3(0.72, 0.12, 0.72),
      color: cushionColor,
    ));

    // Sırtlık (Arka tarafta +Z)
    list.addAll(createBox3D(
      position: Vector3(0, 0.72, 0.30),
      size: Vector3(0.68, 0.65, 0.1),
      color: cushionColor,
    ));

    // 4 Ayak
    final legOffsets = [
      Vector3(-0.28, 0.0, -0.28),
      Vector3(0.28, 0.0, -0.28),
      Vector3(-0.28, 0.0, 0.28),
      Vector3(0.28, 0.0, 0.28),
    ];
    for (final off in legOffsets) {
      list.addAll(createBox3D(
        position: off,
        size: Vector3(0.08, 0.60, 0.08),
        color: frameColor,
      ));
    }

    return list;
  }

  // --- 3. KOLTUK & BERJER ---
  static List<Polygon3D> _buildSofa({required bool isNight}) {
    final list = <Polygon3D>[];
    final fabricColor = isNight ? const Color(0xFF37474F) : const Color(0xFF78909C);
    final cushionColor = isNight ? const Color(0xFF263238) : const Color(0xFF90A4AE);
    final legColor = const Color(0xFF4E342E);

    // Kalın Oturma Minderi (Y: 0.35)
    list.addAll(createBox3D(
      position: Vector3(0, 0.35, -0.05),
      size: Vector3(1.4, 0.30, 0.95),
      color: cushionColor,
    ));

    // Yüksek Kavisli Sırtlık
    list.addAll(createBox3D(
      position: Vector3(0, 0.35, 0.35),
      size: Vector3(1.4, 0.75, 0.25),
      color: fabricColor,
    ));

    // Sol Kolçak (-X)
    list.addAll(createBox3D(
      position: Vector3(-0.65, 0.35, -0.05),
      size: Vector3(0.20, 0.50, 0.95),
      color: fabricColor,
    ));

    // Sağ Kolçak (+X)
    list.addAll(createBox3D(
      position: Vector3(0.65, 0.35, -0.05),
      size: Vector3(0.20, 0.50, 0.95),
      color: fabricColor,
    ));

    // 4 Ahşap Ayak
    final legs = [
      Vector3(-0.55, 0.0, -0.38),
      Vector3(0.55, 0.0, -0.38),
      Vector3(-0.55, 0.0, 0.38),
      Vector3(0.55, 0.0, 0.38),
    ];
    for (final leg in legs) {
      list.addAll(createBox3D(
        position: leg,
        size: Vector3(0.09, 0.35, 0.09),
        color: legColor,
      ));
    }

    return list;
  }

  // --- 4. YATAK ---
  static List<Polygon3D> _buildBed({required bool isNight}) {
    final list = <Polygon3D>[];
    final woodFrame = isNight ? const Color(0xFF4E342E) : const Color(0xFF8D6E63);
    final sheetColor = isNight ? const Color(0xFF37474F) : const Color(0xFFE0E0E0);
    final blanketColor = isNight ? const Color(0xFF2E7D32) : const Color(0xFF63856B);
    final pillowColor = const Color(0xFFF5F5F5);

    // Karyola Başlığı (+Z tarafında yüksek ahşap panel)
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 1.15),
      size: Vector3(1.8, 1.1, 0.15),
      color: woodFrame,
    ));

    // Karyola Çerçevesi (Alt zemin tablası)
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0.0),
      size: Vector3(1.7, 0.30, 2.2),
      color: woodFrame,
    ));

    // Beyaz Şilte / Yatak (Çerçevenin üstünde Y: 0.30)
    list.addAll(createBox3D(
      position: Vector3(0, 0.30, 0.0),
      size: Vector3(1.55, 0.32, 2.05),
      color: sheetColor,
    ));

    // Adaçayı Yeşili Nevresim / Yorgan (Yatak üzerinde ön yarı)
    list.addAll(createBox3D(
      position: Vector3(0, 0.62, -0.35),
      size: Vector3(1.58, 0.08, 1.35),
      color: blanketColor,
    ));

    // 2 Adet Kabarık Yastık (Başlık tarafında +Z)
    list.addAll(createBox3D(
      position: Vector3(-0.42, 0.62, 0.70),
      size: Vector3(0.55, 0.14, 0.40),
      color: pillowColor,
    ));
    list.addAll(createBox3D(
      position: Vector3(0.42, 0.62, 0.70),
      size: Vector3(0.55, 0.14, 0.40),
      color: pillowColor,
    ));

    return list;
  }

  // --- 5. GARDIROP & DOLAP ---
  static List<Polygon3D> _buildWardrobe({required bool isNight}) {
    final list = <Polygon3D>[];
    final woodColor = isNight ? const Color(0xFF3E2723) : const Color(0xFF6D4C41);
    final doorColor = isNight ? const Color(0xFF4E342E) : const Color(0xFF795548);
    final handleColor = const Color(0xFFCFD8DC);

    // Ana Dolap Gövdesi (Genişlik: 1.6, Yükseklik: 2.8, Derinlik: 0.85)
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0),
      size: Vector3(1.6, 2.8, 0.85),
      color: woodColor,
    ));

    // Ön Kapaklar (Kabartmalı ön panel)
    list.addAll(createBox3D(
      position: Vector3(0, 0.1, 0.43),
      size: Vector3(1.5, 2.6, 0.04),
      color: doorColor,
    ));

    // 2 Adet Metal Kulp
    list.addAll(createBox3D(
      position: Vector3(-0.08, 1.35, 0.46),
      size: Vector3(0.04, 0.35, 0.03),
      color: handleColor,
      specular: 0.4,
    ));
    list.addAll(createBox3D(
      position: Vector3(0.08, 1.35, 0.46),
      size: Vector3(0.04, 0.35, 0.03),
      color: handleColor,
      specular: 0.4,
    ));

    return list;
  }

  // --- 6. KİTAPLIK & RAF ---
  static List<Polygon3D> _buildBookshelf({required bool isNight}) {
    final list = <Polygon3D>[];
    final woodColor = isNight ? const Color(0xFF4E342E) : const Color(0xFF8D6E63);

    // Sol Panel (-X)
    list.addAll(createBox3D(
      position: Vector3(-0.70, 0.0, 0),
      size: Vector3(0.08, 2.4, 0.65),
      color: woodColor,
    ));
    // Sağ Panel (+X)
    list.addAll(createBox3D(
      position: Vector3(0.70, 0.0, 0),
      size: Vector3(0.08, 2.4, 0.65),
      color: woodColor,
    ));
    // Arka Panel
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0.30),
      size: Vector3(1.4, 2.4, 0.04),
      color: woodColor.withOpacity(0.9),
    ));

    // 4 Katlı Ahşap Raflar
    final shelfY = [0.08, 0.75, 1.45, 2.2];
    for (final sy in shelfY) {
      list.addAll(createBox3D(
        position: Vector3(0, sy, 0),
        size: Vector3(1.36, 0.07, 0.60),
        color: woodColor,
      ));
    }

    // Raflarda Dizili Renkli 3D Kitaplar (Kırmızı, Mavi, Sarı, Yeşil)
    final bookColors = [
      const Color(0xFFE57373),
      const Color(0xFF64B5F6),
      const Color(0xFFFFD54F),
      const Color(0xFF81C784),
    ];
    for (int i = 0; i < 4; i++) {
      list.addAll(createBox3D(
        position: Vector3(-0.45 + (i * 0.14), 0.82, 0.0),
        size: Vector3(0.11, 0.45, 0.38),
        color: bookColors[i % bookColors.length],
      ));
    }
    for (int i = 0; i < 3; i++) {
      list.addAll(createBox3D(
        position: Vector3(0.10 + (i * 0.16), 1.52, 0.0),
        size: Vector3(0.12, 0.48, 0.38),
        color: bookColors[(i + 2) % bookColors.length],
      ));
    }

    return list;
  }

  // --- 7. ZEMİN & HALI ---
  static List<Polygon3D> _buildRug({required bool isNight}) {
    final list = <Polygon3D>[];
    final mainColor = isNight ? const Color(0xFF263238) : const Color(0xFF63856B);
    final borderCol = isNight ? const Color(0xFF37474F) : const Color(0xFFE7C9A5);

    // Ana Halı Plakası (Zeminin sadece 0.02 birim üstünde, dikişsiz)
    list.addAll(createBox3D(
      position: Vector3(0, 0.015, 0),
      size: Vector3(2.4, 0.02, 2.4),
      color: mainColor,
    ));

    // İç Desen Çerçevesi
    list.addAll(createBox3D(
      position: Vector3(0, 0.025, 0),
      size: Vector3(1.8, 0.015, 1.8),
      color: borderCol,
    ));

    return list;
  }

  // --- 8. BİTKİ KÖŞESİ ---
  static List<Polygon3D> _buildPlant({required bool isNight}) {
    final list = <Polygon3D>[];
    final potColor = isNight ? const Color(0xFFCFD8DC) : const Color(0xFFFFFFFF);
    final soilColor = const Color(0xFF3E2723);
    final leafColor = isNight ? const Color(0xFF2E7D32) : const Color(0xFF4CAF50);
    final darkLeaf = isNight ? const Color(0xFF1B5E20) : const Color(0xFF388E3C);

    // Saksı Gövdesi
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0),
      size: Vector3(0.65, 0.65, 0.65),
      color: potColor,
    ));

    // Saksı Toprağı (Y: 0.60)
    list.addAll(createBox3D(
      position: Vector3(0, 0.60, 0),
      size: Vector3(0.55, 0.05, 0.55),
      color: soilColor,
    ));

    // 3D Yeşil Yapraklar (Çapraz ve katmanlı kutular)
    list.addAll(createBox3D(
      position: Vector3(0, 0.65, 0),
      size: Vector3(0.16, 0.75, 0.16),
      color: darkLeaf,
    ));
    list.addAll(createBox3D(
      position: Vector3(-0.20, 0.85, -0.15),
      size: Vector3(0.40, 0.45, 0.08),
      color: leafColor,
    ));
    list.addAll(createBox3D(
      position: Vector3(0.20, 0.95, 0.15),
      size: Vector3(0.42, 0.50, 0.08),
      color: leafColor,
    ));
    list.addAll(createBox3D(
      position: Vector3(-0.15, 1.10, 0.20),
      size: Vector3(0.08, 0.45, 0.42),
      color: darkLeaf,
    ));

    return list;
  }

  // --- 9. AYDINLATMA / LAMBADER ---
  static List<Polygon3D> _buildLamp({required bool isNight}) {
    final list = <Polygon3D>[];
    final metalColor = isNight ? const Color(0xFF263238) : const Color(0xFF37474F);
    final shadeColor = isNight ? const Color(0xFFFFD54F) : const Color(0xFFFFF9C4);

    // Zemin Tabanı
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0),
      size: Vector3(0.55, 0.06, 0.55),
      color: metalColor,
    ));

    // İnce Dikey Metal Boru (Yükseklik: 2.1)
    list.addAll(createBox3D(
      position: Vector3(0, 0.06, 0),
      size: Vector3(0.08, 2.1, 0.08),
      color: metalColor,
    ));

    // Sıcak Işık Şapkası / Abajur
    list.addAll(createBox3D(
      position: Vector3(0, 1.85, 0),
      size: Vector3(0.60, 0.48, 0.60),
      color: shadeColor,
      specular: 0.35,
    ));

    return list;
  }

  // --- 10. DUVAR DEKORU ---
  static List<Polygon3D> _buildWallArt({required bool isNight}) {
    final list = <Polygon3D>[];
    final frameColor = const Color(0xFF5D4037);
    final artColor = isNight ? const Color(0xFF1B5E20) : const Color(0xFF63856B);

    // Tablo Çerçevesi (Genişlik: 1.4, Yükseklik: 1.1, Derinlik: 0.06)
    list.addAll(createBox3D(
      position: Vector3(0, 2.4, 0),
      size: Vector3(1.4, 1.1, 0.06),
      color: frameColor,
    ));

    // Tablo Resmi
    list.addAll(createBox3D(
      position: Vector3(0, 2.45, -0.04),
      size: Vector3(1.2, 0.9, 0.02),
      color: artColor,
    ));

    return list;
  }

  // --- 11. BAŞARI KUPASI ---
  static List<Polygon3D> _buildTrophy({required bool isNight}) {
    final list = <Polygon3D>[];
    final pedestalColor = const Color(0xFF212121);
    final goldColor = const Color(0xFFFFD700);

    // Mermer Kaide (Y: 0.45)
    list.addAll(createBox3D(
      position: Vector3(0, 0.0, 0),
      size: Vector3(0.50, 0.45, 0.50),
      color: pedestalColor,
    ));

    // Altın Kupa Gövdesi (Kaide üzerinde)
    list.addAll(createBox3D(
      position: Vector3(0, 0.45, 0),
      size: Vector3(0.18, 0.20, 0.18),
      color: goldColor,
      specular: 0.5,
    ));
    list.addAll(createBox3D(
      position: Vector3(0, 0.65, 0),
      size: Vector3(0.38, 0.42, 0.38),
      color: goldColor,
      specular: 0.6,
    ));

    // Kupa Kulpları
    list.addAll(createBox3D(
      position: Vector3(-0.25, 0.72, 0),
      size: Vector3(0.12, 0.24, 0.08),
      color: goldColor,
      specular: 0.5,
    ));
    list.addAll(createBox3D(
      position: Vector3(0.25, 0.72, 0),
      size: Vector3(0.12, 0.24, 0.08),
      color: goldColor,
      specular: 0.5,
    ));

    return list;
  }
}
