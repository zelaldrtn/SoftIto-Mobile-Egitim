import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/water_history_list.dart';
import '../widget/water_metrics_row.dart';
import '../widget/water_progress_indicator.dart';
import '../widget/water_quick_add_buttons.dart';
import '../widget/water_weekly_chart.dart';

/// Su takip ana ekran görünümü.
class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _WaterTrackerBody(controller: controller),
    );
  }
}

class _WaterTrackerBody extends StatelessWidget {
  const _WaterTrackerBody({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        WaterProgressIndicator(
          currentMl: controller.currentMl,
          targetMl: controller.dailyTargetMl,
          progress: controller.progressRatio,
          percentage: controller.percentage,
        ),
        const SizedBox(height: 24),
        WaterMetricsRow(
          remainingMl: controller.remainingMl,
          isGoalReached: controller.isGoalReached,
        ),
        const SizedBox(height: 24),
        WaterQuickAddButtons(
          onAddWater: (amount, label) => controller.addWater(amount, label: label),
        ),
        const SizedBox(height: 24),
        WaterWeeklyChart(
          todayMl: controller.currentMl,
          dailyTargetMl: controller.dailyTargetMl,
        ),
        const SizedBox(height: 28),
        WaterHistoryList(
          logs: controller.logs,
          onRemoveLog: controller.removeLog,
        ),
      ],
    );
  }
}
