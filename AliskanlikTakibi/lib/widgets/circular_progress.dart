import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DailyProgressCard extends StatelessWidget {
  final double progress;
  final int completedCount;
  final int totalCount;
  final int todayPoints;
  final int streakDays;

  const DailyProgressCard({
    super.key,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
    required this.todayPoints,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 82,
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: CircularProgressIndicator(
                    value: totalCount == 0 ? 0.0 : progress,
                    strokeWidth: 7,
                    backgroundColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.cream,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '%$percent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalCount == 0
                      ? 'Bugün için plan yok'
                      : completedCount == totalCount
                          ? 'Harika! Günün tamamlandı 🎉'
                          : '$completedCount / $totalCount Alışkanlık',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalCount == 0
                      ? 'Yeni bir alışkanlık ekle ve başla!'
                      : completedCount == totalCount
                          ? 'İstikrarın odayı güzelleştiriyor.'
                          : '${totalCount - completedCount} alışkanlık daha seni bekliyor.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    // Today Points Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.sand.withOpacity(0.18)
                            : AppColors.sand.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              size: 14,
                              color: isDark ? AppColors.sand : AppColors.forest,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+$todayPoints Puan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.sand : AppColors.forest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Streak Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.sageGreen.withOpacity(0.22)
                            : AppColors.sageGreen.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded,
                              size: 14,
                              color: isDark ? const Color(0xFF88CCA0) : AppColors.forest,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streakDays Gün Streak',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF88CCA0) : AppColors.forest,
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
        ],
      ),
    );
  }
}
