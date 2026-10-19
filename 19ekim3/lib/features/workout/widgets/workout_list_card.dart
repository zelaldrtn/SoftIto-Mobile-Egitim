import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';

class WorkoutListCard extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutListCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bugünkü Antrenmanlar',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<WorkoutModel>>(
              valueListenable: controller.workouts,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('Henüz antrenman kaydı yok.')),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length > 5 ? 5 : list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.bolt),
                      title: Text(item.title),
                      subtitle: Text('${item.durationMinutes} dakika'),
                      trailing: Text(
                        '-${item.caloriesBurned} kcal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
