import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_summary_card.dart';
import '../widgets/workout_chart_widget.dart';
import '../widgets/workout_history_list.dart';
import '../widgets/add_workout_dialog.dart';

/// Egzersiz ve kalori takibi ana ekran görünümü.
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildReactiveSummary(),
          _buildAddButton(context),
          _buildReactiveChart(),
          _buildReactiveHistory(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReactiveSummary() {
    return ValueListenableBuilder<int>(
      valueListenable: controller.dailyCalorieGoal,
      builder: (context, goal, _) {
        return ValueListenableBuilder<int>(
          valueListenable: controller.todayCalories,
          builder: (context, calories, _) {
            return ValueListenableBuilder<int>(
              valueListenable: controller.todayMinutes,
              builder: (context, minutes, _) {
                return WorkoutSummaryCard(
                  todayCalories: calories,
                  todayMinutes: minutes,
                  dailyGoal: goal,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = AppColors.secondaryFor(isDark);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          foregroundColor: secondary,
          side: BorderSide(color: secondary, width: 1.5),
        ),
        onPressed: () => _openAddDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Egzersiz / Antrenman Ekle'),
      ),
    );
  }

  Widget _buildReactiveChart() {
    return ValueListenableBuilder<List<DailyWorkoutStats>>(
      valueListenable: controller.weeklyStats,
      builder: (context, stats, _) {
        return WorkoutChartWidget(stats: stats);
      },
    );
  }

  Widget _buildReactiveHistory() {
    return ValueListenableBuilder<List<WorkoutEntry>>(
      valueListenable: controller.workouts,
      builder: (context, entries, _) {
        return WorkoutHistoryList(
          entries: entries,
          onRemove: controller.removeWorkout,
        );
      },
    );
  }

  void _openAddDialog(BuildContext context) {
    AddWorkoutDialog.show(
      context,
      onAdd: (title, duration, calories, intensity) {
        controller.addWorkout(title, duration, calories, intensity);
      },
    );
  }
}
