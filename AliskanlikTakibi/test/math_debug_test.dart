import 'dart:math' as math;
import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

Group3D createBox3D(
  Vector3 position,
  Vector3 size, {
  Color? color,
}) {
  final px = position.x;
  final py = position.y;
  final pz = position.z;
  final hx = size.x / 2;
  final hy = size.y / 2;
  final hz = size.z / 2;

  return Group3D([
    // 1. Üst Yüz (+Y: py + hy)
    Face3D(
      Triangle.points(
        Vector3(px + hx, py + hy, pz + hz),
        Vector3(px - hx, py + hy, pz + hz),
        Vector3(px - hx, py + hy, pz - hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px - hx, py + hy, pz - hz),
        Vector3(px + hx, py + hy, pz - hz),
        Vector3(px + hx, py + hy, pz + hz),
      ),
      color: color,
    ),

    // 2. Alt Yüz (-Y: py - hy)
    Face3D(
      Triangle.points(
        Vector3(px - hx, py - hy, pz + hz),
        Vector3(px + hx, py - hy, pz + hz),
        Vector3(px + hx, py - hy, pz - hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px + hx, py - hy, pz - hz),
        Vector3(px - hx, py - hy, pz - hz),
        Vector3(px - hx, py - hy, pz + hz),
      ),
      color: color,
    ),

    // 3. Sol Yüz (-X: px - hx)
    Face3D(
      Triangle.points(
        Vector3(px - hx, py + hy, pz - hz),
        Vector3(px - hx, py - hy, pz - hz),
        Vector3(px - hx, py - hy, pz + hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px - hx, py - hy, pz + hz),
        Vector3(px - hx, py + hy, pz + hz),
        Vector3(px - hx, py + hy, pz - hz),
      ),
      color: color,
    ),

    // 4. Sağ Yüz (+X: px + hx)
    Face3D(
      Triangle.points(
        Vector3(px + hx, py + hy, pz + hz),
        Vector3(px + hx, py - hy, pz + hz),
        Vector3(px + hx, py - hy, pz - hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px + hx, py - hy, pz - hz),
        Vector3(px + hx, py + hy, pz - hz),
        Vector3(px + hx, py + hy, pz + hz),
      ),
      color: color,
    ),

    // 5. Ön Yüz (+Z: pz + hz)
    Face3D(
      Triangle.points(
        Vector3(px - hx, py + hy, pz + hz),
        Vector3(px - hx, py - hy, pz + hz),
        Vector3(px + hx, py - hy, pz + hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px + hx, py - hy, pz + hz),
        Vector3(px + hx, py + hy, pz + hz),
        Vector3(px - hx, py + hy, pz + hz),
      ),
      color: color,
    ),

    // 6. Arka Yüz (-Z: pz - hz)
    Face3D(
      Triangle.points(
        Vector3(px + hx, py + hy, pz - hz),
        Vector3(px + hx, py - hy, pz - hz),
        Vector3(px - hx, py - hy, pz - hz),
      ),
      color: color,
    ),
    Face3D(
      Triangle.points(
        Vector3(px - hx, py - hy, pz - hz),
        Vector3(px - hx, py + hy, pz - hz),
        Vector3(px + hx, py + hy, pz - hz),
      ),
      color: color,
    ),
  ]);
}

bool shouldDraw(Triangle t) {
  return (t.point1.x - t.point0.x) * (t.point2.y - t.point0.y) -
              (t.point1.y - t.point0.y) * (t.point2.x - t.point0.x) <
          0.0;
}

void main() {
  test('Verify perfect window and segmented baseboards', () {
    final bounds = Aabb3.minMax(Vector3(-4.5, -0.5, -4.5), Vector3(4.5, 5.2, 4.5));
    final rotationX = -32.0 * math.pi / 180.0;
    final rotationY = 42.0 * math.pi / 180.0;
    final scale = 1.05 * 200.0;

    final dx = bounds.center.x;
    final dy = bounds.center.y;
    final dz = bounds.center.z;

    final matrix = Matrix4.zero();
    matrix.setIdentity();
    matrix
      ..translate(0.0, 0.0, 0.0)
      ..translate(-dx * scale, dy * scale, dz * scale)
      ..scale(scale, -scale, -scale)
      ..translate(dx, dy, dz)
      ..rotateX(rotationX)
      ..rotateY(rotationY)
      ..rotateZ(0.0)
      ..translate(-dx, -dy, -dz);

    final scene = <Map<String, dynamic>>[];

    void addBox(String name, Vector3 pos, Vector3 size, Color color) {
      final box = createBox3D(pos, size, color: color);
      for (int i = 0; i < box.figures.length; i++) {
        final f = box.figures[i] as Face3D;
        final t = Triangle.copy(f.triangle);
        matrix.perspectiveTransform(t.point0);
        matrix.perspectiveTransform(t.point1);
        matrix.perspectiveTransform(t.point2);
        if (shouldDraw(t)) {
          final avgZ = (t.point0.z + t.point1.z + t.point2.z) / 3;
          scene.add({
            'name': '$name (face $i)',
            'z': avgZ,
          });
        }
      }
    }

    const roomSpan = 8.0;
    const gridSize = 4;
    const tileSize = roomSpan / gridSize; // 2.0
    const halfSpan = roomSpan / 2; // 4.0

    // 1. Left Wall (4 panels) and 4 segmented baseboards:
    for (int ip = 0; ip < gridSize; ip++) {
      final pz = -halfSpan + (ip * tileSize) + (tileSize / 2);
      addBox('LeftWall_$ip', Vector3(-4.05, 2.5, pz), Vector3(0.1, 5.0, tileSize), Colors.grey);
      addBox('Baseboard_L_$ip', Vector3(-3.95, 0.20, pz), Vector3(0.08, 0.24, tileSize), Colors.brown);
    }

    // 2. Back Wall (Panels with Window Cutout in Panel 2):
    for (int ip = 0; ip < gridSize; ip++) {
      final px = -halfSpan + (ip * tileSize) + (tileSize / 2);
      if (ip == 2) {
        // Window opening in Panel 2 (px = 1.0):
        // Wall below window (Y: 0.0 to 1.7)
        addBox('BackWall_2_Lower', Vector3(px, 0.85, 4.05), Vector3(tileSize, 1.7, 0.1), Colors.grey);
        // Wall above window (Y: 3.3 to 5.0)
        addBox('BackWall_2_Upper', Vector3(px, 4.15, 4.05), Vector3(tileSize, 1.7, 0.1), Colors.grey);
        // Window frame (fits cleanly within px = 1.0, width 1.5, height 1.6, Y: 1.7 to 3.3)
        addBox('Window_Frame', Vector3(px, 2.5, 4.02), Vector3(1.5, 1.6, 0.08), Colors.white);
        // Window glass
        addBox('Window_Glass', Vector3(px, 2.5, 3.99), Vector3(1.3, 1.4, 0.04), Colors.lightBlue);
      } else {
        addBox('BackWall_$ip', Vector3(px, 2.5, 4.05), Vector3(tileSize, 5.0, 0.1), Colors.grey);
      }
      addBox('Baseboard_B_$ip', Vector3(px, 0.20, 3.95), Vector3(tileSize, 0.24, 0.08), Colors.brown);
    }

    // 3. Parquet Floor (16 tiles in 4x4 grid)
    for (int ix = 0; ix < gridSize; ix++) {
      for (int iz = 0; iz < gridSize; iz++) {
        final cx = -halfSpan + (ix * tileSize) + (tileSize / 2);
        final cz = -halfSpan + (iz * tileSize) + (tileSize / 2);
        addBox('Tile[$ix,$iz]', Vector3(cx, 0.04, cz), Vector3(tileSize, 0.08, tileSize), Colors.amber);
      }
    }

    // 4. Test Desk
    addBox('Desk_Top', Vector3(-1.6, 1.48, 2.4), Vector3(2.4, 0.12, 1.4), Colors.brown);
    // Legs: start at Y = 0.06 (firmly seated in floor)
    addBox('Desk_Leg1', Vector3(-2.65, 0.74, 2.95), Vector3(0.1, 1.36, 0.1), Colors.black);
    addBox('Desk_Leg2', Vector3(-0.55, 0.74, 2.95), Vector3(0.1, 1.36, 0.1), Colors.black);
    addBox('Desk_Leg3', Vector3(-2.65, 0.74, 1.85), Vector3(0.1, 1.36, 0.1), Colors.black);
    addBox('Desk_Leg4', Vector3(-0.55, 0.74, 1.85), Vector3(0.1, 1.36, 0.1), Colors.black);
    addBox('Desk_Laptop', Vector3(-1.6, 1.56, 2.3), Vector3(0.65, 0.04, 0.45), Colors.blueGrey);

    scene.sort((a, b) => (a['z'] as double).compareTo(b['z'] as double));

    print('Total drawn faces: ${scene.length}');

    // ALL 16 TILES MUST BE VISIBLE
    for (int ix = 0; ix < gridSize; ix++) {
      for (int iz = 0; iz < gridSize; iz++) {
        final hasTile = scene.any((s) => s['name'].toString().contains('Tile[$ix,$iz]'));
        expect(hasTile, isTrue, reason: 'Tile[$ix,$iz] must be drawn!');
      }
    }
    print('All 16 tiles drawn successfully!');
  });
}
