import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';

/// Girişim projelerini kategorilere göre filtreleyen dinamik yatay liste bileşeni.
/// Kullanıcının kendi belirlediği kategorileri girmesine ve filtrelemesine imkan tanır.
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectsController controller = ProjectsController.instance;

    return ValueListenableBuilder<List<String>>(
      valueListenable: controller.categoriesNotifier,
      builder: (BuildContext context, List<String> categories, Widget? child) {
        return ValueListenableBuilder<String>(
          valueListenable: controller.selectedCategoryNotifier,
          builder: (BuildContext context, String selectedCategory, _) {
            return SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  if (index == categories.length) {
                    return _AddCategoryChip(onTap: () => _showAddDialog(context));
                  }
                  final String category = categories[index];
                  return ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      if (selected) controller.setCategory(category);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => const _AddCategoryDialog(),
    );
  }
}

class _AddCategoryChip extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Kategori Ekle'),
      onPressed: onTap,
    );
  }
}

class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog();

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final TextEditingController _categoryCtrl = TextEditingController();

  @override
  void dispose() {
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Kategori Belirle'),
      content: TextField(
        controller: _categoryCtrl,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Örn: Biyoteknoloji, Oyun...',
          labelText: 'Kategori Adı',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Ekle'),
        ),
      ],
    );
  }

  void _submit() {
    final String text = _categoryCtrl.text.trim();
    if (text.isNotEmpty) {
      ProjectsController.instance.addCategory(text);
      ProjectsController.instance.setCategory(text);
      Navigator.of(context).pop();
    }
  }
}
