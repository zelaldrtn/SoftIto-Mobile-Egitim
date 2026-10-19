import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterProgressCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterProgressCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.currentWater,
          builder: (context, current, _) {
            final double ratio =
                (current / WaterTrackerController.dailyGoalMl).clamp(0.0, 1.0);
            final percent = (ratio * 100).toInt();

            return Column(
              children: [
                Text('Günlük Su Hedefi', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '$current / ${WaterTrackerController.dailyGoalMl} ml',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 14,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                const SizedBox(height: 8),
                Text('%$percent tamamlandı', style: theme.textTheme.bodyMedium),
              ],
            );
          },
        ),
      ),
    );
  }
}
