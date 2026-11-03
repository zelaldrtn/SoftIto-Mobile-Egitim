import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

// 3D uzaydaki çokgen (poligon) yüzey modeli ve aydınlatma hesaplayıcısı
class Polygon3D {
  final List<Vector3> vertices;
  final Vector3 normal;
  final Color baseColor;
  final bool doubleSided;
  final double specular; // parıltı faktörü

  Polygon3D({
    required this.vertices,
    Vector3? normal,
    required this.baseColor,
    this.doubleSided = false,
    this.specular = 0.0,
  }) : normal = normal ?? _calculateNormal(vertices);

  // köşe noktalarının çapraz çarpımı ile yüzey normalini hesaplar
  static Vector3 _calculateNormal(List<Vector3> v) {
    if (v.length < 3) return Vector3(0, 1, 0);
    final edge1 = v[1] - v[0];
    final edge2 = v[2] - v[0];
    final cross = edge1.cross(edge2);
    final len = cross.length;
    return len > 0.0001 ? cross.normalized() : Vector3(0, 1, 0);
  }

  // poligonun geometrik merkezini hesaplar
  Vector3 get centroid {
    double sumX = 0, sumY = 0, sumZ = 0;
    for (final v in vertices) {
      sumX += v.x;
      sumY += v.y;
      sumZ += v.z;
    }
    final n = vertices.length.toDouble();
    return Vector3(sumX / n, sumY / n, sumZ / n);
  }

  // yüzeyin kameraya bakıp bakmadığını kontrol eder (arkası dönük yüzeyleri çizmemek için)
  bool isFacingCamera(Vector3 cameraPos) {
    if (doubleSided) return true;
    final viewDir = centroid - cameraPos;
    return normal.dot(viewDir) < 0.0;
  }

  // Lambert difüz ve speküler ışıklandırmayı birleştirip yüzeyin gölgeli rengini hesaplar
  Color computeShadedColor({
    required Vector3 lightDir,
    required Color lightColor,
    required Color ambientColor,
    required double ambientIntensity,
    required double diffuseIntensity,
    Vector3? cameraPos,
  }) {
    final dot = normal.dot(lightDir.normalized()).clamp(0.0, 1.0);

    final rBase = baseColor.red / 255.0;
    final gBase = baseColor.green / 255.0;
    final bBase = baseColor.blue / 255.0;

    final rAmb = (ambientColor.red / 255.0) * ambientIntensity;
    final gAmb = (ambientColor.green / 255.0) * ambientIntensity;
    final bAmb = (ambientColor.blue / 255.0) * ambientIntensity;

    final rLit = (lightColor.red / 255.0) * dot * diffuseIntensity;
    final gLit = (lightColor.green / 255.0) * dot * diffuseIntensity;
    final bLit = (lightColor.blue / 255.0) * dot * diffuseIntensity;

    double rFinal = rBase * (rAmb + rLit);
    double gFinal = gBase * (gAmb + gLit);
    double bFinal = bBase * (bAmb + bLit);

    if (specular > 0.0 && cameraPos != null && dot > 0.0) {
      final viewDir = (cameraPos - centroid).normalized();
      final halfDir = (lightDir.normalized() + viewDir).normalized();
      final specDot = math.max(0.0, normal.dot(halfDir));
      final specFactor = math.pow(specDot, 16).toDouble() * specular;
      rFinal += specFactor;
      gFinal += specFactor;
      bFinal += specFactor;
    }

    return Color.fromARGB(
      baseColor.alpha,
      (rFinal.clamp(0.0, 1.0) * 255).round(),
      (gFinal.clamp(0.0, 1.0) * 255).round(),
      (bFinal.clamp(0.0, 1.0) * 255).round(),
    );
  }

  // poligonu Y ekseninde döndürüp verilen mesafeye öteler (transform)
  Polygon3D transformed({
    double rotationYDeg = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    double dz = 0.0,
  }) {
    final rad = radians(rotationYDeg);
    final cosA = math.cos(rad);
    final sinA = math.sin(rad);

    final newVertices = vertices.map((v) {
      final rx = v.x * cosA + v.z * sinA;
      final ry = v.y;
      final rz = -v.x * sinA + v.z * cosA;
      return Vector3(rx + dx, ry + dy, rz + dz);
    }).toList();

    final rnx = normal.x * cosA + normal.z * sinA;
    final rny = normal.y;
    final rnz = -normal.x * sinA + normal.z * cosA;

    return Polygon3D(
      vertices: newVertices,
      normal: Vector3(rnx, rny, rnz).normalized(),
      baseColor: baseColor,
      doubleSided: doubleSided,
      specular: specular,
    );
  }
}

// 6 yüzeyli bir 3D kutu (prizma) üreten yardımcı fonksiyon
List<Polygon3D> createBox3D({
  required Vector3 position,
  required Vector3 size,
  required Color color,
  Color? topColor,
  Color? bottomColor,
  Color? frontColor,
  Color? backColor,
  Color? leftColor,
  Color? rightColor,
  bool fromBottom = true,
  double specular = 0.0,
}) {
  final px = position.x;
  final py = fromBottom ? position.y + size.y / 2 : position.y;
  final pz = position.z;

  final hx = size.x / 2;
  final hy = size.y / 2;
  final hz = size.z / 2;

  final cTop = topColor ?? color;
  final cBottom = bottomColor ?? color.withOpacity(0.85);
  final cFront = frontColor ?? color;
  final cBack = backColor ?? color;
  final cLeft = leftColor ?? color;
  final cRight = rightColor ?? color;

  // kutunun 8 tepe noktası
  final p0 = Vector3(px - hx, py + hy, pz - hz);
  final p1 = Vector3(px + hx, py + hy, pz - hz);
  final p2 = Vector3(px + hx, py + hy, pz + hz);
  final p3 = Vector3(px - hx, py + hy, pz + hz);

  final p4 = Vector3(px - hx, py - hy, pz - hz);
  final p5 = Vector3(px + hx, py - hy, pz - hz);
  final p6 = Vector3(px + hx, py - hy, pz + hz);
  final p7 = Vector3(px - hx, py - hy, pz + hz);

  return [
    // üst yüz
    Polygon3D(
      vertices: [p0, p1, p2, p3],
      normal: Vector3(0, 1, 0),
      baseColor: cTop,
      specular: specular,
    ),
    // alt yüz
    Polygon3D(
      vertices: [p7, p6, p5, p4],
      normal: Vector3(0, -1, 0),
      baseColor: cBottom,
    ),
    // ön yüz
    Polygon3D(
      vertices: [p3, p2, p6, p7],
      normal: Vector3(0, 0, 1),
      baseColor: cFront,
      specular: specular,
    ),
    // arka yüz
    Polygon3D(
      vertices: [p1, p0, p4, p5],
      normal: Vector3(0, 0, -1),
      baseColor: cBack,
      specular: specular,
    ),
    // sol yüz
    Polygon3D(
      vertices: [p0, p3, p7, p4],
      normal: Vector3(-1, 0, 0),
      baseColor: cLeft,
      specular: specular,
    ),
    // sağ yüz
    Polygon3D(
      vertices: [p2, p1, p5, p6],
      normal: Vector3(1, 0, 0),
      baseColor: cRight,
      specular: specular,
    ),
  ];
}

