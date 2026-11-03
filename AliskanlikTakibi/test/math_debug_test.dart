import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:aliskanlik_takibi/widgets/game3d/math3d.dart';
import 'package:aliskanlik_takibi/widgets/game3d/mesh3d.dart';
import 'package:aliskanlik_takibi/widgets/game3d/furniture_models_3d.dart';

void main() {
  group('3D Matematik & Kamera Testleri', () {
    test('Camera3D position spherical conversion is correct', () {
      final cam = Camera3D(
        yaw: 0.0,
        pitch: 0.0,
        distance: 10.0,
        target: vm.Vector3(0, 0, 0),
      );

      final pos = cam.position;
      expect(pos.x, closeTo(0.0, 0.001));
      expect(pos.y, closeTo(0.0, 0.001));
      expect(pos.z, closeTo(10.0, 0.001));
    });

    test('Camera3D project converts 3D points to valid 2D screen coordinates', () {
      final cam = Camera3D(
        yaw: 45.0,
        pitch: -30.0,
        distance: 12.0,
        target: vm.Vector3(0, 1.0, 0),
      );

      const screenSize = Size(800, 600);
      final centerPoint = vm.Vector3(0, 1.0, 0);
      final projected = cam.project(centerPoint, screenSize);

      expect(projected, isNotNull);
      // Hedef nokta tam ekranın ortasında olmalıdır
      expect(projected!.offset.dx, closeTo(400.0, 1.0));
      expect(projected.offset.dy, closeTo(300.0, 1.0));
    });

    test('Floor plane raycasting returns valid 3D hit point on floor plane (Y = 0)', () {
      final cam = Camera3D(
        yaw: 45.0,
        pitch: -30.0,
        distance: 12.0,
        target: vm.Vector3(0, 0, 0),
      );

      const screenSize = Size(800, 600);
      // Ekranın tam ortasına basıldığında
      final hit = cam.intersectFloorPlane(const Offset(400, 300), screenSize, floorY: 0.0);

      expect(hit, isNotNull);
      expect(hit!.y, closeTo(0.0, 0.001));
    });
  });

  group('3D Mesh & Poligon Testleri', () {
    test('createBox3D generates 6 outward-facing polygons', () {
      final box = createBox3D(
        position: vm.Vector3(0, 0, 0),
        size: vm.Vector3(2.0, 1.0, 2.0),
        color: Colors.blue,
      );

      expect(box.length, equals(6));
      // Top face normal must point up (+Y)
      expect(box[0].normal.y, closeTo(1.0, 0.001));
      // Bottom face normal must point down (-Y)
      expect(box[1].normal.y, closeTo(-1.0, 0.001));
      // Front face normal must point forward (+Z)
      expect(box[2].normal.z, closeTo(1.0, 0.001));
    });

    test('Polygon3D Lambert shading correctly calculates lit color', () {
      final topFace = Polygon3D(
        vertices: [
          vm.Vector3(-1, 1, -1),
          vm.Vector3(1, 1, -1),
          vm.Vector3(1, 1, 1),
          vm.Vector3(-1, 1, 1),
        ],
        normal: vm.Vector3(0, 1, 0),
        baseColor: const Color(0xFFFFFFFF),
      );

      final shaded = topFace.computeShadedColor(
        lightDir: vm.Vector3(0, 1, 0), // Işık tam tepeden vuruyor
        lightColor: const Color(0xFFFFFFFF),
        ambientColor: const Color(0xFFFFFFFF),
        ambientIntensity: 0.5,
        diffuseIntensity: 0.5,
      );

      expect(shaded.red, equals(255));
      expect(shaded.green, equals(255));
      expect(shaded.blue, equals(255));
    });

    test('Furniture3DFactory builds all requested furniture meshes without errors', () {
      final furnitureIds = [
        'desk_basic',
        'chair_ergonomic',
        'sofa_cozy',
        'bed_modern',
        'wardrobe_wood',
        'bookshelf_library',
        'rug_boho',
        'plant_succulent',
        'lamp_warm',
        'art_nature',
        'trophy_streak_30',
      ];

      for (final id in furnitureIds) {
        final mesh = Furniture3DFactory.createFurnitureMesh(
          itemId: id,
          posX: 0.0,
          posZ: 0.0,
          rotationYDeg: 90.0,
          isNight: false,
        );

        expect(mesh.isNotEmpty, isTrue, reason: 'Mesh for $id should not be empty');
        for (final poly in mesh) {
          expect(poly.vertices.length, greaterThanOrEqualTo(3));
          expect(poly.normal.length, closeTo(1.0, 0.01));
        }
      }
    });
  });
}
