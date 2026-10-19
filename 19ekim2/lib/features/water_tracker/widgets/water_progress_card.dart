import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Günlük su tüketim oranını ve neon dairesel göstergeyi sunan kart.
class WaterProgressCard extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;

  const WaterProgressCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  double get _percentage =>
      dailyGoal > 0 ? (currentWater / dailyGoal).clamp(0.0, 1.0) : 0.0;

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
            _buildInfoColumn(isDark),
            _buildCircularIndicator(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(bool isDark) {
    final percentInt = (_percentage * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'GÜNLÜK HİDRASYON',
          style: TextStyle(
            color: AppColors.primaryFor(isDark),
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
              '$currentWater',
              style: TextStyle(
                color: AppColors.textPrimaryFor(isDark),
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ $dailyGoal ml',
              style: TextStyle(
                color: AppColors.textSecondaryFor(isDark),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Hedefe %$percentInt ulaşıldı',
          style: TextStyle(
            color: AppColors.textMutedFor(isDark),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(bool isDark) {
    final primary = AppColors.primaryFor(isDark);
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
            valueColor: AlwaysStoppedAnimation<Color>(primary),
            strokeCap: StrokeCap.round,
          ),
          Icon(
            Icons.water_drop_rounded,
            color: primary,
            size: 32,
          ),
        ],
      ),
    );
  }
}
