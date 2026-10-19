import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Bugün tamamlanan antrenmanların listelendiği geçmiş bileşeni.
class WorkoutHistoryList extends StatelessWidget {
  final List<WorkoutEntry> entries;
  final ValueChanged<String> onRemove;

  const WorkoutHistoryList({
    super.key,
    required this.entries,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyState(context.isDarkMode);
    }

    final isDark = context.isDarkMode;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            Divider(color: AppColors.cardBorderFor(isDark), height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (_, index) => _buildItem(entries[index], isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'BUGÜNKÜ ANTRENMANLAR',
          style: TextStyle(
            color: AppColors.textPrimaryFor(isDark),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        Icon(
          Icons.bolt_rounded,
          color: AppColors.secondaryFor(isDark),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Bugün henüz antrenman kaydı yok.',
            style: TextStyle(
              color: AppColors.textSecondaryFor(isDark),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(WorkoutEntry entry, bool isDark) {
    final secondary = AppColors.secondaryFor(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedFor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorderFor(isDark)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.workoutGlassFor(isDark),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: TextStyle(
                    color: AppColors.textPrimaryFor(isDark),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${entry.durationMinutes} dk • ${entry.intensity}',
                  style: TextStyle(
                    color: AppColors.textMutedFor(isDark),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${entry.caloriesBurned} kcal',
            style: TextStyle(
              color: isDark ? AppColors.neonOrange : AppColors.lightOrange,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          IconButton(
            onPressed: () => onRemove(entry.id),
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textMutedFor(isDark),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
