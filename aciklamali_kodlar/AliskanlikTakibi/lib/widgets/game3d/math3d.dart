import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

// 3D oda için kamera matematiği, projeksiyon ve dokunma kesişim (raycasting) hesaplayıcı
class Camera3D {
  double yaw; // yatay dönüş açısı (derece)
  double pitch; // dikey eğim açısı
  double distance; // kameranın odaya uzaklığı (yakınlaştırma / zoom)
  Vector3 target; // kameranın baktığı hedef nokta
  double fov; // görüş alanı (field of view)

  Camera3D({
    this.yaw = 45.0,
    this.pitch = -30.0,
    this.distance = 13.5,
    Vector3? target,
    this.fov = 42.0,
  }) : target = target ?? Vector3(0.0, 1.0, 0.0);

  // küresel koordinatları kartezyen (X, Y, Z) uzayına çevirerek kamera konumunu bulur
  Vector3 get position {
    final radYaw = radians(yaw);
    final radPitch = radians(pitch);

    final x = target.x + distance * math.cos(radPitch) * math.sin(radYaw);
    final y = target.y - distance * math.sin(radPitch);
    final z = target.z + distance * math.cos(radPitch) * math.cos(radYaw);

    return Vector3(x, y, z);
  }

  // görünüm matrisini oluşturur
  Matrix4 getViewMatrix() {
    final eye = position;
    return makeViewMatrix(eye, target, Vector3(0, 1, 0));
  }

  // perspektif projeksiyon matrisini hesaplar
  Matrix4 getProjectionMatrix(double aspectRatio) {
    return makePerspectiveMatrix(
      radians(fov),
      aspectRatio,
      0.5,
      100.0,
    );
  }

  // iki matrisi çarparak birleşik View-Projection matrisini elde eder
  Matrix4 getViewProjectionMatrix(double aspectRatio) {
    final p = getProjectionMatrix(aspectRatio);
    final v = getViewMatrix();
    return p * v;
  }

  // 3D dünyadaki bir noktayı 2D ekran piksellerine izdüşürür
  ProjectedPoint? project(Vector3 point, Size screenSize, {bool clampNear = false}) {
    final vp = getViewProjectionMatrix(screenSize.width / screenSize.height);
    final v4 = Vector4(point.x, point.y, point.z, 1.0);
    final clip = vp.transformed(v4);

    if (clip.w <= 0.001) {
      if (!clampNear) return null;
      clip.w = 0.001;
    }

    final ndcX = clip.x / clip.w;
    final ndcY = clip.y / clip.w;
    final ndcZ = clip.z / clip.w;

    final screenX = (ndcX + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndcY) * 0.5 * screenSize.height;

    return ProjectedPoint(
      offset: Offset(screenX, screenY),
      depth: ndcZ,
      viewDistance: (position - point).length,
    );
  }

  // ekrandaki dokunma noktasından 3D uzaya doğru giden bir ışın (Ray) fırlatır
  Ray getScreenRay(Offset screenPos, Size screenSize) {
    final aspectRatio = screenSize.width / screenSize.height;
    final vp = getViewProjectionMatrix(aspectRatio);
    final invVP = Matrix4.inverted(vp);

    final ndcX = (screenPos.dx / screenSize.width) * 2.0 - 1.0;
    final ndcY = 1.0 - (screenPos.dy / screenSize.height) * 2.0;

    final nearV4 = invVP.transformed(Vector4(ndcX, ndcY, -1.0, 1.0));
    final nearPoint = Vector3(
      nearV4.x / nearV4.w,
      nearV4.y / nearV4.w,
      nearV4.z / nearV4.w,
    );

    final farV4 = invVP.transformed(Vector4(ndcX, ndcY, 1.0, 1.0));
    final farPoint = Vector3(
      farV4.x / farV4.w,
      farV4.y / farV4.w,
      farV4.z / farV4.w,
    );

    final rayDir = (farPoint - nearPoint).normalized();
    return Ray(origin: nearPoint, direction: rayDir);
  }

  // parmakla dokunulan noktanın zeminle (Y=0) kesiştiği 3D dünya koordinatını bulur
  Vector3? intersectFloorPlane(Offset screenPos, Size screenSize, {double floorY = 0.0}) {
    final ray = getScreenRay(screenPos, screenSize);

    if (ray.direction.y.abs() < 0.0001) return null;

    final t = (floorY - ray.origin.y) / ray.direction.y;
    if (t < 0) return null;

    return ray.origin + (ray.direction * t);
  }
}

// ekrana yansıtılmış 2D nokta ve mesafe bilgisi
class ProjectedPoint {
  final Offset offset;
  final double depth;
  final double viewDistance;

  const ProjectedPoint({
    required this.offset,
    required this.depth,
    required this.viewDistance,
  });
}

// başlangıç noktası ve yönü olan 3D ışın
class Ray {
  final Vector3 origin;
  final Vector3 direction;

  const Ray({required this.origin, required this.direction});
}

