import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final int streakDays;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onTogglePause;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.streakDays,
    required this.onToggle,
    required this.onEdit,
    required this.onTogglePause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDark ? AppColors.darkCard.withOpacity(0.6) : AppColors.sageGreen.withOpacity(0.08))
            : (isDark ? AppColors.darkCard : AppColors.surfaceCard),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.sageGreen.withOpacity(0.4)
              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: habit.isPaused ? null : onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Custom Checkbox
                GestureDetector(
                  onTap: habit.isPaused ? null : onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.sageGreen
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.sageGreen
                            : (isDark ? AppColors.darkTextMuted : AppColors.borderLight),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),

                // Category / Custom Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: habit.category.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                    size: 22,
                    color: habit.category.color,
                  ),
                ),
                const SizedBox(width: 14),

                // Name, Goal, Points, Streak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              habit.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                color: isCompleted
                                    ? (isDark ? AppColors.darkTextMuted : AppColors.textMuted)
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                              ),
                            ),
                          ),
                          if (habit.isPaused)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Duraklatıldı',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                          children: [
                            if (habit.goal.isNotEmpty) ...[
                              TextSpan(text: habit.goal),
                              TextSpan(
                                text: ' • ',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                                ),
                              ),
                            ],
                            TextSpan(text: habit.frequencyType.label),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          // Points tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.sand.withOpacity(0.18)
                                  : AppColors.sand.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${habit.points} Puan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.sand : AppColors.forest,
                              ),
                            ),
                          ),
                          // Streak tag
                          if (streakDays > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.sageGreen.withOpacity(0.22)
                                    : AppColors.sageGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 12,
                                    color: isDark ? const Color(0xFF88CCA0) : AppColors.forest,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '$streakDays gün',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? const Color(0xFF88CCA0) : AppColors.forest,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'pause') onTogglePause();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 10),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'pause',
                      child: Row(
                        children: [
                          Icon(
                            habit.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(habit.isPaused ? 'Devam Ettir' : 'Duraklat'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.errorRed),
                          SizedBox(width: 10),
                          Text('Sil', style: TextStyle(color: AppColors.errorRed)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
