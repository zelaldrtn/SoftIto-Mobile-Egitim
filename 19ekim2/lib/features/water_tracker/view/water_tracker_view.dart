import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_quick_actions.dart';
import '../widgets/water_chart_widget.dart';
import '../widgets/water_history_list.dart';
import '../widgets/custom_drink_dialog.dart';

/// Su ve hidrasyon takibi ana ekran görünümü.
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
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
          _buildReactiveProgress(),
          WaterQuickActions(
            onQuickAdd: (amount) => controller.addWater(amountMl: amount),
            onOpenCustomDialog: () => _openCustomDialog(context),
          ),
          _buildReactiveChart(),
          _buildReactiveHistory(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReactiveProgress() {
    return ValueListenableBuilder<int>(
      valueListenable: controller.dailyGoalWater,
      builder: (context, dailyGoal, _) {
        return ValueListenableBuilder<int>(
          valueListenable: controller.currentWater,
          builder: (context, currentWater, _) {
            return WaterProgressCard(
              currentWater: currentWater,
              dailyGoal: dailyGoal,
            );
          },
        );
      },
    );
  }

  Widget _buildReactiveChart() {
    return ValueListenableBuilder<List<DailyWaterStats>>(
      valueListenable: controller.weeklyStats,
      builder: (context, stats, _) {
        return WaterChartWidget(stats: stats);
      },
    );
  }

  Widget _buildReactiveHistory() {
    return ValueListenableBuilder<List<DrinkEntry>>(
      valueListenable: controller.history,
      builder: (context, history, _) {
        return WaterHistoryList(
          entries: history,
          onRemove: controller.removeEntry,
        );
      },
    );
  }

  void _openCustomDialog(BuildContext context) {
    CustomDrinkDialog.show(
      context,
      onAdd: (title, amount, iconCode) {
        controller.addCustomDrink(title, amount, iconCode);
      },
    );
  }
}
