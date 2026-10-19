import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_session.dart';
import 'custom_workout_input_sheet.dart';

/// Hızlı antrenman ekleme şablonları ve özel egzersiz butonu.
class WorkoutQuickAddButtons extends StatelessWidget {
  const WorkoutQuickAddButtons({
    super.key,
    required this.onAddWorkout,
  });

  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    WorkoutIntensity intensity,
  }) onAddWorkout;

  static const List<_WorkoutTemplate> _templates = [
    _WorkoutTemplate(
      title: 'Fitness & Ağırlık',
      duration: 45,
      calories: 320,
      icon: Icons.fitness_center_rounded,
      intensity: WorkoutIntensity.high,
    ),
    _WorkoutTemplate(
      title: 'Kardiyo & Koşu',
      duration: 30,
      calories: 280,
      icon: Icons.directions_run_rounded,
      intensity: WorkoutIntensity.high,
    ),
    _WorkoutTemplate(
      title: 'HIIT Seansı',
      duration: 20,
      calories: 220,
      icon: Icons.bolt_rounded,
      intensity: WorkoutIntensity.high,
    ),
    _WorkoutTemplate(
      title: 'Tempolu Yürüyüş',
      duration: 35,
      calories: 150,
      icon: Icons.directions_walk_rounded,
      intensity: WorkoutIntensity.low,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Antrenman Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildGrid(),
        const SizedBox(height: 10),
        _buildCustomButton(context),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.1,
      children: _templates.map((tpl) {
        return _TemplateCard(
          template: tpl,
          onTap: () => onAddWorkout(
            title: tpl.title,
            durationMinutes: tpl.duration,
            caloriesBurned: tpl.calories,
            intensity: tpl.intensity,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.obsidianBorder),
          backgroundColor: AppColors.obsidianCard,
          foregroundColor: AppColors.neonLime,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        onPressed: () => CustomWorkoutInputSheet.show(
          context,
          onAddWorkout: ({
            required String title,
            required int durationMinutes,
            required int caloriesBurned,
            WorkoutIntensity intensity = WorkoutIntensity.medium,
          }) {
            onAddWorkout(
              title: title,
              durationMinutes: durationMinutes,
              caloriesBurned: caloriesBurned,
              intensity: intensity,
            );
            _showFeedback(context, '$title kaydedildi ($durationMinutes dk, $caloriesBurned kcal) 🔥');
          },
        ),
        icon: const Icon(Icons.add_task_rounded, size: 18),
        label: const Text(
          '+ Özel Egzersiz Ekle (Süre & Kalori)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  static void _showFeedback(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.obsidianSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.neonLime, width: 0.8),
        ),
      ),
    );
  }
}

class _WorkoutTemplate {
  const _WorkoutTemplate({
    required this.title,
    required this.duration,
    required this.calories,
    required this.icon,
    required this.intensity,
  });

  final String title;
  final int duration;
  final int calories;
  final IconData icon;
  final WorkoutIntensity intensity;
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

  final _WorkoutTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: InkWell(
        onTap: () {
          onTap();
          WorkoutQuickAddButtons._showFeedback(
            context,
            '${template.title} kaydedildi (${template.duration} dk, ${template.calories} kcal) 🔥',
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        splashColor: AppColors.neonLime.withValues(alpha: 0.25),
        highlightColor: AppColors.neonLime.withValues(alpha: 0.15),
        hoverColor: AppColors.neonLime.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(template.icon, color: AppColors.neonLime, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      template.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${template.duration} dk • ${template.calories} kcal',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
