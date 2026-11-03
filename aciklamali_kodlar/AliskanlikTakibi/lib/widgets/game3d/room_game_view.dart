import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../../models/room_item.dart';
import '../../services/habit_provider.dart';
import '../../theme/app_theme.dart';
import '../../screens/room_store_screen.dart';
import 'math3d.dart';
import 'furniture_models_3d.dart';
import 'room_scene_3d.dart';

// 3D oda etkileşim modları: kamerayı döndürme veya mobilyaları taşıma
enum RoomInteractionMode {
  orbitCamera('Kamera', Icons.threed_rotation_rounded),
  moveFurniture('Eşya Taşı', Icons.open_with_rounded);

  final String label;
  final IconData icon;
  const RoomInteractionMode(this.label, this.icon);
}

// gerçek 3D dekorasyon alanı, parmakla sürükleme ve kamera kontrolünü sağlayan widget
class Room3DGameView extends StatefulWidget {
  final bool isDark;
  final bool isNightMode;
  final VoidCallback onToggleNightMode;
  final String? initialSelectedItemId;

  const Room3DGameView({
    super.key,
    required this.isDark,
    required this.isNightMode,
    required this.onToggleNightMode,
    this.initialSelectedItemId,
  });

  @override
  State<Room3DGameView> createState() => _Room3DGameViewState();
}

class _Room3DGameViewState extends State<Room3DGameView> {
  // late ile ilk değer atamasını initState içinde yapıyoruz
  late final Camera3D _camera;
  final ScrollController _trayScrollController = ScrollController();

  RoomInteractionMode _mode = RoomInteractionMode.moveFurniture;
  String? _selectedItemId;
  String? _draggingItemId;
  bool _snapToGrid = false;
  bool _showGrid = true;
  bool _showHint = true;

  // kamera varsayılan başlangıç açıları
  static const double _defaultYaw = 42.0;
  static const double _defaultPitch = -32.0;
  static const double _defaultDistance = 14.5;

  @override
  void initState() {
    super.initState();
    _selectedItemId = widget.initialSelectedItemId;
    _camera = Camera3D(
      yaw: _defaultYaw,
      pitch: _defaultPitch,
      distance: _defaultDistance,
      target: vm.Vector3(0.0, 1.1, 0.0),
      fov: 42.0,
    );
  }

  // dışarıdan seçili eşya parametresi değiştiğinde tetiklenir
  @override
  void didUpdateWidget(covariant Room3DGameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedItemId != null && widget.initialSelectedItemId != _selectedItemId) {
      setState(() {
        _selectedItemId = widget.initialSelectedItemId;
        _mode = RoomInteractionMode.moveFurniture;
      });
    }
  }

  // bellek sızıntısını önlemek için scroll kontrolcüsünü temizliyoruz
  @override
  void dispose() {
    _trayScrollController.dispose();
    super.dispose();
  }

  // seçilen eşyaya alttaki listede otomatik kaydırma yapar
  void _scrollToItem(String itemId, List<RoomItem> ownedList) {
    final index = ownedList.indexWhere((i) => i.id == itemId);
    if (index != -1 && _trayScrollController.hasClients) {
      final offset = (index * 130.0).clamp(0.0, _trayScrollController.position.maxScrollExtent);
      _trayScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // kamerayı başlangıç açısına sıfırlar
  void _resetCamera() {
    setState(() {
      _camera.yaw = _defaultYaw;
      _camera.pitch = _defaultPitch;
      _camera.distance = _defaultDistance;
    });
  }

  // hazır kamera açılarına geçer
  void _setPresetAngle(double pitch, double yaw) {
    setState(() {
      _camera.pitch = pitch;
      _camera.yaw = yaw;
    });
  }

  // yakınlaştırma / uzaklaştırma (zoom)
  void _zoom(double factor) {
    setState(() {
      _camera.distance = (_camera.distance * factor).clamp(8.0, 22.0);
    });
  }

  // ekranda dokunulan noktaya en yakın yerleştirilmiş mobilyayı tespit eder
  String? _findItemAtScreen(Offset screenPos, Size screenSize, List<RoomItem> items) {
    final floorHit = _camera.intersectFloorPlane(screenPos, screenSize);
    if (floorHit == null) return null;

    String? closestId;
    double minDistance = double.infinity;

    for (final item in items.where((i) => i.isPlaced)) {
      final itemPos = vm.Vector3(item.positionX, 0.0, item.positionZ);
      final dist = (floorHit - itemPos).length;
      final radius = Furniture3DFactory.getSelectionRadius(item.id);

      if (dist <= radius && dist < minDistance) {
        minDistance = dist;
        closestId = item.id;
      }
    }

    return closestId;
  }

  double? _dragPosX;
  double? _dragPosZ;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final roomItems = provider.roomItems;
    final isDark = widget.isDark;
    final isNight = widget.isNightMode;

    RoomItem? selectedItem;
    if (_selectedItemId != null) {
      try {
        selectedItem = roomItems.firstWhere((i) => i.id == _selectedItemId);
      } catch (_) {}
    }

    final ownedItems = roomItems.where((i) => i.isOwned).toList();

    // sürükleme esnasında anlık akıcı görüntüleme için geçici koordinatları uyguluyoruz
    final displayItems = (_draggingItemId != null && _dragPosX != null && _dragPosZ != null)
        ? roomItems.map((i) {
            if (i.id == _draggingItemId) {
              return i.copyWith(positionX: _dragPosX, positionZ: _dragPosZ);
            }
            return i;
          }).toList()
        : roomItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          children: [
            // 1. 3D SAHNE ÇİZİMİ VE DOKUNMA JESTLERİ
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final hitId = _findItemAtScreen(details.localPosition, screenSize, roomItems);
                  setState(() {
                    _selectedItemId = hitId;
                    if (hitId != null && _mode == RoomInteractionMode.orbitCamera) {
                      _mode = RoomInteractionMode.moveFurniture;
                    }
                  });
                },
                onPanStart: (details) {
                  final hitId = _findItemAtScreen(details.localPosition, screenSize, roomItems);
                  if (hitId != null) {
                    final it = roomItems.firstWhere((i) => i.id == hitId);
                    setState(() {
                      _selectedItemId = hitId;
                      _draggingItemId = hitId;
                      _dragPosX = it.positionX;
                      _dragPosZ = it.positionZ;
                    });
                  } else {
                    setState(() {
                      _draggingItemId = null;
                      _dragPosX = null;
                      _dragPosZ = null;
                    });
                  }
                },
                onPanUpdate: (details) {
                  if (_draggingItemId != null && _mode == RoomInteractionMode.moveFurniture) {
                    // mobilyayı parmakla zemin üzerinde kaydırma
                    final floorHit = _camera.intersectFloorPlane(details.localPosition, screenSize);
                    if (floorHit != null) {
                      double newX = floorHit.x.clamp(-3.2, 3.2);
                      double newZ = floorHit.z.clamp(-3.2, 3.2);

                      if (_snapToGrid) {
                        const step = 0.475;
                        newX = (newX / step).round() * step;
                        newZ = (newZ / step).round() * step;
                      }

                      setState(() {
                        _dragPosX = newX;
                        _dragPosZ = newZ;
                      });
                    }
                  } else {
                    // kamerayı 360 derece döndürme
                    setState(() {
                      _camera.yaw = (_camera.yaw + details.delta.dx * 0.4) % 360;
                      _camera.pitch = (_camera.pitch - details.delta.dy * 0.3)
                          .clamp(-65.0, -15.0);
                    });
                  }
                },
                onPanEnd: (_) {
                  // parmak kalkınca son koordinatları kalıcı olarak SharedPreferences'e kaydediyoruz
                  if (_draggingItemId != null && _dragPosX != null && _dragPosZ != null) {
                    provider.updateRoomItemPosition(_draggingItemId!, _dragPosX!, _dragPosZ!);
                  }
                  setState(() {
                    _draggingItemId = null;
                    _dragPosX = null;
                    _dragPosZ = null;
                  });
                },
                child: CustomPaint(
                  size: screenSize,
                  painter: RoomScene3DPainter(
                    camera: _camera,
                    roomItems: displayItems,
                    selectedItemId: _selectedItemId,
                    isDarkTheme: isDark,
                    isNightMode: isNight,
                    showGrid: _showGrid,
                  ),
                ),
              ),
            ),

            // 2. ÜST KONTROL ARAÇ ÇUBUĞU
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
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
                          _buildModeButton(
                            mode: RoomInteractionMode.moveFurniture,
                            icon: Icons.pan_tool_rounded,
                            label: 'Taşı & Düzenle',
                          ),
                          const SizedBox(width: 4),
                          _buildModeButton(
                            mode: RoomInteractionMode.orbitCamera,
                            icon: Icons.threed_rotation_rounded,
                            label: '360° Kamera',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
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
                          _buildIconAction(
                            icon: Icons.restart_alt_rounded,
                            tooltip: 'Kamerayı Sıfırla',
                            onTap: _resetCamera,
                          ),
                          _buildIconAction(
                            icon: Icons.view_in_ar_rounded,
                            tooltip: 'İzometrik Açı',
                            onTap: () => _setPresetAngle(-32, 42),
                          ),
                          _buildIconAction(
                            icon: Icons.layers_outlined,
                            tooltip: 'Kuş Bakışı',
                            onTap: () => _setPresetAngle(-60, 45),
                          ),
                          _buildIconAction(
                            icon: Icons.grid_3x3_rounded,
                            tooltip: _showGrid ? 'Izgarayı Gizle' : 'Izgarayı Göster',
                            iconColor: _showGrid ? AppColors.sageGreen : null,
                            onTap: () => setState(() => _showGrid = !_showGrid),
                          ),
                          _buildIconAction(
                            icon: Icons.straighten_rounded,
                            tooltip: _snapToGrid ? 'Izgaraya Kilitleme: Açık' : 'Izgaraya Kilitleme: Kapalı',
                            iconColor: _snapToGrid ? AppColors.sageGreen : null,
                            onTap: () => setState(() => _snapToGrid = !_snapToGrid),
                          ),
                          _buildIconAction(
                            icon: Icons.add_rounded,
                            tooltip: 'Yakınlaştır',
                            onTap: () => _zoom(0.88),
                          ),
                          _buildIconAction(
                            icon: Icons.remove_rounded,
                            tooltip: 'Uzaklaştır',
                            onTap: () => _zoom(1.14),
                          ),
                          _buildIconAction(
                            icon: isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                            tooltip: isNight ? 'Gündüz Işığı' : 'Akşam Işığı',
                            iconColor: isNight ? Colors.amberAccent : Colors.orange,
                            onTap: widget.onToggleNightMode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. SEÇİLİ MOBİLYA DÖNDÜRME VE YÖNETİM ÇUBUĞU
            if (selectedItem != null && selectedItem.isPlaced)
              Positioned(
                bottom: 80,
                left: 16,
                right: 16,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.sageGreen.withOpacity(0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.sageGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            IconData(selectedItem.iconCodePoint, fontFamily: 'MaterialIcons'),
                            size: 20,
                            color: AppColors.sageGreen,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedItem.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                                ),
                              ),
                              Text(
                                'Zeminde parmağınla serbestçe sürükle',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // 90 derece döndürme butonu
                        IconButton.filledTonal(
                          onPressed: () => provider.rotateRoomItem(selectedItem!.id),
                          icon: const Icon(Icons.rotate_90_degrees_cw_rounded, size: 18),
                          tooltip: '90° Döndür',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.sageGreen.withOpacity(0.15),
                            foregroundColor: AppColors.sageGreen,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // odadan kaldırma / depolama butonu
                        IconButton.filledTonal(
                          onPressed: () {
                            provider.setItemPlacement(selectedItem!.id, false);
                            setState(() => _selectedItemId = null);
                          },
                          icon: const Icon(Icons.archive_outlined, size: 18),
                          tooltip: 'Odadan Kaldır',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 4),

                        IconButton(
                          onPressed: () => setState(() => _selectedItemId = null),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 4. ALT HIZLI MOBİLYA ÇEKMECESİ
            Positioned(
              bottom: 8,
              left: 10,
              right: 10,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.94),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        final boughtId = await Navigator.of(context).push<String>(
                          MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
                        );
                        if (boughtId != null && mounted) {
                          setState(() {
                            _selectedItemId = boughtId;
                            _mode = RoomInteractionMode.moveFurniture;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final updatedOwned = context.read<HabitProvider>().roomItems.where((i) => i.isOwned).toList();
                            _scrollToItem(boughtId, updatedOwned);
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart_rounded, size: 16, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Mobilya Al',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const VerticalDivider(width: 12, indent: 6, endIndent: 6),

                    InkWell(
                      onTap: () {
                        if (_trayScrollController.hasClients) {
                          _trayScrollController.animateTo(
                            (_trayScrollController.offset - 150).clamp(0.0, _trayScrollController.position.maxScrollExtent),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: isDark ? Colors.white70 : AppColors.forest,
                        ),
                      ),
                    ),

                    Expanded(
                      child: ScrollConfiguration(
                        behavior: const MaterialScrollBehavior().copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad,
                            PointerDeviceKind.stylus,
                          },
                        ),
                        child: ListView.builder(
                          controller: _trayScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: ownedItems.length,
                          itemBuilder: (context, index) {
                            final item = ownedItems[index];
                            final isSelected = _selectedItemId == item.id;
                            final isPlaced = item.isPlaced;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                              child: Tooltip(
                                message: '${item.name} (${isPlaced ? 'Odaya Yerleşti' : 'Koymak için dokun'})',
                                child: InkWell(
                                  onTap: () {
                                    if (!isPlaced) {
                                      provider.setItemPlacement(item.id, true);
                                    }
                                    setState(() {
                                      _selectedItemId = item.id;
                                      _mode = RoomInteractionMode.moveFurniture;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 145, minWidth: 70),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.sageGreen.withOpacity(0.2)
                                            : (isDark ? AppColors.darkCard : AppColors.sand.withOpacity(0.25)),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.sageGreen
                                              : (isPlaced ? AppColors.sageGreen.withOpacity(0.4) : Colors.transparent),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                                            size: 16,
                                            color: isPlaced ? AppColors.sageGreen : (isDark ? Colors.white60 : Colors.black54),
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              item.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                                color: isSelected
                                                    ? AppColors.sageGreen
                                                    : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                                              ),
                                            ),
                                          ),
                                          if (isPlaced) ...[
                                            const SizedBox(width: 4),
                                            const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.sageGreen),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        if (_trayScrollController.hasClients) {
                          _trayScrollController.animateTo(
                            (_trayScrollController.offset + 150).clamp(0.0, _trayScrollController.position.maxScrollExtent),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: isDark ? Colors.white70 : AppColors.forest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. BAŞLANGIÇ YARDIM İPUCU BALONU
            if (_showHint)
              Positioned(
                bottom: 82,
                left: 16,
                right: 16,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black87 : Colors.white).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.sageGreen.withOpacity(0.5)),
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
                          const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.sageGreen),
                          const SizedBox(width: 8),
                          Text(
                            'Mobilyayı tutup zeminde sürükleyin • Döndürmek için üzerine dokunun',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => setState(() => _showHint = false),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildModeButton({
    required RoomInteractionMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _mode == mode;
    return InkWell(
      onTap: () => setState(() => _mode = mode),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sageGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : (widget.isDark ? Colors.white70 : AppColors.forest),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (widget.isDark ? Colors.white70 : AppColors.forest),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 17,
            color: iconColor ?? (widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

