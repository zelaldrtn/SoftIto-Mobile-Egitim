import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';

/// Girişim projelerini popülerlik, yeni eklenen veya desteğe göre sıralayan menü butonu.
class SortFilterMenu extends StatelessWidget {
  static const List<String> sortOptions = <String>[
    'Popüler',
    'Yeni Eklenen',
    'En Çok Desteklenen',
  ];

  const SortFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectsController controller = ProjectsController.instance;

    return ValueListenableBuilder<String>(
      valueListenable: controller.selectedSortNotifier,
      builder: (BuildContext context, String currentSort, Widget? child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.sort_rounded),
          tooltip: 'Sırala ($currentSort)',
          onSelected: controller.setSort,
          itemBuilder: (BuildContext context) {
            return sortOptions.map((String option) {
              final bool isSelected = option == currentSort;
              return PopupMenuItem<String>(
                value: option,
                child: Row(
                  children: <Widget>[
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 18,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(option),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
