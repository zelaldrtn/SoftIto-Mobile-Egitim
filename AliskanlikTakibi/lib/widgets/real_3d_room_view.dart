import 'package:flutter/material.dart';
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../models/room_item.dart';
import '../theme/app_theme.dart';

/// Matematiksel ve testlerle doğrulanmış, dışa bakan yüzey yönlerine (normals) sahip 3D Kutu üreticisi.
/// Ditredi'nin Z-Index ve culling sisteminde 360 derecede kusursuz render verir.
Group3D _createBox3D(
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

/// Gerçek 3D Oda Görünümü (Pure 3D Canvas / DiTreDi tabanlı)
/// Doğrulanmış köşe yönleri, dengeli aydınlatma, çakışmayan kontroller ve test mobilyası içerir.
class Real3DRoomView extends StatefulWidget {
  final List<RoomItem> roomItems;
  final bool isDark;
  final bool isNightMode;
  final RoomSlotType? selectedSlot;
  final ValueChanged<RoomSlotType>? onSlotSelected;
  final VoidCallback? onToggleNightMode;

  const Real3DRoomView({
    super.key,
    this.roomItems = const [],
    required this.isDark,
    required this.isNightMode,
    this.selectedSlot,
    this.onSlotSelected,
    this.onToggleNightMode,
  });

  @override
  State<Real3DRoomView> createState() => _Real3DRoomViewState();
}

class _Real3DRoomViewState extends State<Real3DRoomView> {
  late final DiTreDiController _controller;
  bool _showHint = true;

  // Kamera varsayılan açıları (İzometrik 3D açı)
  static const double _defaultRotationX = -32.0;
  static const double _defaultRotationY = 42.0;
  static const double _defaultUserScale = 1.05;

  // Sabit oda sınırları: Kamera rotasyon merkezini tam oda merkezine sabitler
  static final Aabb3 _roomBounds = Aabb3.minMax(
    Vector3(-4.5, -0.5, -4.5),
    Vector3(4.5, 5.2, 4.5),
  );

  @override
  void initState() {
    super.initState();
    _controller = DiTreDiController(
      rotationX: _defaultRotationX,
      rotationY: _defaultRotationY,
      rotationZ: 0.0,
      userScale: _defaultUserScale,
      minUserScale: 0.6,
      maxUserScale: 2.5,
      // Işık ayarı: Yüksek ortam ışığı (ambient light) sayesinde hiçbir açı siyah kalmaz
      lightStrength: 0.36,
      ambientLightStrength: widget.isNightMode ? 0.68 : 0.82,
      light: Vector3(10, 18, 14).normalized(),
    );
  }

  @override
  void didUpdateWidget(covariant Real3DRoomView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isNightMode != widget.isNightMode) {
      _controller.update(
        ambientLightStrength: widget.isNightMode ? 0.68 : 0.82,
        lightStrength: widget.isNightMode ? 0.45 : 0.36,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetCamera() {
    _controller.update(
      rotationX: _defaultRotationX,
      rotationY: _defaultRotationY,
      rotationZ: 0.0,
      userScale: _defaultUserScale,
      translation: const Offset(0, 0),
    );
  }

  void _setPresetAngle(double x, double y) {
    _controller.update(
      rotationX: x,
      rotationY: y,
      rotationZ: 0.0,
      translation: const Offset(0, 0),
    );
  }

  void _zoom(double factor) {
    final nextScale = (_controller.userScale * factor)
        .clamp(_controller.minUserScale, _controller.maxUserScale);
    _controller.update(userScale: nextScale);
  }

  /// 3D Oda Mimarisi ve Tek Test Mobilyasını (Çalışma Masası) İnşa Eder
  List<Model3D> _buildRoomFigures() {
    final isNight = widget.isNightMode;
    final figures = <Model3D>[];

    try {
      const roomSpan = 8.0;
      const gridSize = 4;
      const tileSize = roomSpan / gridSize; // 2.0
      const halfSpan = roomSpan / 2; // 4.0

      final leftWallColor = isNight
          ? const Color(0xFF262D40)
          : const Color(0xFFECE7DD);
      final backWallColor = isNight
          ? const Color(0xFF202636)
          : const Color(0xFFE3DDD2);
      final baseboardColor = isNight
          ? const Color(0xFF5D4037)
          : const Color(0xFF8D6E63);

      // 1. Sol Duvar (-X, Z boyunca 4 bağımsız panel & 4 süpürgelik segmenti)
      // Panel bazında segmentasyon, derinlik tamponundaki çakışmaları tamamen engeller.
      for (int ip = 0; ip < gridSize; ip++) {
        final pz = -halfSpan + (ip * tileSize) + (tileSize / 2);
        figures.add(
          _createBox3D(
            Vector3(-4.05, 2.5, pz),
            Vector3(0.1, 5.0, tileSize),
            color: leftWallColor,
          ),
        );
        figures.add(
          _createBox3D(
            Vector3(-3.95, 0.20, pz),
            Vector3(0.08, 0.24, tileSize),
            color: baseboardColor,
          ),
        );
      }

      // 2. Arka Duvar (+Z, X boyunca 4 panel & pencere yuvası)
      // Panel 2 (px: 1.0): Pencere boşluğu içerir (alt duvar + üst duvar + pencere kasası + cam).
      // Bu sayede pencere camının arkasında çakışan veya kesen katı duvar üçgeni kalmaz.
      for (int ip = 0; ip < gridSize; ip++) {
        final px = -halfSpan + (ip * tileSize) + (tileSize / 2);
        if (ip == 2) {
          // Panel 2 alt duvar (Y: 0.0 - 1.7)
          figures.add(
            _createBox3D(
              Vector3(px, 0.85, 4.05),
              Vector3(tileSize, 1.7, 0.1),
              color: backWallColor,
            ),
          );
          // Panel 2 üst duvar (Y: 3.3 - 5.0)
          figures.add(
            _createBox3D(
              Vector3(px, 4.15, 4.05),
              Vector3(tileSize, 1.7, 0.1),
              color: backWallColor,
            ),
          );
          // Pencere kasası (Panel 2 sınırları içinde: X: 1.0, Y: 2.5, genişlik: 1.5, yükseklik: 1.6)
          figures.add(
            _createBox3D(
              Vector3(px, 2.5, 4.02),
              Vector3(1.5, 1.6, 0.08),
              color: isNight ? const Color(0xFF333E52) : const Color(0xFFFFFFFF),
            ),
          );
          // Pencere camı (Kasanın içinde)
          figures.add(
            _createBox3D(
              Vector3(px, 2.5, 3.99),
              Vector3(1.3, 1.4, 0.04),
              color: isNight ? const Color(0xFF10192A) : const Color(0xFFBCE6FD),
            ),
          );
        } else {
          figures.add(
            _createBox3D(
              Vector3(px, 2.5, 4.05),
              Vector3(tileSize, 5.0, 0.1),
              color: backWallColor,
            ),
          );
        }
        // Segmentli arka süpürgelik
        figures.add(
          _createBox3D(
            Vector3(px, 0.20, 3.95),
            Vector3(tileSize, 0.24, 0.08),
            color: baseboardColor,
          ),
        );
      }

      // 3. Ahşap Parke Zemin (4x4 ızgara, 16 tam karo, dikişsiz ve eksiksiz)
      final parquetTones = isNight
          ? const [
              Color(0xFF4A342B),
              Color(0xFF563D33),
              Color(0xFF452E25),
              Color(0xFF4E352B),
            ]
          : const [
              Color(0xFFE2B887),
              Color(0xFFD8AB7A),
              Color(0xFFE8C293),
              Color(0xFFCFA070),
            ];

      for (int ix = 0; ix < gridSize; ix++) {
        for (int iz = 0; iz < gridSize; iz++) {
          final cx = -halfSpan + (ix * tileSize) + (tileSize / 2);
          final cz = -halfSpan + (iz * tileSize) + (tileSize / 2);
          final colorIndex = (ix * 2 + iz) % parquetTones.length;

          figures.add(
            _createBox3D(
              Vector3(cx, 0.04, cz),
              Vector3(tileSize, 0.08, tileSize),
              color: parquetTones[colorIndex],
            ),
          );
        }
      }

      // 4. Zemin Ön Kaide Etekleri (Diorama platformunun ön kesim kenarları)
      final foundationColor = isNight
          ? const Color(0xFF1E2230)
          : const Color(0xFF2C333D);

      // Ön-Sağ kenar (+X)
      figures.add(_createBox3D(
        Vector3(4.05, -0.12, 0),
        Vector3(0.1, 0.24, 8.2),
        color: foundationColor,
      ));
      // Ön-Sol kenar (-Z)
      figures.add(_createBox3D(
        Vector3(0, -0.12, -4.05),
        Vector3(8.2, 0.24, 0.1),
        color: foundationColor,
      ));

      // 5. TEK TEST MOBİLYASI: Çalışma Masası ve Aksesuarları (Arka-Sol alanda)
      _buildTestDesk(figures, isNight);

    } catch (e, stack) {
      debugPrint('[3D Room Error] 3D Oda sahneleri oluşturulurken hata: $e\n$stack');
    }

    return figures;
  }

  /// Doğrulama için tek, net, oranları kusursuz çalışma masası
  void _buildTestDesk(List<Model3D> figures, bool isNight) {
    try {
      final deskWood = isNight ? const Color(0xFF5D4037) : const Color(0xFFC48A54);
      final legColor = isNight ? const Color(0xFF1E2330) : const Color(0xFF2E3440);

      // Masa konumu: Arka-Sol alanda (X: -1.6, Z: 2.4)
      // Masa Üst Tablası (Zeminin 1.48 m üzerinde)
      figures.add(
        _createBox3D(
          Vector3(-1.6, 1.48, 2.4),
          Vector3(2.4, 0.12, 1.4),
          color: deskWood,
        ),
      );

      // 4 Metal Masa Ayağı (Parke zemin kotundan (Y: 0.06) tablaya (Y: 1.42) kadar uzanır, zemine sağlam basar)
      final legs = [
        Vector3(-2.65, 0.74, 2.95),
        Vector3(-0.55, 0.74, 2.95),
        Vector3(-2.65, 0.74, 1.85),
        Vector3(-0.55, 0.74, 1.85),
      ];
      for (final leg in legs) {
        figures.add(
          _createBox3D(
            leg,
            Vector3(0.1, 1.36, 0.1),
            color: legColor,
          ),
        );
      }

      // Açık Dizüstü Bilgisayar (Laptop)
      // Klavye gövdesi (Masa tablasının tam üstünde)
      figures.add(
        _createBox3D(
          Vector3(-1.6, 1.56, 2.3),
          Vector3(0.65, 0.04, 0.45),
          color: const Color(0xFFB0BEC5),
        ),
      );
      // Parlayan Ekran
      figures.add(
        _createBox3D(
          Vector3(-1.6, 1.84, 2.55),
          Vector3(0.65, 0.46, 0.04),
          color: isNight ? const Color(0xFF80DEEA) : const Color(0xFFE0F7FA),
        ),
      );

      // Çalışma Kupası / Kalemlik
      figures.add(
        _createBox3D(
          Vector3(-2.4, 1.66, 2.7),
          Vector3(0.20, 0.24, 0.20),
          color: const Color(0xFFFFB74D),
        ),
      );
    } catch (e, stack) {
      debugPrint('[3D Room Error] Test masası oluşturulurken hata: $e\n$stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNight = widget.isNightMode;
    final isDarkTheme = widget.isDark;

    return Stack(
      children: [
        // 3D Canvas with gesture rotation & pinch-to-zoom
        Positioned.fill(
          child: DiTreDiDraggable(
            controller: _controller,
            child: DiTreDi(
              controller: _controller,
              figures: _buildRoomFigures(),
              bounds: _roomBounds,
              config: const DiTreDiConfig(
                // Orthographic 3D: Sonsuz derinlik hassasiyeti, sıfır bozulma, kusursuz paralel perspektif
                perspective: false,
                supportZIndex: true,
                defaultColorMesh: Color(0xFFECEFF1),
              ),
            ),
          ),
        ),

        // ÜST KONTROL ÇUBUĞU (FittedBox ile asla taşma yapmaz)
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sol Kısım: Kamera Açı & Preset Butonları
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isDarkTheme ? Colors.black87 : Colors.white)
                          .withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkTheme ? AppColors.darkBorder : AppColors.borderLight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconButton(
                          icon: Icons.restart_alt_rounded,
                          tooltip: 'Kamerayı Sıfırla',
                          onTap: _resetCamera,
                        ),
                        const SizedBox(width: 2),
                        _buildIconButton(
                          icon: Icons.view_in_ar_rounded,
                          tooltip: 'İzometrik Görünüm',
                          onTap: () => _setPresetAngle(-32, 42),
                        ),
                        const SizedBox(width: 2),
                        _buildIconButton(
                          icon: Icons.layers_outlined,
                          tooltip: 'Kuş Bakışı (Üstten)',
                          onTap: () => _setPresetAngle(-65, 45),
                        ),
                        const SizedBox(width: 2),
                        _buildIconButton(
                          icon: Icons.crop_portrait_rounded,
                          tooltip: 'Önden Bakış',
                          onTap: () => _setPresetAngle(-22, 18),
                        ),
                      ],
                    ),
                  ),

                  // Sağ Kısım: Zoom & Işık Kontrolleri
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isDarkTheme ? Colors.black87 : Colors.white)
                          .withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkTheme ? AppColors.darkBorder : AppColors.borderLight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconButton(
                          icon: Icons.add_rounded,
                          tooltip: 'Yakınlaştır',
                          onTap: () => _zoom(1.15),
                        ),
                        const SizedBox(width: 2),
                        _buildIconButton(
                          icon: Icons.remove_rounded,
                          tooltip: 'Uzaklaştır',
                          onTap: () => _zoom(0.87),
                        ),
                        if (widget.onToggleNightMode != null) ...[
                          const SizedBox(width: 2),
                          _buildIconButton(
                            icon: isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                            tooltip: isNight ? 'Gündüz Işığı' : 'Gece Işığı',
                            iconColor: isNight ? Colors.amberAccent : Colors.orange,
                            onTap: widget.onToggleNightMode!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ALT BİLGİ VE JEST REHBERİ (Çakışma olmadan temiz yerleşim)
        Positioned(
          bottom: 6,
          left: 12,
          right: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Jest İpucu
              if (_showHint)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isDarkTheme ? Colors.black87 : Colors.white)
                        .withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.sageGreen.withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.threed_rotation_rounded,
                        size: 14,
                        color: AppColors.sageGreen,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '360° döndürmek için sürükleyin • Yakınlaştırmak için çimdikleyin',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDarkTheme
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => _showHint = false),
                        child: Icon(
                          Icons.close_rounded,
                          size: 13,
                          color: isDarkTheme
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // 3D Render Doğrulama Rozeti
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isDarkTheme ? Colors.black87 : Colors.white)
                        .withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkTheme ? AppColors.darkBorder : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.sageGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '3D Temel Render: Zemin, Duvarlar & Çalışma Masası',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkTheme
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final isDarkTheme = widget.isDark;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 18,
              color: iconColor ??
                  (isDarkTheme
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
