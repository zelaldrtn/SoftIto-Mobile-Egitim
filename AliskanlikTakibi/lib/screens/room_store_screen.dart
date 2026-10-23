import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_provider.dart';
import '../models/room_item.dart';
import '../theme/app_theme.dart';

class RoomStoreScreen extends StatefulWidget {
  const RoomStoreScreen({super.key});

  @override
  State<RoomStoreScreen> createState() => _RoomStoreScreenState();
}

class _RoomStoreScreenState extends State<RoomStoreScreen> {
  RoomSlotType? _filterSlot;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allItems = provider.roomItems;
    final filteredItems = _filterSlot == null
        ? allItems
        : allItems.where((i) => i.slotType == _filterSlot).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Mağazası & Katalog'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.sand.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars_rounded,
                  size: 18,
                  color: isDark ? AppColors.sand : AppColors.forest,
                ),
                const SizedBox(width: 4),
                Text(
                  '${provider.pointsBalance} P',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.sand : AppColors.forest,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Chips
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  ChoiceChip(
                    label: const Text('Tüm Eşyalar'),
                    selected: _filterSlot == null,
                    selectedColor: AppColors.sageGreen,
                    labelStyle: TextStyle(
                      color: _filterSlot == null
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                      fontWeight: _filterSlot == null ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (val) => setState(() => _filterSlot = null),
                  ),
                  const SizedBox(width: 8),
                  ...RoomSlotType.values.map((slot) {
                    final isSelected = _filterSlot == slot;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(
                          slot.defaultIcon,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.sand : AppColors.forest),
                        ),
                        label: Text(slot.label),
                        selected: isSelected,
                        selectedColor: AppColors.sageGreen,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (val) => setState(() => _filterSlot = isSelected ? null : slot),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Divider(height: 1),

            // Item Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isOwned = item.isOwned;
                  final isStreakMilestone = item.streakRequirement > 0;
                  final meetsStreak = provider.currentGlobalStreak >= item.streakRequirement;
                  final canAfford = provider.pointsBalance >= item.price;

                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isOwned
                            ? AppColors.sageGreen.withOpacity(0.5)
                            : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                        width: isOwned ? 1.5 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Icon & Badge
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.cream.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                                      size: 32,
                                      color: isOwned
                                          ? AppColors.sageGreen
                                          : (isDark ? AppColors.sand : AppColors.forest),
                                    ),
                                  ),
                                ),
                                if (isOwned)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.sageGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Sahipsin',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Item Name
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Slot Category label
                          Text(
                            item.slotType.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Action Button / Price
                          if (isOwned)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  provider.toggleItemPlacement(item.id);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  side: BorderSide(
                                    color: item.isPlaced ? AppColors.sageGreen : AppColors.borderLight,
                                  ),
                                ),
                                child: Text(
                                  item.isPlaced ? 'Odaya Yerleşti ✓' : 'Odaya Yerleştir',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: item.isPlaced ? AppColors.sageGreen : null,
                                  ),
                                ),
                              ),
                            )
                          else if (isStreakMilestone)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: meetsStreak
                                    ? () => _purchaseItem(context, provider, item)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: meetsStreak ? AppColors.sageGreen : Colors.grey,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(
                                  meetsStreak ? 'Ödülü Aç 🎁' : '${item.streakRequirement} Gün Streak 🔒',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: canAfford
                                    ? () => _purchaseItem(context, provider, item)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canAfford ? AppColors.sageGreen : Colors.grey.shade400,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(
                                  '${item.price} Puan Satın Al',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _purchaseItem(BuildContext context, HabitProvider provider, RoomItem item) {
    final success = provider.buyRoomItem(item.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} başarıyla satın alındı ve odana eklendi! ✨'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Satın alma başarısız oldu. Yetersiz puan veya kilitli eşya.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
