import 'package:flutter/material.dart';
import '../models/car_model.dart';

/// Yatay kaydırılabilir araç kategori seçici.
class CarCategorySelector extends StatelessWidget {
  const CarCategorySelector({
    required this.selectedCategoryNotifier,
    super.key,
  });

  final ValueNotifier<CarCategory> selectedCategoryNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CarCategory>(
      valueListenable: selectedCategoryNotifier,
      builder: (BuildContext context, CarCategory current, _) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: CarCategory.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              final CarCategory cat = CarCategory.values[index];
              final bool isSelected = cat == current;
              return ChoiceChip(
                label: Text(cat.label),
                selected: isSelected,
                onSelected: (_) => selectedCategoryNotifier.value = cat,
              );
            },
          ),
        );
      },
    );
  }
}
