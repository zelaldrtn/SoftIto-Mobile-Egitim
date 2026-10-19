import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Son 7 günün su tüketimini neon sütun grafiği ile görselleştiren widget.
class WaterChartWidget extends StatelessWidget {
  final List<DailyWaterStats> stats;

  const WaterChartWidget({
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
            'HAFTALIK SU GRAFİĞİ',
            style: TextStyle(
              color: AppColors.textPrimaryFor(isDark),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          'Hedef: 2.5L / gün',
          style: TextStyle(
            color: AppColors.primaryFor(isDark),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChartArea(bool isDark) {
    final maxMl = stats.fold<int>(2500, (max, e) => e.totalMl > max ? e.totalMl : max);
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: stats.map((item) => _buildSingleBar(item, maxMl, isDark)).toList(),
      ),
    );
  }

  Widget _buildSingleBar(DailyWaterStats item, int maxMl, bool isDark) {
    final ratio = (item.totalMl / maxMl).clamp(0.05, 1.0);
    final isTargetMet = item.totalMl >= item.goalMl;
    final primary = AppColors.primaryFor(isDark);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${(item.totalMl / 1000).toStringAsFixed(1)}L',
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
                          ? [primary, const Color(0xFF0077B6)]
                          : [const Color(0xFF0096C7), const Color(0xFF023E8A)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: isTargetMet && isDark
                        ? [
                            BoxShadow(
                              color: primary.withAlpha(80),
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
              color: isTargetMet ? primary : AppColors.textSecondaryFor(isDark),
              fontSize: 12,
              fontWeight: isTargetMet ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
