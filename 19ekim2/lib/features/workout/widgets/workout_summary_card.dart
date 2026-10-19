import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Günlük egzersiz süresi, yakılan kalori ve hedef yüzdesini sunan özet kartı.
class WorkoutSummaryCard extends StatelessWidget {
  final int todayCalories;
  final int todayMinutes;
  final int dailyGoal;

  const WorkoutSummaryCard({
    super.key,
    required this.todayCalories,
    required this.todayMinutes,
    required this.dailyGoal,
  });

  double get _percentage =>
      dailyGoal > 0 ? (todayCalories / dailyGoal).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppColors.cardGradientFor(isDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCalorieColumn(isDark),
            _buildCircularProgress(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieColumn(bool isDark) {
    final secondary = AppColors.secondaryFor(isDark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'YAKILAN ENERJİ & SÜRE',
          style: TextStyle(
            color: secondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$todayCalories',
              style: TextStyle(
                color: AppColors.textPrimaryFor(isDark),
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ $dailyGoal kcal',
              style: TextStyle(
                color: AppColors.textSecondaryFor(isDark),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.timer_outlined, color: secondary, size: 16),
            const SizedBox(width: 4),
            Text(
              'Aktif Süre: $todayMinutes dakika',
              style: TextStyle(
                color: AppColors.textSecondaryFor(isDark),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularProgress(bool isDark) {
    final secondary = AppColors.secondaryFor(isDark);
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _percentage,
            strokeWidth: 8,
            backgroundColor: AppColors.cardBorderFor(isDark),
            valueColor: AlwaysStoppedAnimation<Color>(secondary),
            strokeCap: StrokeCap.round,
          ),
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.neonOrange,
            size: 32,
          ),
        ],
      ),
    );
  }
}
