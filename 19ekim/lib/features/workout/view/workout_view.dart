import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../widget/workout_quick_add_buttons.dart';
import '../widget/workout_session_list.dart';
import '../widget/workout_summary_card.dart';
import '../widget/workout_weekly_chart.dart';

/// Egzersiz ve kalori takip ekranı görünümü.
class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
    required this.controller,
  });

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _WorkoutBody(controller: controller),
    );
  }
}

class _WorkoutBody extends StatelessWidget {
  const _WorkoutBody({required this.controller});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        WorkoutSummaryCard(
          totalCalories: controller.totalCalories,
          targetCalories: controller.dailyCalorieTarget,
          totalMinutes: controller.totalMinutes,
          targetMinutes: controller.dailyDurationTargetMinutes,
          calorieProgress: controller.calorieProgress,
          durationProgress: controller.durationProgress,
        ),
        const SizedBox(height: 24),
        WorkoutQuickAddButtons(
          onAddWorkout: ({
            required title,
            required durationMinutes,
            required caloriesBurned,
            intensity = const Object() as dynamic,
          }) {
            controller.addSession(
              title: title,
              durationMinutes: durationMinutes,
              caloriesBurned: caloriesBurned,
            );
          },
        ),
        const SizedBox(height: 24),
        WorkoutWeeklyChart(
          todayCalories: controller.totalCalories,
          targetCalories: controller.dailyCalorieTarget,
        ),
        const SizedBox(height: 28),
        WorkoutSessionList(
          sessions: controller.sessions,
          onRemoveSession: controller.removeSession,
        ),
      ],
    );
  }
}
