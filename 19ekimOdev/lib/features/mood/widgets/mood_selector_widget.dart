import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/mood_controller.dart';
import '../models/mood_item.dart';

/// Ruh hâli seçimini sunan sevimli yatay / ızgara seçici widget.
class MoodSelectorWidget extends StatelessWidget {
  final MoodController moodController;
  final List<MoodItem> moods;

  const MoodSelectorWidget({
    super.key,
    required this.moodController,
    this.moods = MoodItem.defaultMoods,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: moodController.selectedMoodNotifier,
      builder: (context, selectedEmoji, _) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: moods.map((mood) {
            final isSelected = selectedEmoji == mood.emoji;
            return _MoodChip(
              mood: mood,
              isSelected: isSelected,
              onTap: () => moodController.toggleMood(mood.emoji),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MoodChip extends StatelessWidget {
  final MoodItem mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodChip({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isSelected
        ? (isDark ? AppColors.darkPrimaryContainer : AppColors.lightPrimaryContainer)
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant);

    final borderColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.darkOnPrimaryContainer : AppColors.lightOnPrimaryContainer)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
