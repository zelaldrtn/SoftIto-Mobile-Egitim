import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../models/room_item.dart';
import 'math3d.dart';
import 'mesh3d.dart';
import 'furniture_models_3d.dart';

// 3D oda sahnesini, zemin parkelerini, duvarları, mobilyaları ve ışıklandırmayı çizen ana CustomPainter
class RoomScene3DPainter extends CustomPainter {
  final Camera3D camera;
  final List<RoomItem> roomItems;
  final String? selectedItemId;
  final bool isDarkTheme;
  final bool isNightMode;
  final bool showGrid;

  RoomScene3DPainter({
    required this.camera,
    required this.roomItems,
    this.selectedItemId,
    required this.isDarkTheme,
    required this.isNightMode,
    this.showGrid = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final camPos = camera.position;

    // 1. Işıklandırma parametreleri (gece ve gündüz moduna göre dinamik)
    final lightDir = isNightMode
        ? Vector3(-4.0, 10.0, 6.0).normalized()
        : Vector3(6.0, 14.0, -3.0).normalized();

    final lightColor = isNightMode
        ? const Color(0xFFFFD54F) // gece lambası sarısı
        : (isDarkTheme ? const Color(0xFFFFF9C4) : const Color(0xFFFFFDE7)); // gündüz gün ışığı

    final ambientColor = isNightMode
        ? const Color(0xFF263238) // gece ambiyansı
        : (isDarkTheme ? const Color(0xFFCFD8DC) : const Color(0xFFFFFFFF));

    final ambientIntensity = isNightMode ? 0.65 : (isDarkTheme ? 0.75 : 0.82);
    final diffuseIntensity = isNightMode ? 0.50 : (isDarkTheme ? 0.55 : 0.62);

    // 2. Katmanlı poligon koleksiyonları (zemin -> duvarlar -> halılar -> mobilyalar -> seçim halkası)
    final floorPolygons = <Polygon3D>[];
    final wallPolygons = <Polygon3D>[];
    final rugPolygons = <Polygon3D>[];
    final furniturePolygons = <Polygon3D>[];
    final overlayPolygons = <Polygon3D>[];

    // mimariyi inşa ediyoruz
    final arch = _buildRoomArchitecture(isNight: isNightMode, isDarkTheme: isDarkTheme);
    floorPolygons.addAll(arch.floor);
    wallPolygons.addAll(arch.walls);

    // yerleştirilmiş mobilyaları 3D sahneye ekliyoruz
    for (final item in roomItems.where((i) => i.isPlaced)) {
      final mesh = Furniture3DFactory.createFurnitureMesh(
        itemId: item.id,
        posX: item.positionX,
        posZ: item.positionZ,
        rotationYDeg: item.rotationY,
        isNight: isNightMode,
      );

      if (item.id.startsWith('rug')) {
        rugPolygons.addAll(mesh);
      } else {
        furniturePolygons.addAll(mesh);
      }
    }

    // seçili eşyanın altına altın sarısı zemin halkası çiziyoruz
    if (selectedItemId != null) {
      try {
        final selItem = roomItems.firstWhere((i) => i.id == selectedItemId && i.isPlaced);
        final radius = Furniture3DFactory.getSelectionRadius(selItem.id);
        overlayPolygons.addAll(_buildSelectionRing(
          posX: selItem.positionX,
          posZ: selItem.positionZ,
          radius: radius,
        ));
      } catch (_) {}
    }

    // 3. Katmanlı çizim fonksiyonu (poligonları kameraya olan mesafelerine göre sıralar)
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    void renderLayer(List<Polygon3D> polygons, {bool sort = true}) {
      final list = <_RenderPolygon>[];

      for (final poly in polygons) {
        if (!poly.isFacingCamera(camPos)) continue;

        final projectedPoints = <Offset>[];
        double sumDepth = 0;
        bool isBehind = false;

        for (final v in poly.vertices) {
          final p = camera.project(v, size, clampNear: true);
          if (p == null) {
            isBehind = true;
            break;
          }
          projectedPoints.add(p.offset);
          sumDepth += p.viewDistance;
        }

        if (isBehind || projectedPoints.length < 3) continue;

        final avgDist = sumDepth / poly.vertices.length;
        final shadedColor = poly.computeShadedColor(
          lightDir: lightDir,
          lightColor: lightColor,
          ambientColor: ambientColor,
          ambientIntensity: ambientIntensity,
          diffuseIntensity: diffuseIntensity,
          cameraPos: camPos,
        );

        list.add(_RenderPolygon(
          points: projectedPoints,
          color: shadedColor,
          viewDistance: avgDist,
        ));
      }

      // derinlik sıralaması: uzaktaki poligonlar önce, yakındakiler sonra çizilir (Painter's Algorithm)
      if (sort) {
        list.sort((a, b) => b.viewDistance.compareTo(a.viewDistance));
      }

      for (final item in list) {
        final path = Path();
        path.moveTo(item.points[0].dx, item.points[0].dy);
        for (int i = 1; i < item.points.length; i++) {
          path.lineTo(item.points[i].dx, item.points[i].dy);
        }
        path.close();

        fillPaint.color = item.color;
        canvas.drawPath(path, fillPaint);

        strokePaint.color = item.color.withOpacity(0.12);
        canvas.drawPath(path, strokePaint);
      }
    }

    renderLayer(floorPolygons, sort: true);
    renderLayer(wallPolygons, sort: true);
    renderLayer(rugPolygons, sort: true);
    renderLayer(furniturePolygons, sort: true);
    renderLayer(overlayPolygons, sort: false);

    // ızgara çizgileri
    if (showGrid) {
      _drawFloorGridLines(canvas, size);
    }
  }

  // odanın zemin karolarını, duvarlarını ve pencerelerini inşa eden yardımcı fonksiyon
  ({List<Polygon3D> floor, List<Polygon3D> walls}) _buildRoomArchitecture({
    required bool isNight,
    required bool isDarkTheme,
  }) {
    final floorList = <Polygon3D>[];
    final wallList = <Polygon3D>[];
    const span = 7.6;
    const half = span / 2;

    final leftWallColor = isNight
        ? const Color(0xFF263238)
        : (isDarkTheme ? const Color(0xFF37474F) : const Color(0xFFEDE7DF));
    final backWallColor = isNight
        ? const Color(0xFF202930)
        : (isDarkTheme ? const Color(0xFF263238) : const Color(0xFFE4DDD3));
    final baseboardColor = isNight
        ? const Color(0xFF452E25)
        : (isDarkTheme ? const Color(0xFF5D4037) : const Color(0xFF8D6E63));

    // 4x4 ahşap parke karoları
    final parquetTones = isNight
        ? const [
            Color(0xFF4A342B),
            Color(0xFF563D33),
            Color(0xFF452E25),
            Color(0xFF4E352B),
          ]
        : (isDarkTheme
            ? const [
                Color(0xFF5D4037),
                Color(0xFF4E342E),
                Color(0xFF6D4C41),
                Color(0xFF4E342E),
              ]
            : const [
                Color(0xFFE2B887),
                Color(0xFFD8AB7A),
                Color(0xFFE8C293),
                Color(0xFFCFA070),
              ]);

    const gridSize = 4;
    const tileSize = span / gridSize;

    for (int ix = 0; ix < gridSize; ix++) {
      for (int iz = 0; iz < gridSize; iz++) {
        final cx = -half + (ix * tileSize) + (tileSize / 2);
        final cz = -half + (iz * tileSize) + (tileSize / 2);
        final color = parquetTones[(ix * 2 + iz) % parquetTones.length];

        floorList.addAll(createBox3D(
          position: Vector3(cx, -0.06, cz),
          size: Vector3(tileSize, 0.06, tileSize),
          color: color,
          specular: 0.1,
        ));
      }
    }

    // sol duvar ve süpürgelik
    wallList.addAll(createBox3D(
      position: Vector3(-half - 0.05, 0.0, 0),
      size: Vector3(0.1, 4.6, span),
      color: leftWallColor,
    ));
    wallList.addAll(createBox3D(
      position: Vector3(-half + 0.03, 0.0, 0),
      size: Vector3(0.06, 0.22, span),
      color: baseboardColor,
    ));

    // arka duvar ve pencere
    wallList.addAll(createBox3D(
      position: Vector3(0, 0.0, half + 0.05),
      size: Vector3(span, 1.4, 0.1),
      color: backWallColor,
    ));
    wallList.addAll(createBox3D(
      position: Vector3(0, 3.4, half + 0.05),
      size: Vector3(span, 1.2, 0.1),
      color: backWallColor,
    ));
    wallList.addAll(createBox3D(
      position: Vector3(-2.6, 1.4, half + 0.05),
      size: Vector3(2.6, 2.0, 0.1),
      color: backWallColor,
    ));
    wallList.addAll(createBox3D(
      position: Vector3(2.6, 1.4, half + 0.05),
      size: Vector3(2.6, 2.0, 0.1),
      color: backWallColor,
    ));

    // pencere kasası ve camı
    wallList.addAll(createBox3D(
      position: Vector3(0.0, 1.4, half + 0.03),
      size: Vector3(2.4, 2.0, 0.08),
      color: isNight ? const Color(0xFF37474F) : Colors.white,
    ));
    wallList.addAll(createBox3D(
      position: Vector3(0.0, 1.5, half + 0.01),
      size: Vector3(2.1, 1.7, 0.02),
      color: isNight ? const Color(0xFF10192A) : const Color(0xFFBCE6FD),
      specular: 0.5,
    ));

    wallList.addAll(createBox3D(
      position: Vector3(0, 0.0, half - 0.03),
      size: Vector3(span, 0.22, 0.06),
      color: baseboardColor,
    ));

    // kaide kenarları
    final foundationColor = isNight
        ? const Color(0xFF1E2230)
        : (isDarkTheme ? const Color(0xFF21252B) : const Color(0xFF2C333D));
    floorList.addAll(createBox3D(
      position: Vector3(half + 0.05, -0.15, 0),
      size: Vector3(0.1, 0.24, span + 0.2),
      color: foundationColor,
    ));
    floorList.addAll(createBox3D(
      position: Vector3(0, -0.15, -half - 0.05),
      size: Vector3(span + 0.2, 0.24, 0.1),
      color: foundationColor,
    ));

    return (floor: floorList, walls: wallList);
  }

  // seçili eşyanın etrafındaki dairesel altın halka
  List<Polygon3D> _buildSelectionRing({
    required double posX,
    required double posZ,
    required double radius,
  }) {
    final list = <Polygon3D>[];
    const segments = 12;
    const ringColor = Color(0xFFFFB300);
    final innerR = radius * 0.82;
    final outerR = radius * 1.05;

    for (int i = 0; i < segments; i++) {
      final a1 = (i / segments) * 2 * math.pi;
      final a2 = ((i + 1) / segments) * 2 * math.pi;

      final p1 = Vector3(posX + innerR * math.cos(a1), 0.025, posZ + innerR * math.sin(a1));
      final p2 = Vector3(posX + outerR * math.cos(a1), 0.025, posZ + outerR * math.sin(a1));
      final p3 = Vector3(posX + outerR * math.cos(a2), 0.025, posZ + outerR * math.sin(a2));
      final p4 = Vector3(posX + innerR * math.cos(a2), 0.025, posZ + innerR * math.sin(a2));

      list.add(Polygon3D(
        vertices: [p1, p2, p3, p4],
        normal: Vector3(0, 1, 0),
        baseColor: ringColor,
        doubleSided: true,
        specular: 0.5,
      ));
    }

    return list;
  }

  // zemin üzerine rehber ızgara çizgileri çizer
  void _drawFloorGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isNightMode ? Colors.white : Colors.black).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const span = 7.6;
    const half = span / 2;
    const step = 0.95;

    for (double x = -half; x <= half + 0.01; x += step) {
      final pStart = camera.project(Vector3(x, 0.01, -half), size);
      final pEnd = camera.project(Vector3(x, 0.01, half), size);
      if (pStart != null && pEnd != null) {
        canvas.drawLine(pStart.offset, pEnd.offset, gridPaint);
      }
    }

    for (double z = -half; z <= half + 0.01; z += step) {
      final pStart = camera.project(Vector3(-half, 0.01, z), size);
      final pEnd = camera.project(Vector3(half, 0.01, z), size);
      if (pStart != null && pEnd != null) {
        canvas.drawLine(pStart.offset, pEnd.offset, gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoomScene3DPainter oldDelegate) {
    return true; // pürüzsüz kamera ve sürükleme animasyonları için sürekli yeniler
  }
}

class _RenderPolygon {
  final List<Offset> points;
  final Color color;
  final double viewDistance;

  _RenderPolygon({
    required this.points,
    required this.color,
    required this.viewDistance,
  });
}

