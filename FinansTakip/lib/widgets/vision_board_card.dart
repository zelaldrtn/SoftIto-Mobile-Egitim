import 'package:flutter/material.dart';
import '../models/saving_goal_model.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class VisionBoardCard extends StatelessWidget {
  final SavingGoalModel goal;
  final VoidCallback? onDepositTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onDeleteTap;

  const VisionBoardCard({
    super.key,
    required this.goal,
    this.onDepositTap,
    this.onCardTap,
    this.onDeleteTap,
  });

  IconData _getIconData(String iconKey) {
    switch (iconKey.toLowerCase()) {
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'car':
        return Icons.directions_car_filled_rounded;
      case 'house':
        return Icons.home_rounded;
      case 'emergency':
        return Icons.shield_rounded;
      case 'wedding':
        return Icons.favorite_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Color _getAccentColor() {
    switch (goal.iconKey.toLowerCase()) {
      case 'travel':
        return AppColors.dreamyYellow;
      case 'laptop':
        return AppColors.dreamyLilac;
      case 'emergency':
        return AppColors.forestLight;
      default:
        return AppColors.forestPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getAccentColor();
    final percent = (goal.progressRatio * 100).toStringAsFixed(0);

    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.creamCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Satır: İkon, Başlık, Öncelik & Silme/Aksiyon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIconData(goal.iconKey),
                    color: isDark ? Colors.white : AppColors.forestPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.dreamyYellowLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 12, color: Color(0xFF946200)),
                                const SizedBox(width: 2),
                                Text(
                                  'Öncelik ${goal.priority}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF946200),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (goal.quote != null && goal.quote!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          goal.quote!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tutar İstatistikleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biriken / Hedef',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          CurrencyFormatter.format(goal.savedAmount, showDecimals: false),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : AppColors.forestPrimary,
                          ),
                        ),
                        Text(
                          ' / ${CurrencyFormatter.format(goal.targetAmount, showDecimals: false)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '%$percent',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.forestMint : AppColors.forestPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // İlerleme Çubuğu (Progress Bar)
            Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardAlt
                        : AppColors.warmBorder.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: goal.progressRatio,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.forestPrimary, accentColor],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Alt Kısım: Kalan Tutar & Hızlı Para Ekleme Butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.isCompleted
                      ? '🎉 Hedefe Ulaşıldı!'
                      : 'Kalan: ${CurrencyFormatter.format(goal.remainingAmount, showDecimals: false)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: goal.isCompleted
                        ? AppColors.forestPrimary
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
                if (!goal.isCompleted && onDepositTap != null)
                  InkWell(
                    onTap: onDepositTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.forestPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Birikim Ekle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
