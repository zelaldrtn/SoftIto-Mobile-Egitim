import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';

class WorkoutQuickActions extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutQuickActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWorkout('Koşu & Kardiyo', 30, 280),
            icon: const Icon(Icons.directions_run),
            label: const Text('Koşu (30dk)'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWorkout('Ağırlık Antrenmanı', 45, 320),
            icon: const Icon(Icons.fitness_center),
            label: const Text('Ağırlık (45dk)'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Sıfırla',
          onPressed: controller.resetWorkouts,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
