import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Haftalık yakılan kalori ve antrenman süresini gösteren çift çubuklu grafik.
class WorkoutWeeklyChart extends StatelessWidget {
  const WorkoutWeeklyChart({
    super.key,
    required this.todayCalories,
    required this.targetCalories,
  });

  final int todayCalories;
  final int targetCalories;

  static const List<String> _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  List<int> get _weeklyCalories {
    return [450, 620, 380, 500, 710, 480, todayCalories];
  }

  @override
  Widget build(BuildContext context) {
    final maxCal = targetCalories > 0 ? targetCalories.toDouble() : 600.0;
    final weekly = _weeklyCalories;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildBars(weekly, maxCal),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.insights_rounded, color: AppColors.neonLime, size: 20),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Haftalık Kalori Grafiği',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonAmber.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: const Text(
            'Hedef: 600 kcal',
            style: TextStyle(
              color: AppColors.neonAmber,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBars(List<int> weekly, double maxCal) {
    return SizedBox(
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(weekly.length, (index) {
          final isToday = index == weekly.length - 1;
          final cal = weekly[index];
          final ratio = (cal / maxCal).clamp(0.08, 1.0);

          return _WorkoutBarColumn(
            dayName: _days[index],
            calories: cal,
            heightRatio: ratio,
            isToday: isToday,
          );
        }),
      ),
    );
  }
}

class _WorkoutBarColumn extends StatelessWidget {
  const _WorkoutBarColumn({
    required this.dayName,
    required this.calories,
    required this.heightRatio,
    required this.isToday,
  });

  final String dayName;
  final int calories;
  final double heightRatio;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final barColor = isToday ? AppColors.neonAmber : AppColors.obsidianBorder;
    final textColor = isToday ? AppColors.neonAmber : AppColors.textSecondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$calories',
          style: TextStyle(
            color: textColor,
            fontSize: 9,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 22,
          height: 80 * heightRatio,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: AppColors.neonAmber.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dayName,
          style: TextStyle(
            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
