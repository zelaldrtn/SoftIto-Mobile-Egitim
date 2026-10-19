import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_quick_actions.dart';
import '../widgets/water_chart_widget.dart';
import '../widgets/water_history_card.dart';
import '../widgets/custom_beverage_sheet.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({super.key, required this.controller});

  void _openCustomBeverageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CustomBeverageSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WaterProgressCard(controller: controller),
          const SizedBox(height: 16),
          WaterQuickActions(
            controller: controller,
            onCustomBeverageTap: () => _openCustomBeverageSheet(context),
          ),
          const SizedBox(height: 16),
          WaterChartWidget(controller: controller),
          const SizedBox(height: 16),
          WaterHistoryCard(controller: controller),
        ],
      ),
    );
  }
}
