import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_provider.dart';
import '../models/room_item.dart';
import '../theme/app_theme.dart';
import '../widgets/isometric_room_view.dart';
import 'room_store_screen.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomSlotType? _selectedSlot;
  bool _showLabels = false;
  bool _isNightMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Default night ambiance to match dark mode initially
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _isNightMode = isDark;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ownedItems = provider.roomItems.where((i) => i.isOwned).toList();

    final RoomItem? selectedItem = _selectedSlot != null
        ? provider.roomItems.cast<RoomItem?>().firstWhere(
              (i) => i!.isPlaced && i.slotType == _selectedSlot,
              orElse: () => null,
            )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odam & Yaşam Alanı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_rounded),
            tooltip: 'Mağaza',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Puan Bakiyesi ve Eşya Sayacı (Responsive - asla taşma yapmaz)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Points Balance Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.sand.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            size: 18,
                            color: isDark ? AppColors.sand : AppColors.forest,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${provider.pointsBalance} Puan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.sand : AppColors.forest,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Controls & Store/Inventory Action Buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Labels toggle
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _showLabels = !_showLabels),
                          icon: Icon(
                            _showLabels ? Icons.label_rounded : Icons.label_off_rounded,
                            size: 16,
                          ),
                          tooltip: _showLabels ? 'Etiketleri Gizle' : 'Etiketleri Göster',
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(7),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Light / Night ambiance toggle
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _isNightMode = !_isNightMode),
                          icon: Icon(
                            _isNightMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                            size: 16,
                          ),
                          tooltip: _isNightMode ? 'Gündüz Işığı' : 'Akşam Işığı',
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(7),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Inventory Button
                        OutlinedButton.icon(
                          onPressed: () => _showInventorySheet(context, provider),
                          icon: const Icon(Icons.inventory_2_outlined, size: 15),
                          label: Text('Envanter (${ownedItems.length})'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Store Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
                            );
                          },
                          icon: const Icon(Icons.storefront_rounded, size: 15),
                          label: const Text('Mağaza'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),

            // 3D Isometric Decor Life Room Canvas
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: IsometricRoomView(
                    roomItems: provider.roomItems,
                    isDark: isDark,
                    isNightMode: _isNightMode,
                    showLabels: _showLabels,
                    selectedSlot: _selectedSlot,
                    onSlotSelected: (slot) => _onSlotSelected(context, provider, slot),
                  ),
                ),
              ),
            ),

            // Interactive Bottom Slot Info Card or Motivation Footer
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _selectedSlot != null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.sageGreen, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Her tamamlanan alışkanlık puan kazandırır, odan senin istikrarınla güzelleşir.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              secondChild: _selectedSlot != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.sageGreen.withOpacity(0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Slot / Item Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.sageGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                selectedItem != null
                                    ? IconData(selectedItem.iconCodePoint, fontFamily: 'MaterialIcons')
                                    : _selectedSlot!.defaultIcon,
                                color: AppColors.sageGreen,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name & Description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedItem != null ? selectedItem.name : _selectedSlot!.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    selectedItem != null
                                        ? selectedItem.description
                                        : 'Bu köşe boş. Bir eşya yerleştirerek odayı zenginleştir.',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Action buttons
                            if (selectedItem != null) ...[
                              IconButton(
                                icon: const Icon(Icons.sync_rounded, size: 20),
                                tooltip: 'Eşyayı Değiştir',
                                onPressed: () {
                                  final ownedForSlot = provider.roomItems
                                      .where((i) => i.isOwned && i.slotType == _selectedSlot)
                                      .toList();
                                  _showSlotPickerSheet(context, provider, _selectedSlot!, ownedForSlot);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline_rounded, size: 20, color: AppColors.errorRed),
                                tooltip: 'Odayı Boşalt',
                                onPressed: () {
                                  provider.toggleItemPlacement(selectedItem.id);
                                  setState(() => _selectedSlot = null);
                                },
                              ),
                            ] else ...[
                              ElevatedButton(
                                onPressed: () {
                                  final ownedForSlot = provider.roomItems
                                      .where((i) => i.isOwned && i.slotType == _selectedSlot)
                                      .toList();
                                  if (ownedForSlot.isEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
                                    );
                                  } else {
                                    _showSlotPickerSheet(context, provider, _selectedSlot!, ownedForSlot);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text('Yerleştir'),
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () => setState(() => _selectedSlot = null),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _onSlotSelected(BuildContext context, HabitProvider provider, RoomSlotType slotType) {
    setState(() {
      if (_selectedSlot == slotType) {
        _selectedSlot = null; // deselect
      } else {
        _selectedSlot = slotType;
      }
    });

    final ownedForSlot = provider.roomItems.where((i) => i.isOwned && i.slotType == slotType).toList();

    if (ownedForSlot.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(slotType.label),
          content: const Text(
            'Bu köşe için henüz bir eşyaya sahip değilsin. Oda Mağazasını ziyaret edip puanlarınla eşya edinebilirsin.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Kapat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
                );
              },
              child: const Text('Mağazaya Git'),
            ),
          ],
        ),
      );
    }
  }

  void _showSlotPickerSheet(
    BuildContext context,
    HabitProvider provider,
    RoomSlotType slotType,
    List<RoomItem> items,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${slotType.label} Seçimi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RoomStoreScreen()),
                        );
                      },
                      icon: const Icon(Icons.storefront_rounded, size: 16),
                      label: const Text('Mağaza'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Henüz bu slot için satın alınmış eşya yok.',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...items.map((item) {
                    return ListTile(
                      leading: Icon(
                        IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                        color: AppColors.sageGreen,
                      ),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                        ),
                      ),
                      subtitle: Text(
                        item.description,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      trailing: item.isPlaced
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.sageGreen)
                          : Text(
                              'Yerleştir',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.sand : AppColors.forest,
                              ),
                            ),
                      onTap: () {
                        provider.toggleItemPlacement(item.id);
                        setState(() => _selectedSlot = slotType);
                        Navigator.of(ctx).pop();
                      },
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInventorySheet(BuildContext context, HabitProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ownedItems = provider.roomItems.where((i) => i.isOwned).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Envanterim',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                      ),
                    ),
                    Text(
                      '${ownedItems.length} Eşya',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (ownedItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Henüz sahip olduğun bir eşya bulunmuyor.',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: ownedItems.length,
                      itemBuilder: (context, index) {
                        final item = ownedItems[index];
                        return ListTile(
                          leading: Icon(
                            IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                            color: item.isPlaced
                                ? AppColors.sageGreen
                                : (isDark ? AppColors.sand : AppColors.forest),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                            ),
                          ),
                          subtitle: Text(
                            item.slotType.label,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                          trailing: Switch(
                            value: item.isPlaced,
                            activeThumbColor: AppColors.sageGreen,
                            onChanged: (val) {
                              provider.toggleItemPlacement(item.id);
                              setState(() {});
                              Navigator.of(ctx).pop();
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
