import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/room_item.dart';
import '../theme/app_theme.dart';

/// Interactive Decor Life-inspired 3D Isometric Room Canvas.
/// Renders an isometric diorama cutaway room with detailed 3D furniture,
/// floorboards, wall perspectives, lighting, contact shadows, and interactive touch slots.
class IsometricRoomView extends StatelessWidget {
  final List<RoomItem> roomItems;
  final bool isDark;
  final bool showLabels;
  final bool isNightMode;
  final RoomSlotType? selectedSlot;
  final ValueChanged<RoomSlotType> onSlotSelected;

  const IsometricRoomView({
    super.key,
    required this.roomItems,
    required this.isDark,
    required this.showLabels,
    required this.isNightMode,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  RoomItem? _getPlacedItem(RoomSlotType slot) {
    try {
      return roomItems.firstWhere((i) => i.isPlaced && i.slotType == slot);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Origin of the isometric room back corner
        final cornerX = w * 0.50;
        final cornerY = h * 0.38;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Layer 1: Background Room Diorama (Walls, Floorboards, Window, Ambient Lighting)
            Positioned.fill(
              child: CustomPaint(
                painter: _IsometricRoomBackgroundPainter(
                  isDark: isDark,
                  isNight: isNightMode,
                  cornerX: cornerX,
                  cornerY: cornerY,
                ),
              ),
            ),

            // Layer 2: 3D Isometric Furniture & Interactive Slots (ordered back-to-front for proper depth sorting)
            // 1. Wall Art (Left wall, high up)
            _buildSlotWidget(
              slot: RoomSlotType.wallArt,
              placedItem: _getPlacedItem(RoomSlotType.wallArt),
              left: w * 0.14,
              top: h * 0.12,
              width: w * 0.28,
              height: h * 0.18,
            ),

            // 2. Trophy / Achievement Wall bracket or Pedestal (Back corner / left wall)
            _buildSlotWidget(
              slot: RoomSlotType.trophy,
              placedItem: _getPlacedItem(RoomSlotType.trophy),
              left: w * 0.40,
              top: h * 0.16,
              width: w * 0.22,
              height: h * 0.18,
            ),

            // 3. Bookshelf (Mounted against the right wall)
            _buildSlotWidget(
              slot: RoomSlotType.bookshelf,
              placedItem: _getPlacedItem(RoomSlotType.bookshelf),
              left: w * 0.62,
              top: h * 0.22,
              width: w * 0.30,
              height: h * 0.24,
            ),

            // 4. Floor Lamp (Left corner / behind desk)
            _buildSlotWidget(
              slot: RoomSlotType.lamp,
              placedItem: _getPlacedItem(RoomSlotType.lamp),
              left: w * 0.05,
              top: h * 0.35,
              width: w * 0.25,
              height: h * 0.32,
            ),

            // 5. Rug (Flat on the center isometric floor)
            _buildSlotWidget(
              slot: RoomSlotType.rug,
              placedItem: _getPlacedItem(RoomSlotType.rug),
              left: w * 0.22,
              top: h * 0.48,
              width: w * 0.56,
              height: h * 0.28,
              isGroundPlane: true,
            ),

            // 6. Desk (Center-left on the floor)
            _buildSlotWidget(
              slot: RoomSlotType.desk,
              placedItem: _getPlacedItem(RoomSlotType.desk),
              left: w * 0.20,
              top: h * 0.42,
              width: w * 0.38,
              height: h * 0.30,
            ),

            // 7. Reading Chair (Center-right on the floor, next to desk)
            _buildSlotWidget(
              slot: RoomSlotType.chair,
              placedItem: _getPlacedItem(RoomSlotType.chair),
              left: w * 0.54,
              top: h * 0.46,
              width: w * 0.32,
              height: h * 0.28,
            ),

            // 8. Plant (Front-left / Foreground corner)
            _buildSlotWidget(
              slot: RoomSlotType.plant,
              placedItem: _getPlacedItem(RoomSlotType.plant),
              left: w * 0.10,
              top: h * 0.60,
              width: w * 0.28,
              height: h * 0.28,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlotWidget({
    required RoomSlotType slot,
    required RoomItem? placedItem,
    required double left,
    required double top,
    required double width,
    required double height,
    bool isGroundPlane = false,
  }) {
    final isSelected = selectedSlot == slot;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSlotSelected(slot),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: AppColors.sageGreen, width: 2.2)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.sageGreen.withOpacity(0.35),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // The 3D Item Rendering or Subtle Ghost Placement Pad
              Positioned.fill(
                child: CustomPaint(
                  painter: _IsometricFurniturePainter(
                    slot: slot,
                    item: placedItem,
                    isDark: isDark,
                    isNight: isNightMode,
                    isSelected: isSelected,
                  ),
                ),
              ),

              // Slot Label Badge (toggleable or when selected)
              if (showLabels || isSelected)
                Positioned(
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface.withOpacity(0.88)
                          : Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: placedItem != null
                            ? AppColors.sageGreen.withOpacity(0.6)
                            : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          placedItem != null
                              ? IconData(placedItem.iconCodePoint, fontFamily: 'MaterialIcons')
                              : Icons.add_circle_outline_rounded,
                          size: 11,
                          color: placedItem != null
                              ? AppColors.sageGreen
                              : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 80),
                          child: Text(
                            placedItem != null ? placedItem.name : slot.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints the 3D isometric room diorama (Left wall, Right wall, Parquet floor, Window, Lighting).
class _IsometricRoomBackgroundPainter extends CustomPainter {
  final bool isDark;
  final bool isNight;
  final double cornerX;
  final double cornerY;

  _IsometricRoomBackgroundPainter({
    required this.isDark,
    required this.isNight,
    required this.cornerX,
    required this.cornerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Corner vertices
    final pBackTop = Offset(cornerX, h * 0.04);
    final pBackCorner = Offset(cornerX, cornerY);
    final pLeftTop = Offset(0, h * 0.16);
    final pLeftBottom = Offset(0, cornerY + (w * 0.50 * 0.40));
    final pRightTop = Offset(w, h * 0.16);
    final pRightBottom = Offset(w, cornerY + (w * 0.50 * 0.40));
    final pFrontBottom = Offset(cornerX, h * 0.94);

    // 1. LEFT WALL (Warm tones with panel grooves)
    final leftWallPath = Path()
      ..moveTo(pLeftTop.dx, pLeftTop.dy)
      ..lineTo(pBackTop.dx, pBackTop.dy)
      ..lineTo(pBackCorner.dx, pBackCorner.dy)
      ..lineTo(pLeftBottom.dx, pLeftBottom.dy)
      ..close();

    final leftWallPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? (isNight
                ? [const Color(0xFF1E2B25), const Color(0xFF17221D)]
                : [const Color(0xFF25372F), const Color(0xFF1D2B24)])
            : (isNight
                ? [const Color(0xFFDED8CB), const Color(0xFFCEC6B7)]
                : [const Color(0xFFF9F6EE), const Color(0xFFECE5D8)]),
      ).createShader(Rect.fromLTRB(0, 0, cornerX, pLeftBottom.dy));
    canvas.drawPath(leftWallPath, leftWallPaint);

    // Subtle Left Wall Wainscoting / Vertical Slats
    final slatPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.04)
      ..strokeWidth = 1.2;
    for (int i = 1; i <= 5; i++) {
      final t = i / 6.0;
      final x = pLeftTop.dx + (pBackTop.dx - pLeftTop.dx) * t;
      final yTop = pLeftTop.dy + (pBackTop.dy - pLeftTop.dy) * t;
      final yBottom = pLeftBottom.dy + (pBackCorner.dy - pLeftBottom.dy) * t;
      canvas.drawLine(Offset(x, yTop), Offset(x, yBottom), slatPaint);
    }

    // 2. RIGHT WALL (Slightly deeper tone for 3D lighting contrast)
    final rightWallPath = Path()
      ..moveTo(pBackTop.dx, pBackTop.dy)
      ..lineTo(pRightTop.dx, pRightTop.dy)
      ..lineTo(pRightBottom.dx, pRightBottom.dy)
      ..lineTo(pBackCorner.dx, pBackCorner.dy)
      ..close();

    final rightWallPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
        colors: isDark
            ? (isNight
                ? [const Color(0xFF19231E), const Color(0xFF131C18)]
                : [const Color(0xFF1F2F27), const Color(0xFF16231D)])
            : (isNight
                ? [const Color(0xFFD3CCC0), const Color(0xFFC3BBAE)]
                : [const Color(0xFFEFE9DC), const Color(0xFFDFD7CA)]),
      ).createShader(Rect.fromLTRB(cornerX, 0, w, pRightBottom.dy));
    canvas.drawPath(rightWallPath, rightWallPaint);

    // 3. ARCHITECTURAL ISOMETRIC WINDOW ON RIGHT WALL
    final winCenter = Offset(cornerX + (w - cornerX) * 0.46, h * 0.22);
    final winWidth = w * 0.22;
    final winHeight = h * 0.16;

    final windowRect = Rect.fromCenter(center: winCenter, width: winWidth, height: winHeight);
    final windowRRect = RRect.fromRectAndRadius(windowRect, const Radius.circular(8));

    // Outside Sky
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isNight
            ? [const Color(0xFF0F1E2E), const Color(0xFF1E354D)]
            : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
      ).createShader(windowRect);
    canvas.drawRRect(windowRRect, skyPaint);

    // Sun / Moon in window
    final celestialPaint = Paint()
      ..color = isNight ? const Color(0xFFFFF7C2) : const Color(0xFFFFD56B);
    canvas.drawCircle(
      Offset(windowRect.left + winWidth * 0.35, windowRect.top + winHeight * 0.35),
      winWidth * 0.14,
      celestialPaint,
    );

    // Window Frame & Mullions
    final winFramePaint = Paint()
      ..color = isDark ? const Color(0xFF2C3E36) : const Color(0xFFDFD5C6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawRRect(windowRRect, winFramePaint);

    // Glass panes cross
    canvas.drawLine(
      Offset(windowRect.left + winWidth / 2, windowRect.top),
      Offset(windowRect.left + winWidth / 2, windowRect.bottom),
      winFramePaint,
    );
    canvas.drawLine(
      Offset(windowRect.left, windowRect.top + winHeight / 2),
      Offset(windowRect.right, windowRect.top + winHeight / 2),
      winFramePaint,
    );

    // 4. BASEBOARD MOULDING
    final baseboardPaint = Paint()
      ..color = isDark ? const Color(0xFF2B3A33) : const Color(0xFFD6CABA)
      ..strokeWidth = 3.5;
    canvas.drawLine(pLeftBottom, pBackCorner, baseboardPaint);
    canvas.drawLine(pBackCorner, pRightBottom, baseboardPaint);

    // Center Corner seam line
    final cornerSeamPaint = Paint()
      ..color = (isDark ? Colors.black : Colors.black).withOpacity(0.12)
      ..strokeWidth = 1.5;
    canvas.drawLine(pBackTop, pBackCorner, cornerSeamPaint);

    // 5. ISOMETRIC FLOOR (Parquet floorboards with perspective)
    final floorPath = Path()
      ..moveTo(pBackCorner.dx, pBackCorner.dy)
      ..lineTo(pRightBottom.dx, pRightBottom.dy)
      ..lineTo(pFrontBottom.dx, pFrontBottom.dy)
      ..lineTo(pLeftBottom.dx, pLeftBottom.dy)
      ..close();

    final floorPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1E2822), const Color(0xFF151D19)]
            : [const Color(0xFFEBE3D3), const Color(0xFFDFD5C2)],
      ).createShader(Rect.fromLTRB(0, cornerY, w, pFrontBottom.dy));
    canvas.drawPath(floorPath, floorPaint);

    // Parquet perspective grid lines
    final plankPaint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF7A6A56)).withOpacity(isDark ? 0.05 : 0.09)
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 6; i++) {
      final t = i / 7.0;
      // Lines parallel to left wall edge
      final start1 = Offset.lerp(pBackCorner, pRightBottom, t)!;
      final end1 = Offset.lerp(pLeftBottom, pFrontBottom, t)!;
      canvas.drawLine(start1, end1, plankPaint);

      // Lines parallel to right wall edge
      final start2 = Offset.lerp(pBackCorner, pLeftBottom, t)!;
      final end2 = Offset.lerp(pRightBottom, pFrontBottom, t)!;
      canvas.drawLine(start2, end2, plankPaint);
    }

    // 6. SUNLIGHT / MOONLIGHT CONE CAST ACROSS THE FLOOR
    if (!isDark || !isNight) {
      final lightPath = Path()
        ..moveTo(winCenter.dx, winCenter.dy + winHeight * 0.4)
        ..lineTo(w * 0.88, pRightBottom.dy + 20)
        ..lineTo(w * 0.45, h * 0.70)
        ..lineTo(w * 0.35, h * 0.55)
        ..close();

      final sunlightPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.topRight,
          radius: 1.0,
          colors: [
            Colors.amber.withOpacity(0.12),
            Colors.amber.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(w * 0.3, h * 0.2, w * 0.6, h * 0.6));
      canvas.drawPath(lightPath, sunlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IsometricRoomBackgroundPainter old) {
    return old.isDark != isDark || old.isNight != isNight || old.cornerX != cornerX || old.cornerY != cornerY;
  }
}

/// Paints the 3D isometric representation of a specific furniture item or ghost slot.
class _IsometricFurniturePainter extends CustomPainter {
  final RoomSlotType slot;
  final RoomItem? item;
  final bool isDark;
  final bool isNight;
  final bool isSelected;

  _IsometricFurniturePainter({
    required this.slot,
    required this.item,
    required this.isDark,
    required this.isNight,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (item == null) {
      _paintGhostSlot(canvas, size);
      return;
    }

    switch (slot) {
      case RoomSlotType.desk:
        _paintDesk(canvas, size);
        break;
      case RoomSlotType.chair:
        _paintChair(canvas, size);
        break;
      case RoomSlotType.plant:
        _paintPlant(canvas, size);
        break;
      case RoomSlotType.bookshelf:
        _paintBookshelf(canvas, size);
        break;
      case RoomSlotType.rug:
        _paintRug(canvas, size);
        break;
      case RoomSlotType.lamp:
        _paintLamp(canvas, size);
        break;
      case RoomSlotType.wallArt:
        _paintWallArt(canvas, size);
        break;
      case RoomSlotType.trophy:
        _paintTrophy(canvas, size);
        break;
    }
  }

  /// Ghost Slot (Subtle isometric diamond placement pad with gentle glowing outline)
  void _paintGhostSlot(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.55);
    final rx = w * 0.38;
    final ry = h * 0.22;

    final padPath = Path()
      ..moveTo(center.dx, center.dy - ry)
      ..lineTo(center.dx + rx, center.dy)
      ..lineTo(center.dx, center.dy + ry)
      ..lineTo(center.dx - rx, center.dy)
      ..close();

    final padPaint = Paint()
      ..color = (isDark ? Colors.white : AppColors.forest).withOpacity(0.04)
      ..style = PaintingStyle.fill;
    canvas.drawPath(padPath, padPaint);

    final borderPaint = Paint()
      ..color = (isDark ? AppColors.darkBorder : AppColors.borderLight)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(padPath, borderPaint);

    // Subtle plus marker
    final plusPaint = Paint()
      ..color = isDark ? AppColors.darkTextMuted : AppColors.textMuted
      ..strokeWidth = 1.8;
    canvas.drawLine(Offset(center.dx - 6, center.dy), Offset(center.dx + 6, center.dy), plusPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 6), Offset(center.dx, center.dy + 6), plusPaint);
  }

  // 1. DESK (3D Wooden Rhombus Tabletop + 4 Legs + Laptop/Journal + Mug)
  void _paintDesk(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Contact drop shadow on floor
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.14);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.88), width: w * 0.74, height: h * 0.22), shadowPaint);

    // Tabletop Rhombus
    final topCenter = Offset(w * 0.50, h * 0.44);
    final topRx = w * 0.42;
    final topRy = h * 0.20;
    final thickness = 7.0;

    final topPath = Path()
      ..moveTo(topCenter.dx, topCenter.dy - topRy)
      ..lineTo(topCenter.dx + topRx, topCenter.dy)
      ..lineTo(topCenter.dx, topCenter.dy + topRy)
      ..lineTo(topCenter.dx - topRx, topCenter.dy)
      ..close();

    // Table Legs (4 wooden posts)
    final legPaint = Paint()..color = isDark ? const Color(0xFF6B4E38) : const Color(0xFF966F4E);
    final legBackPaint = Paint()..color = isDark ? const Color(0xFF4A3423) : const Color(0xFF6F5136);

    const legW = 5.0;
    final legH = h * 0.38;

    // Back legs
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(topCenter.dx - 4, topCenter.dy - topRy + 2, legW, legH), const Radius.circular(2)), legBackPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(topCenter.dx + topRx - 10, topCenter.dy, legW, legH), const Radius.circular(2)), legBackPaint);

    // Front legs
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(topCenter.dx - topRx + 6, topCenter.dy + 4, legW, legH), const Radius.circular(2)), legPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(topCenter.dx - 4, topCenter.dy + topRy + 2, legW, legH), const Radius.circular(2)), legPaint);

    // Tabletop Front Apron (Bevel)
    final frontApronPath = Path()
      ..moveTo(topCenter.dx - topRx, topCenter.dy)
      ..lineTo(topCenter.dx, topCenter.dy + topRy)
      ..lineTo(topCenter.dx, topCenter.dy + topRy + thickness)
      ..lineTo(topCenter.dx - topRx, topCenter.dy + thickness)
      ..close();
    final apronPaint = Paint()..color = isDark ? const Color(0xFF7E5B42) : const Color(0xFFA57D59);
    canvas.drawPath(frontApronPath, apronPaint);

    final rightApronPath = Path()
      ..moveTo(topCenter.dx, topCenter.dy + topRy)
      ..lineTo(topCenter.dx + topRx, topCenter.dy)
      ..lineTo(topCenter.dx + topRx, topCenter.dy + thickness)
      ..lineTo(topCenter.dx, topCenter.dy + topRy + thickness)
      ..close();
    final rightApronPaint = Paint()..color = isDark ? const Color(0xFF5D422E) : const Color(0xFF836245);
    canvas.drawPath(rightApronPath, rightApronPaint);

    // Tabletop Top Surface (Oak/Warm wood grain)
    final topSurfacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFFB58A67), const Color(0xFF8E674A)]
            : [const Color(0xFFDFBA95), const Color(0xFFC79E78)],
      ).createShader(Rect.fromCenter(center: topCenter, width: topRx * 2, height: topRy * 2));
    canvas.drawPath(topPath, topSurfacePaint);

    // Modern Laptop or Journal on Desk
    final isExecutive = item?.id.contains('executive') == true;
    if (isExecutive) {
      // Monitor & Stand
      final monitorCenter = Offset(topCenter.dx + 4, topCenter.dy - 10);
      final standPaint = Paint()..color = Colors.grey.shade600;
      canvas.drawRect(Rect.fromCenter(center: Offset(monitorCenter.dx, monitorCenter.dy + 8), width: 14, height: 4), standPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(monitorCenter.dx, monitorCenter.dy + 3), width: 3, height: 8), standPaint);

      // Glowing Screen
      final screenRect = Rect.fromCenter(center: monitorCenter, width: 28, height: 18);
      canvas.drawRRect(RRect.fromRectAndRadius(screenRect, const Radius.circular(3)), Paint()..color = Colors.blueGrey.shade800);
      canvas.drawRRect(
        RRect.fromRectAndRadius(screenRect.deflate(2), const Radius.circular(2)),
        Paint()..color = const Color(0xFF58B39B),
      );
    } else {
      // Open Minimalist Notebook
      final bookCenter = Offset(topCenter.dx - 6, topCenter.dy - 4);
      final bookPaint = Paint()..color = Colors.white.withOpacity(0.9);
      final bookPath = Path()
        ..moveTo(bookCenter.dx - 12, bookCenter.dy - 5)
        ..lineTo(bookCenter.dx, bookCenter.dy - 8)
        ..lineTo(bookCenter.dx + 12, bookCenter.dy - 5)
        ..lineTo(bookCenter.dx + 12, bookCenter.dy + 5)
        ..lineTo(bookCenter.dx, bookCenter.dy + 2)
        ..lineTo(bookCenter.dx - 12, bookCenter.dy + 5)
        ..close();
      canvas.drawPath(bookPath, bookPaint);
    }

    // Cozy Ceramic Coffee Mug
    final mugOffset = Offset(topCenter.dx + 18, topCenter.dy - 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: mugOffset, width: 7, height: 9), const Radius.circular(2)), Paint()..color = const Color(0xFFEFE6DD));
    // Steam curl
    final steamPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(mugOffset.dx, mugOffset.dy - 6), Offset(mugOffset.dx + 2, mugOffset.dy - 11), steamPaint);
  }

  // 2. CHAIR (Scandinavian Upholstered Armchair + Cushions + Angled Peg Legs)
  void _paintChair(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Contact drop shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.86), width: w * 0.65, height: h * 0.20),
      Paint()..color = Colors.black.withOpacity(0.15),
    );

    // 4 Angled Peg Wooden Legs
    final pegLegPaint = Paint()..color = isDark ? const Color(0xFF5D422E) : const Color(0xFF8B6442)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.35, h * 0.65), Offset(w * 0.25, h * 0.86), pegLegPaint);
    canvas.drawLine(Offset(w * 0.65, h * 0.65), Offset(w * 0.75, h * 0.86), pegLegPaint);
    canvas.drawLine(Offset(w * 0.45, h * 0.60), Offset(w * 0.40, h * 0.80), pegLegPaint);
    canvas.drawLine(Offset(w * 0.58, h * 0.60), Offset(w * 0.62, h * 0.80), pegLegPaint);

    // Seat Cushion (Soft curved sage green or warm cream)
    final seatCenter = Offset(w * 0.50, h * 0.58);
    final seatRect = Rect.fromCenter(center: seatCenter, width: w * 0.58, height: h * 0.24);
    final seatPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF4E6B56), const Color(0xFF3B5342)]
            : [const Color(0xFF7D9E85), const Color(0xFF65866D)],
      ).createShader(seatRect);
    canvas.drawRRect(RRect.fromRectAndRadius(seatRect, const Radius.circular(12)), seatPaint);

    // Curved Wrap-Around Backrest
    final backCenter = Offset(w * 0.50, h * 0.38);
    final backRect = Rect.fromCenter(center: backCenter, width: w * 0.60, height: h * 0.32);
    final backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF5A7A63), const Color(0xFF45614D)]
            : [const Color(0xFF8CAF95), const Color(0xFF6C8F75)],
      ).createShader(backRect);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        backRect,
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: const Radius.circular(10),
        bottomRight: const Radius.circular(10),
      ),
      backPaint,
    );

    // Cozy Sand Throw Pillow / Blanket
    final pillowCenter = Offset(w * 0.58, h * 0.52);
    final pillowRect = Rect.fromCenter(center: pillowCenter, width: w * 0.22, height: h * 0.16);
    final pillowPaint = Paint()..color = isDark ? const Color(0xFFC7A884) : const Color(0xFFE9CCA7);
    canvas.drawRRect(RRect.fromRectAndRadius(pillowRect, const Radius.circular(6)), pillowPaint);
  }

  // 3. PLANT (Succulent / Monstera / Bonsai)
  void _paintPlant(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Contact drop shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.88), width: w * 0.50, height: h * 0.18),
      Paint()..color = Colors.black.withOpacity(0.14),
    );

    final isBonsai = item?.id.contains('bonsai') == true;
    final isMonstera = item?.id.contains('monstera') == true;

    if (isBonsai) {
      // Bonsai Ceramic Tray
      final trayRect = Rect.fromCenter(center: Offset(w * 0.50, h * 0.80), width: w * 0.60, height: h * 0.14);
      canvas.drawRRect(RRect.fromRectAndRadius(trayRect, const Radius.circular(6)), Paint()..color = const Color(0xFF3E3A36));

      // Gnarled Trunk
      final trunkPaint = Paint()
        ..color = const Color(0xFF5D4433)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round;
      final trunkPath = Path()
        ..moveTo(w * 0.50, h * 0.78)
        ..quadraticBezierTo(w * 0.35, h * 0.55, w * 0.52, h * 0.44)
        ..quadraticBezierTo(w * 0.65, h * 0.36, w * 0.50, h * 0.28);
      canvas.drawPath(trunkPath, trunkPaint);

      // Lush Cloud Foliage Pads
      final foliagePaint = Paint()..color = const Color(0xFF4B7955);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.36, h * 0.48), width: 28, height: 16), foliagePaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.40), width: 32, height: 18), foliagePaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.48, h * 0.24), width: 36, height: 20), foliagePaint);
    } else if (isMonstera) {
      // Monstera Tripod Stand & Terracotta Pot
      final potRect = Rect.fromCenter(center: Offset(w * 0.50, h * 0.75), width: w * 0.36, height: h * 0.24);
      canvas.drawRRect(RRect.fromRectAndRadius(potRect, const Radius.circular(8)), Paint()..color = const Color(0xFFC7784A));

      // Large Split Monstera Leaves
      final leafPaint1 = Paint()..color = const Color(0xFF2E6343);
      final leafPaint2 = Paint()..color = const Color(0xFF437F58);

      // Central stem
      canvas.drawLine(Offset(w * 0.50, h * 0.65), Offset(w * 0.30, h * 0.30), Paint()..color = const Color(0xFF2E6343)..strokeWidth = 3);
      canvas.drawLine(Offset(w * 0.50, h * 0.65), Offset(w * 0.68, h * 0.32), Paint()..color = const Color(0xFF2E6343)..strokeWidth = 3);
      canvas.drawLine(Offset(w * 0.50, h * 0.65), Offset(w * 0.50, h * 0.22), Paint()..color = const Color(0xFF2E6343)..strokeWidth = 3);

      // Fronds
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.28, h * 0.28), width: 32, height: 42), leafPaint1);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.70, h * 0.30), width: 34, height: 44), leafPaint2);
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.18), width: 36, height: 46), leafPaint1);
    } else {
      // Succulent (Geometric faceted ceramic pot + fleshy rosette leaves)
      final potRect = Rect.fromCenter(center: Offset(w * 0.50, h * 0.74), width: w * 0.42, height: h * 0.26);
      canvas.drawRRect(RRect.fromRectAndRadius(potRect, const Radius.circular(10)), Paint()..color = isDark ? const Color(0xFFDDD4C6) : const Color(0xFFF7F3EB));

      // Dark Soil
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.64), width: w * 0.38, height: h * 0.12), Paint()..color = const Color(0xFF382D24));

      // Layered Succulent Rosette
      final leafPaint = Paint()..color = const Color(0xFF6B9978);
      final tipPaint = Paint()..color = const Color(0xFF90BA9C);

      for (int i = 0; i < 6; i++) {
        final angle = (i * math.pi / 3.0);
        final lx = w * 0.50 + math.cos(angle) * 14;
        final ly = h * 0.54 + math.sin(angle) * 9;
        canvas.drawCircle(Offset(lx, ly), 9, leafPaint);
      }
      canvas.drawCircle(Offset(w * 0.50, h * 0.52), 8, tipPaint);
      canvas.drawCircle(Offset(w * 0.50, h * 0.52), 4, Paint()..color = const Color(0xFFDF9E9B));
    }
  }

  // 4. BOOKSHELF (Floating 3D Wall Shelf or Multi-tier Bookcase)
  void _paintBookshelf(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final isLibrary = item?.id.contains('library') == true;

    if (isLibrary) {
      // Tall multi-tier isometric bookcase
      final frameRect = Rect.fromCenter(center: Offset(w * 0.50, h * 0.50), width: w * 0.85, height: h * 0.90);
      final framePaint = Paint()..color = isDark ? const Color(0xFF533B2B) : const Color(0xFF7E5B42);
      canvas.drawRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(8)), framePaint);

      // Shelves with colorful books
      final bookColors = [const Color(0xFFB85D43), const Color(0xFF557D61), const Color(0xFFE5B563), const Color(0xFF42657A)];
      for (int tier = 0; tier < 3; tier++) {
        final shelfY = frameRect.top + (tier + 1) * (frameRect.height / 3.5);
        canvas.drawLine(
          Offset(frameRect.left + 6, shelfY),
          Offset(frameRect.right - 6, shelfY),
          Paint()..color = const Color(0xFF967357)..strokeWidth = 4,
        );

        // Books standing
        for (int b = 0; b < 6; b++) {
          final bx = frameRect.left + 12 + b * 10;
          final bh = 18.0 + (b % 3) * 4;
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(bx.toDouble(), shelfY - bh, 8, bh), const Radius.circular(2)),
            Paint()..color = bookColors[(b + tier) % bookColors.length],
          );
        }
      }
    } else {
      // Floating Minimalist 3D Shelf on right wall
      final shelfY = h * 0.65;
      final shelfPath = Path()
        ..moveTo(w * 0.08, shelfY)
        ..lineTo(w * 0.88, shelfY - 14)
        ..lineTo(w * 0.94, shelfY - 8)
        ..lineTo(w * 0.14, shelfY + 6)
        ..close();

      canvas.drawPath(shelfPath, Paint()..color = isDark ? const Color(0xFF7B5D45) : const Color(0xFFAD8764));

      // Books leaning on the shelf
      final bookColors = [const Color(0xFF63856B), const Color(0xFFD97D54), const Color(0xFF547896), const Color(0xFFE2B755)];
      for (int i = 0; i < 4; i++) {
        final bx = w * 0.22 + i * 11;
        final by = shelfY - 4 - i * 2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(bx, by - 24, 9, 24), const Radius.circular(2)),
          Paint()..color = bookColors[i % bookColors.length],
        );
      }

      // Small trailing ivy pot
      canvas.drawCircle(Offset(w * 0.72, shelfY - 16), 7, Paint()..color = const Color(0xFFDED0BF));
      canvas.drawCircle(Offset(w * 0.72, shelfY - 20), 8, Paint()..color = const Color(0xFF4C7B58));
    }
  }

  // 5. RUG (Flat Isometric Rhombus Pattern with Fringes)
  void _paintRug(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.50, h * 0.50);
    final rx = w * 0.44;
    final ry = h * 0.32;

    // Contact shadow
    final shadowPath = Path()
      ..moveTo(center.dx, center.dy - ry - 2)
      ..lineTo(center.dx + rx + 3, center.dy)
      ..lineTo(center.dx, center.dy + ry + 3)
      ..lineTo(center.dx - rx - 3, center.dy)
      ..close();
    canvas.drawPath(shadowPath, Paint()..color = Colors.black.withOpacity(0.08));

    // Rug Body
    final rugPath = Path()
      ..moveTo(center.dx, center.dy - ry)
      ..lineTo(center.dx + rx, center.dy)
      ..lineTo(center.dx, center.dy + ry)
      ..lineTo(center.dx - rx, center.dy)
      ..close();

    final isSandRug = item?.id.contains('sand') == true;
    final rugPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isSandRug
            ? [const Color(0xFFEEDCC8), const Color(0xFFDEC5AA)]
            : [const Color(0xFF86A58E), const Color(0xFF6B8B73)],
      ).createShader(Rect.fromCenter(center: center, width: rx * 2, height: ry * 2));
    canvas.drawPath(rugPath, rugPaint);

    // Decorative Geometric Diamond Inlay
    final innerRx = rx * 0.55;
    final innerRy = ry * 0.55;
    final innerPath = Path()
      ..moveTo(center.dx, center.dy - innerRy)
      ..lineTo(center.dx + innerRx, center.dy)
      ..lineTo(center.dx, center.dy + innerRy)
      ..lineTo(center.dx - innerRx, center.dy)
      ..close();

    final patternPaint = Paint()
      ..color = (isSandRug ? const Color(0xFFC4A88B) : const Color(0xFFE6D6C2)).withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(innerPath, patternPaint);

    // Fringe tassels along edge
    final fringePaint = Paint()
      ..color = const Color(0xFFFAF6EE)
      ..strokeWidth = 1.8;
    for (int i = -4; i <= 4; i++) {
      final fx = center.dx + rx + (i * 2);
      final fy = center.dy + (i * 2);
      canvas.drawLine(Offset(fx, fy), Offset(fx + 4, fy + 2), fringePaint);
    }
  }

  // 6. FLOOR LAMP (Circular Brass Base + Arched Neck + Warm Cone Glow)
  void _paintLamp(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final baseX = w * 0.55;
    final baseY = h * 0.88;

    // Base
    canvas.drawOval(
      Rect.fromCenter(center: Offset(baseX, baseY), width: 22, height: 8),
      Paint()..color = const Color(0xFFBFA06B),
    );

    // Arched Pole
    final polePaint = Paint()
      ..color = const Color(0xFFD4B77C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final polePath = Path()
      ..moveTo(baseX, baseY)
      ..lineTo(baseX, h * 0.40)
      ..quadraticBezierTo(baseX, h * 0.16, baseX - 16, h * 0.18);
    canvas.drawPath(polePath, polePaint);

    // Lampshade (Trapezoid / Cone)
    final shadeCenter = Offset(baseX - 16, h * 0.25);
    final shadePath = Path()
      ..moveTo(shadeCenter.dx - 8, shadeCenter.dy - 10)
      ..lineTo(shadeCenter.dx + 8, shadeCenter.dy - 10)
      ..lineTo(shadeCenter.dx + 16, shadeCenter.dy + 12)
      ..lineTo(shadeCenter.dx - 16, shadeCenter.dy + 12)
      ..close();

    final shadePaint = Paint()..color = const Color(0xFFFFF9E8);
    canvas.drawPath(shadePath, shadePaint);

    // Warm Ambient Light Glow Cone
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 0.9,
        colors: [
          Colors.amber.withOpacity(0.35),
          Colors.amber.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCenter(center: Offset(shadeCenter.dx, shadeCenter.dy + 35), width: 90, height: 90));

    final glowConePath = Path()
      ..moveTo(shadeCenter.dx - 14, shadeCenter.dy + 12)
      ..lineTo(shadeCenter.dx + 14, shadeCenter.dy + 12)
      ..lineTo(shadeCenter.dx + 40, baseY)
      ..lineTo(shadeCenter.dx - 40, baseY)
      ..close();
    canvas.drawPath(glowConePath, glowPaint);
  }

  // 7. WALL ART (Perspective Wooden Frame + Minimalist Canvas)
  void _paintWallArt(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.50, h * 0.50);
    final isClock = item?.id.contains('clock') == true;

    if (isClock) {
      // Modern Round Wooden Clock
      canvas.drawCircle(center, 22, Paint()..color = const Color(0xFF8B6445));
      canvas.drawCircle(center, 19, Paint()..color = isDark ? const Color(0xFF1E2A23) : const Color(0xFFFAF6F0));

      // Hands
      final handPaint = Paint()
        ..color = isDark ? AppColors.darkTextPrimary : AppColors.forest
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(center, Offset(center.dx, center.dy - 10), handPaint);
      canvas.drawLine(center, Offset(center.dx + 7, center.dy + 3), handPaint);
      canvas.drawCircle(center, 2.5, handPaint);
    } else {
      // Perspective Picture Frame on Left Wall
      final framePath = Path()
        ..moveTo(w * 0.15, h * 0.22)
        ..lineTo(w * 0.85, h * 0.12)
        ..lineTo(w * 0.85, h * 0.82)
        ..lineTo(w * 0.15, h * 0.92)
        ..close();

      canvas.drawPath(framePath, Paint()..color = const Color(0xFF6F513A));

      // Canvas Art
      final canvasPath = Path()
        ..moveTo(w * 0.20, h * 0.26)
        ..lineTo(w * 0.80, h * 0.17)
        ..lineTo(w * 0.80, h * 0.77)
        ..lineTo(w * 0.20, h * 0.86)
        ..close();

      final artPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE9C496), Color(0xFF7B9E87), Color(0xFF45634E)],
        ).createShader(Rect.fromCenter(center: center, width: w * 0.7, height: h * 0.7));
      canvas.drawPath(canvasPath, artPaint);

      // Sun disc in artwork
      canvas.drawCircle(Offset(center.dx + 4, center.dy - 8), 8, Paint()..color = const Color(0xFFFFF2D4));
    }
  }

  // 8. TROPHY (Marble Pedestal + Shining Golden Wings / Emblem)
  void _paintTrophy(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final baseX = w * 0.50;
    final baseY = h * 0.80;

    // Marble Pedestal
    final pedestalRect = Rect.fromCenter(center: Offset(baseX, baseY), width: 34, height: 16);
    canvas.drawRRect(RRect.fromRectAndRadius(pedestalRect, const Radius.circular(3)), Paint()..color = const Color(0xFFEFECE6));

    // Golden Cup Body
    final cupCenter = Offset(baseX, baseY - 22);
    final cupPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFEA79), Color(0xFFE5B32A), Color(0xFFBF8810)],
      ).createShader(Rect.fromCenter(center: cupCenter, width: 30, height: 30));

    // Pedestal stem
    canvas.drawRect(Rect.fromCenter(center: Offset(baseX, baseY - 8), width: 8, height: 6), cupPaint);

    // Cup goblet
    final cupPath = Path()
      ..moveTo(cupCenter.dx - 12, cupCenter.dy - 12)
      ..lineTo(cupCenter.dx + 12, cupCenter.dy - 12)
      ..quadraticBezierTo(cupCenter.dx + 10, cupCenter.dy + 8, cupCenter.dx, cupCenter.dy + 10)
      ..quadraticBezierTo(cupCenter.dx - 10, cupCenter.dy + 8, cupCenter.dx - 12, cupCenter.dy - 12)
      ..close();
    canvas.drawPath(cupPath, cupPaint);

    // Handles
    final handlePaint = Paint()
      ..color = const Color(0xFFD49E17)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawArc(Rect.fromLTWH(cupCenter.dx - 18, cupCenter.dy - 10, 8, 12), math.pi * 0.5, math.pi, false, handlePaint);
    canvas.drawArc(Rect.fromLTWH(cupCenter.dx + 10, cupCenter.dy - 10, 8, 12), -math.pi * 0.5, math.pi, false, handlePaint);

    // Sparkle star highlight
    final starPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cupCenter.dx + 4, cupCenter.dy - 5), 2.2, starPaint);
  }

  @override
  bool shouldRepaint(covariant _IsometricFurniturePainter old) {
    return old.slot != slot || old.item?.id != item?.id || old.isDark != isDark || old.isNight != isNight || old.isSelected != isSelected;
  }
}
