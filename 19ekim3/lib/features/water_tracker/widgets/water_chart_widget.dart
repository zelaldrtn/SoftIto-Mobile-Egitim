import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterChartWidget extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterChartWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Haftalık Su Grafiği (ml)',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ValueListenableBuilder<List<int>>(
                valueListenable: controller.weeklyIntakeData,
                builder: (context, data, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(data.length, (index) {
                      final val = data[index];
                      final heightRatio = (val / 2500).clamp(0.08, 1.0);
                      return _WeeklyBar(
                        label: days[index % days.length],
                        height: 70 * heightRatio,
                        amount: val,
                        isToday: index == data.length - 1,
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBar extends StatelessWidget {
  final String label;
  final double height;
  final int amount;
  final bool isToday;

  const _WeeklyBar({
    required this.label,
    required this.height,
    required this.amount,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = isToday ? theme.colorScheme.primary : theme.colorScheme.secondary.withValues(alpha: 0.6);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${(amount / 1000).toStringAsFixed(1)}L',
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 9)),
        const SizedBox(height: 4),
        Container(
          width: 18,
          height: height,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? theme.colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}
