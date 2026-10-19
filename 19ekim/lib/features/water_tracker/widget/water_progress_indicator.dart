import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Neon efektli dairesel su ilerleme göstergesi.
class WaterProgressIndicator extends StatelessWidget {
  const WaterProgressIndicator({
    super.key,
    required this.currentMl,
    required this.targetMl,
    required this.progress,
    required this.percentage,
  });

  final int currentMl;
  final int targetMl;
  final double progress;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildGlowBackground(),
          _buildProgressRing(),
          _buildCenterText(context),
        ],
      ),
    );
  }

  Widget _buildGlowBackground() {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: 190,
      height: 190,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 14,
        backgroundColor: AppColors.obsidianBorder,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildCenterText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop_rounded, color: AppColors.neonCyan, size: 32),
        const SizedBox(height: 6),
        Text(
          '$currentMl ml',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hedef: $targetMl ml (%$percentage)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
