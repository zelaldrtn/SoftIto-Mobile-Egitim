import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../widgets/workout_summary_card.dart';
import '../widgets/workout_quick_actions.dart';
import '../widgets/workout_chart_widget.dart';
import '../widgets/workout_list_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkoutSummaryCard(controller: controller),
          const SizedBox(height: 16),
          WorkoutQuickActions(controller: controller),
          const SizedBox(height: 16),
          WorkoutChartWidget(controller: controller),
          const SizedBox(height: 16),
          WorkoutListCard(controller: controller),
        ],
      ),
    );
  }
}
