import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_session.dart';

/// Kaydedilen antrenman seansları listesi.
class WorkoutSessionList extends StatelessWidget {
  const WorkoutSessionList({
    super.key,
    required this.sessions,
    required this.onRemoveSession,
  });

  final List<WorkoutSession> sessions;
  final void Function(String id) onRemoveSession;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _EmptyWorkoutState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bugünkü Antrenmanlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = sessions[index];
            return _WorkoutSessionTile(
              session: item,
              onDelete: () => onRemoveSession(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyWorkoutState extends StatelessWidget {
  const _EmptyWorkoutState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.fitness_center_outlined,
              color: AppColors.textMuted, size: 36),
          SizedBox(height: 8),
          Text(
            'Henüz kaydedilmiş egzersiz yok',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSessionTile extends StatelessWidget {
  const _WorkoutSessionTile({
    required this.session,
    required this.onDelete,
  });

  final WorkoutSession session;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${session.timestamp.hour.toString().padLeft(2, '0')}:${session.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neonLime.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded,
                color: AppColors.neonLime, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${session.durationMinutes} dk • ${session.caloriesBurned} kcal • $timeStr',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMuted, size: 18),
            onPressed: onDelete,
            tooltip: 'Antrenmanı Sil',
          ),
        ],
      ),
    );
  }
}
