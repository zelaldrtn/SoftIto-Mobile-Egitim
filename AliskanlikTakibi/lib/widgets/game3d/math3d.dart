import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// 3D Matematik, Kamera ve Işın Kesişim (Raycasting) Yardımcı Sınıfı
class Camera3D {
  double yaw; // Yatay dönüş açısı (derece)
  double pitch; // Dikey eğim açısı (derece: örn -32)
  double distance; // Kameranın hedefe uzaklığı (zoom: 8.0 .. 22.0)
  Vector3 target; // Kameranın baktığı oda merkezi noktası (0, 1.2, 0)
  double fov; // Görüş alanı (derece: varsayılan 42)

  Camera3D({
    this.yaw = 45.0,
    this.pitch = -30.0,
    this.distance = 13.5,
    Vector3? target,
    this.fov = 42.0,
  }) : target = target ?? Vector3(0.0, 1.0, 0.0);

  /// Kameranın dünya koordinatlarındaki pozisyonunu hesaplar (Spherical to Cartesian)
  Vector3 get position {
    final radYaw = radians(yaw);
    final radPitch = radians(pitch);

    final x = target.x + distance * math.cos(radPitch) * math.sin(radYaw);
    final y = target.y - distance * math.sin(radPitch);
    final z = target.z + distance * math.cos(radPitch) * math.cos(radYaw);

    return Vector3(x, y, z);
  }

  /// Görünüm (View) Matrisi
  Matrix4 getViewMatrix() {
    final eye = position;
    return makeViewMatrix(eye, target, Vector3(0, 1, 0));
  }

  /// Perspektif Projeksiyon Matrisi
  Matrix4 getProjectionMatrix(double aspectRatio) {
    return makePerspectiveMatrix(
      radians(fov),
      aspectRatio,
      0.5,
      100.0,
    );
  }

  /// View-Projection Birleşik Matrisi
  Matrix4 getViewProjectionMatrix(double aspectRatio) {
    final p = getProjectionMatrix(aspectRatio);
    final v = getViewMatrix();
    return p * v;
  }

  /// 3D Dünya koordinatındaki bir noktayı 2D Ekran koordinatına (piksel) ve derinliğe dönüştürür
  ProjectedPoint? project(Vector3 point, Size screenSize, {bool clampNear = false}) {
    final vp = getViewProjectionMatrix(screenSize.width / screenSize.height);
    final v4 = Vector4(point.x, point.y, point.z, 1.0);
    final clip = vp.transformed(v4);

    if (clip.w <= 0.001) {
      if (!clampNear) return null;
      clip.w = 0.001;
    }

    // Normalized Device Coordinates (-1 .. 1)
    final ndcX = clip.x / clip.w;
    final ndcY = clip.y / clip.w;
    final ndcZ = clip.z / clip.w;

    // Ekran piksel koordinatları (Y ekseni Flutter'da aşağı doğrudur)
    final screenX = (ndcX + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndcY) * 0.5 * screenSize.height;

    return ProjectedPoint(
      offset: Offset(screenX, screenY),
      depth: ndcZ,
      viewDistance: (position - point).length,
    );
  }

  /// Ekran pikseline (mouse / dokunma) denk gelen 3D Işını (Ray) üretir (Unproject)
  Ray getScreenRay(Offset screenPos, Size screenSize) {
    final aspectRatio = screenSize.width / screenSize.height;
    final vp = getViewProjectionMatrix(aspectRatio);
    final invVP = Matrix4.inverted(vp);

    // NDC coordinates (-1..1)
    final ndcX = (screenPos.dx / screenSize.width) * 2.0 - 1.0;
    final ndcY = 1.0 - (screenPos.dy / screenSize.height) * 2.0;

    // Near plane point (Z = -1)
    final nearV4 = invVP.transformed(Vector4(ndcX, ndcY, -1.0, 1.0));
    final nearPoint = Vector3(
      nearV4.x / nearV4.w,
      nearV4.y / nearV4.w,
      nearV4.z / nearV4.w,
    );

    // Far plane point (Z = 1)
    final farV4 = invVP.transformed(Vector4(ndcX, ndcY, 1.0, 1.0));
    final farPoint = Vector3(
      farV4.x / farV4.w,
      farV4.y / farV4.w,
      farV4.z / farV4.w,
    );

    final rayDir = (farPoint - nearPoint).normalized();
    return Ray(origin: nearPoint, direction: rayDir);
  }

  /// Dokunulan ekran noktasının Zemin Düzlemi (Y = floorY) ile kesiştiği 3D dünya noktasını bulur!
  /// Mobilyayı zeminde parmakla sürüklemenin matematiksel temelidir.
  Vector3? intersectFloorPlane(Offset screenPos, Size screenSize, {double floorY = 0.0}) {
    final ray = getScreenRay(screenPos, screenSize);

    // Işın zemine neredeyse paralel mi?
    if (ray.direction.y.abs() < 0.0001) return null;

    final t = (floorY - ray.origin.y) / ray.direction.y;
    if (t < 0) return null; // Kamera arkasında kesişim

    return ray.origin + (ray.direction * t);
  }
}

/// Ekrandaki 2D izdüşüm ve derinlik bilgisi
class ProjectedPoint {
  final Offset offset;
  final double depth; // -1 .. 1 (NDC)
  final double viewDistance; // Kameradan olan fiziksel uzaklık

  const ProjectedPoint({
    required this.offset,
    required this.depth,
    required this.viewDistance,
  });
}

/// 3D Işın sınıfı
class Ray {
  final Vector3 origin;
  final Vector3 direction;

  const Ray({required this.origin, required this.direction});
}
