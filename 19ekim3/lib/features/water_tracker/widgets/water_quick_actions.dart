import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterQuickActions extends StatelessWidget {
  final WaterTrackerController controller;
  final VoidCallback onCustomBeverageTap;

  const WaterQuickActions({
    super.key,
    required this.controller,
    required this.onCustomBeverageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWater(250),
            icon: const Icon(Icons.local_drink),
            label: const Text('+250 ml'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWater(500),
            icon: const Icon(Icons.water_drop),
            label: const Text('+500 ml'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Özel İçecek (300ml vb.)',
          onPressed: onCustomBeverageTap,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          tooltip: 'Sıfırla',
          onPressed: controller.resetWater,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
