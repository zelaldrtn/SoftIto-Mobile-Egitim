import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_intake_model.dart';

class WaterHistoryCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterHistoryCard({super.key, required this.controller});

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
            Text('Bugünkü İçecek Kayıtları',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<WaterIntakeModel>>(
              valueListenable: controller.intakeHistory,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('Henüz içecek kaydı yok.')),
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
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(item.beverageName),
                      trailing: Text(
                        '+${item.amountMl} ml',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
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
