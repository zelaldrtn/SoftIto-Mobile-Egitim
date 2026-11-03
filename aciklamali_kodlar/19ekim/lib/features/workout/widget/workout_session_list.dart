import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_session.dart';

/// Kaydedilen antrenman seansları listesi.
// StatelessWidget: günün kaydedilen egzersizlerini liste halinde sergileyen sabit widget
class WorkoutSessionList extends StatelessWidget {
  const WorkoutSessionList({
    super.key,
    required this.sessions,
    required this.onRemoveSession,
  });

  final List<WorkoutSession> sessions;
  // sil butonuna basıldığında id ileten callback
  final void Function(String id) onRemoveSession;

  @override
  Widget build(BuildContext context) {
    // seans listesi boşsa kullanıcıya boş durum ekranı gösterir
    if (sessions.isEmpty) {
      return const _EmptyWorkoutState();
    }

    // Column: başlık ve egzersiz listesini dikeyde sıralar
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
        // SizedBox: başlık ile liste arasına 10 birim boşluk bırakır
        const SizedBox(height: 10),
        // ListView.separated: aralarına boşluk koyarak performanslı liste oluşturur
        ListView.separated(
          // shrinkWrap: listenin sadece elemanları kadar dikey alan kaplamasını sağlar
          shrinkWrap: true,
          // NeverScrollableScrollPhysics: ana sayfa kaydırmasıyla çakışmayı önlemek için listenin kendi kaydırmasını kapatır
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          // separatorBuilder: her seans arasına 8 birim dikey boşluk ekler
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

// kayıtlı antrenman olmadığında gösterilen boş durum kartı
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

// tek bir antrenman seansının kart satırı
class _WorkoutSessionTile extends StatelessWidget {
  const _WorkoutSessionTile({
    required this.session,
    required this.onDelete,
  });

  final WorkoutSession session;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // padLeft(2, '0'): saat ve dakikanın tek haneli ise başına 0 eklenmesini sağlar (örn: 08:30)
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
          // Expanded: metinlerin satırdaki kalan tüm genişliği kaplamasını sağlar
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
          // antrenmanı silme butonu
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

