import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Haftalık yakılan kaloriyi neon yeşil sütun grafiği ile gösteren bileşen.
class WorkoutChartWidget extends StatelessWidget {
  final List<DailyWorkoutStats> stats;

  const WorkoutChartWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(isDark),
            const SizedBox(height: 16),
            _buildBarChartArea(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildChartHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'HAFTALIK KALORİ GRAFİĞİ',
            style: TextStyle(
              color: AppColors.textPrimaryFor(isDark),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          'Hedef: 600 kcal / gün',
          style: TextStyle(
            color: AppColors.secondaryFor(isDark),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChartArea(bool isDark) {
    final maxCal = stats.fold<int>(600, (max, e) => e.calories > max ? e.calories : max);
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: stats.map((item) => _buildSingleBar(item, maxCal, isDark)).toList(),
      ),
    );
  }

  Widget _buildSingleBar(DailyWorkoutStats item, int maxCal, bool isDark) {
    final ratio = (item.calories / maxCal).clamp(0.05, 1.0);
    final isTargetMet = item.calories >= item.targetCalories;
    final secondary = AppColors.secondaryFor(isDark);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${item.calories}',
            style: TextStyle(
              color: AppColors.textMutedFor(isDark),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: ratio,
                child: Container(
                  width: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: LinearGradient(
                      colors: isTargetMet
                          ? [secondary, isDark ? AppColors.neonLime : const Color(0xFF34D399)]
                          : [const Color(0xFF00B0FF), const Color(0xFF0077B6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: isTargetMet && isDark
                        ? [
                            BoxShadow(
                              color: secondary.withAlpha(80),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.dayName,
            style: TextStyle(
              color: isTargetMet ? secondary : AppColors.textSecondaryFor(isDark),
              fontSize: 12,
              fontWeight: isTargetMet ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
