import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Kalori ve süre hedeflerini gösteren özet kartı.
class WorkoutSummaryCard extends StatelessWidget {
  const WorkoutSummaryCard({
    super.key,
    required this.totalCalories,
    required this.targetCalories,
    required this.totalMinutes,
    required this.targetMinutes,
    required this.calorieProgress,
    required this.durationProgress,
  });

  final int totalCalories;
  final int targetCalories;
  final int totalMinutes;
  final int targetMinutes;
  final double calorieProgress;
  final double durationProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.obsidianBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonLime.withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _TargetProgressRow(
            label: 'Yakılan Kalori',
            valueText: '$totalCalories / $targetCalories kcal',
            progress: calorieProgress,
            accentColor: AppColors.neonAmber,
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 18),
          _TargetProgressRow(
            label: 'Aktif Egzersiz',
            valueText: '$totalMinutes / $targetMinutes dk',
            progress: durationProgress,
            accentColor: AppColors.neonLime,
            icon: Icons.timer_outlined,
          ),
        ],
      ),
    );
  }
}

class _TargetProgressRow extends StatelessWidget {
  const _TargetProgressRow({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.accentColor,
    required this.icon,
  });

  final String label;
  final String valueText;
  final double progress;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              valueText,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: AppColors.obsidianBorder,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
      ],
    );
  }
}
