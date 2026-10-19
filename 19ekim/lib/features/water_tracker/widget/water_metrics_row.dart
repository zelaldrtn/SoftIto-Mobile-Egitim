import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Kalan miktar ve hedef durumunu gösteren ikili metrik kartı.
class WaterMetricsRow extends StatelessWidget {
  const WaterMetricsRow({
    super.key,
    required this.remainingMl,
    required this.isGoalReached,
  });

  final int remainingMl;
  final bool isGoalReached;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'Kalan Miktar',
            value: isGoalReached ? 'Hedef Tamam!' : '$remainingMl ml',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: isGoalReached ? AppColors.neonLime : AppColors.neonCyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Durum',
            value: isGoalReached ? 'Harika İş! 🚀' : 'Devam Et 💪',
            icon: Icons.bolt_rounded,
            accentColor: isGoalReached ? AppColors.neonLime : AppColors.neonAmber,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
