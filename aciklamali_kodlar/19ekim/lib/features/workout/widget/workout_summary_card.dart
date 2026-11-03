import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Kalori ve süre hedeflerini gösteren özet kartı.
// StatelessWidget: yakılan kalori ve egzersiz süresi ilerleme çubuklarını gösteren sabit widget
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
    // Container: özet kartının gölgeli ve yuvarlak kenarlı koyu kutusunu oluşturur
    return Container(
      // EdgeInsets: kutunun iç kenarlarından 18 birim boşluk bırakır
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.obsidianBorder),
        // BoxShadow: kartın altına hafif yeşil neon ışıma efekti verir
        boxShadow: [
          BoxShadow(
            color: AppColors.neonLime.withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      // Column: kalori ve süre ilerleme satırlarını alt alta dizer
      child: Column(
        children: [
          _TargetProgressRow(
            label: 'Yakılan Kalori',
            valueText: '$totalCalories / $targetCalories kcal',
            progress: calorieProgress,
            accentColor: AppColors.neonAmber,
            icon: Icons.local_fire_department_rounded,
          ),
          // SizedBox: iki ilerleme satırı arasına 18 birim dikey boşluk bırakır
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

// tek bir hedefin etiketini ve yatay ilerleme çubuğunu çizen yardımcı widget
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
          // MainAxisAlignment.spaceBetween: başlığı sola, değer metnini en sağa yaslar
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
        // ClipRRect: altındaki LinearProgressIndicator'ın köşelerini yuvarlak kırpar
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          // LinearProgressIndicator: hedefin tamamlanma oranını yatay çubuk olarak gösterir
          child: LinearProgressIndicator(
            value: progress,
            // minHeight: çubuğun dikey kalınlığı
            minHeight: 10,
            backgroundColor: AppColors.obsidianBorder,
            // AlwaysStoppedAnimation: çubuğun dolgu rengini sabitler
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
      ],
    );
  }
}

