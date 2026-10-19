import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: controller.totalCalories,
              builder: (context, cal, _) => _SummaryItem(
                label: 'Yakılan Kalori',
                value: '$cal kcal',
                color: theme.colorScheme.tertiary,
              ),
            ),
            Container(width: 1, height: 48, color: theme.dividerColor),
            ValueListenableBuilder<int>(
              valueListenable: controller.totalMinutes,
              builder: (context, min, _) => _SummaryItem(
                label: 'Egzersiz Süresi',
                value: '$min dk',
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
