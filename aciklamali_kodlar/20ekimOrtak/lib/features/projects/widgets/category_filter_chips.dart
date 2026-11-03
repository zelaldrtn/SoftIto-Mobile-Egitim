import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';

// girişim projelerini kategorilere göre filtreleyen dinamik yatay liste bileşeni
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    // singleton controller örneğine ulaşıyoruz
    final ProjectsController controller = ProjectsController.instance;

    // kategori listesindeki değişiklikleri dinliyoruz
    return ValueListenableBuilder<List<String>>(
      valueListenable: controller.categoriesNotifier,
      builder: (BuildContext context, List<String> categories, Widget? child) {
        // seçili olan kategoriyi dinliyoruz, değiştiğinde çipler yeniden çizilir
        return ValueListenableBuilder<String>(
          valueListenable: controller.selectedCategoryNotifier,
          builder: (BuildContext context, String selectedCategory, _) {
            // çiplerin yüksekliğini sabitlemek için SizedBox kullanıyoruz
            return SizedBox(
              height: 44,
              // aralarında boşluk olan yatay liste
              child: ListView.separated(
                // sadece yatay eksende (sağ ve soldan) 16 birim padding
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // listenin sağa-sola doğru kaymasını sağlıyoruz
                scrollDirection: Axis.horizontal,
                // +1 eklememizin sebebi en sona 'Kategori Ekle' butonu koyacak olmamız
                itemCount: categories.length + 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  // en son elemandaysak kategori ekleme butonunu çiziyoruz
                  if (index == categories.length) {
                    return _AddCategoryChip(onTap: () => _showAddDialog(context));
                  }
                  final String category = categories[index];
                  // ChoiceChip tekli seçim yapılabilen etiket widget'ıdır
                  return ChoiceChip(
                    label: Text(category),
                    // seçili kategori bu çipe eşitse aktif olarak vurgulanır
                    selected: selectedCategory == category,
                    // seçildiğinde sol tarafta tik ikonu çıkmasın istiyoruz
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

  // yeni kategori ekleme diyaloğunu açan yardımcı metot
  void _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => const _AddCategoryDialog(),
    );
  }
}

// tıklandığında yeni kategori oluşturmayı tetikleyen buton çipi
class _AddCategoryChip extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ActionChip tıklama aksiyonu için tasarlanmış çip türüdür
    return ActionChip(
      avatar: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Kategori Ekle'),
      onPressed: onTap,
    );
  }
}

// kullanıcıdan kategori adı girmesini isteyen diyalog penceresi
class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog();

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  // metin kutusundaki veriyi kontrol eden controller
  final TextEditingController _categoryCtrl = TextEditingController();

  // bellek sızıntısını önlemek için widget kapandığında controller'ı temizliyoruz
  @override
  void dispose() {
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AlertDialog kullanıcıya sunulan onay ve girdi kutusudur
    return AlertDialog(
      title: const Text('Yeni Kategori Belirle'),
      content: TextField(
        controller: _categoryCtrl,
        // diyalog açılır açılmaz klavyenin otomatik açılmasını sağlar
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Örn: Biyoteknoloji, Oyun...',
          labelText: 'Kategori Adı',
        ),
      ),
      actions: <Widget>[
        TextButton(
          // diyalog penceresini kapatır
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

  // yeni kategoriyi controller'a ekleyip diyaloğu kapatıyoruz
  void _submit() {
    final String text = _categoryCtrl.text.trim();
    if (text.isNotEmpty) {
      ProjectsController.instance.addCategory(text);
      ProjectsController.instance.setCategory(text);
      Navigator.of(context).pop();
    }
  }
}

