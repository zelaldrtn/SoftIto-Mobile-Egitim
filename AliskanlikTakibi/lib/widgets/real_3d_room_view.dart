import 'package:flutter/material.dart';
import '../models/room_item.dart';
import 'game3d/room_game_view.dart';

/// Geriye dönük uyumluluk sarmalayıcısı.
/// Yeni yüksek performanslı, sürüklenebilir 3D Oda Motoru (Room3DGameView)'na yönlendirir.
class Real3DRoomView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Room3DGameView(
      isDark: isDark,
      isNightMode: isNightMode,
      onToggleNightMode: onToggleNightMode ?? () {},
    );
  }
}
