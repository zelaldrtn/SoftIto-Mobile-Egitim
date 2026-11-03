import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Kullanıcının dilediği içecek türünü ve miktarını (örn: 300ml) girebileceği alt sayfa (bottom sheet).
// StatefulWidget: seçilen içecek türü ve girilen miktarla durumu güncellenen form widget'ı
class CustomWaterInputSheet extends StatefulWidget {
  const CustomWaterInputSheet({
    super.key,
    required this.onAddWater,
  });

  // miktar ve içecek adı girildiğinde çalışan callback fonksiyonu
  final void Function(int amount, String label) onAddWater;

  // bu modal sayfayı tek satırda açmayı sağlayan statik yardımcı fonksiyon
  static Future<void> show(
    BuildContext context, {
    required void Function(int amount, String label) onAddWater,
  }) {
    // showModalBottomSheet: ekranın altından yukarı doğru açılan modal pencere açar
    return showModalBottomSheet<void>(
      context: context,
      // isScrollControlled: klavye açıldığında formun yukarı kayabilmesini sağlar
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.obsidianBorder),
      ),
      builder: (ctx) => CustomWaterInputSheet(onAddWater: onAddWater),
    );
  }

  @override
  State<CustomWaterInputSheet> createState() => _CustomWaterInputSheetState();
}

class _CustomWaterInputSheetState extends State<CustomWaterInputSheet> {
  // late: controller'ın initState içinde değer alacağını belirtir
  late final TextEditingController _amountController;
  String _selectedBeverage = 'Su';

  static const List<String> _beverageOptions = [
    'Su',
    'Kahve',
    'Yeşil Çay',
    'Maden Suyu',
    'Elektrolit',
    'Protein Shake',
  ];

  @override
  // initState: sayfa açıldığında başlangıç değerini (300 ml) atar
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '300');
  }

  @override
  // dispose: sayfa kapandığında controller'ı temizleyerek bellek sızıntısını önler
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // kaydet butonuna basıldığında çalışan onaylama metodu
  void _submit() {
    final text = _amountController.text.trim();
    // int.tryParse: girilen metni tamsayıya çevirir, geçersizse null döner
    final amount = int.tryParse(text);
    if (amount != null && amount > 0) {
      // widget. üzerinden üst sınıftaki onAddWater callback'ine veriyi iletir
      widget.onAddWater(amount, _selectedBeverage);
      // Navigator.of(context).pop(): modal pencereyi kapatır
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // viewInsetsOf: klavye açıldığında klavyenin kapladığı dikey piksel yüksekliğini verir
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // EdgeInsets.fromLTRB: sol, üst, sağ ve alt kenarlardan özel boşluk verir (alttaki klavye boşluğu dahil)
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      // Column: altındaki widget'ları dikey sırada dizer
      child: Column(
        // MainAxisSize.min: dikeyde tüm ekranı kaplamak yerine sadece içeriği kadar alan kaplar
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          // SizedBox: dikeyde 12 birim boşluk bırakır
          const SizedBox(height: 12),
          _buildHeader(),
          const SizedBox(height: 16),
          _buildBeverageSelector(),
          const SizedBox(height: 16),
          _buildAmountField(),
          const SizedBox(height: 14),
          _buildQuickPresets(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // modal pencerenin üstündeki küçük tutamaç çizgisi
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.obsidianBorder,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Özel İçecek & Miktar Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Dilediğiniz miktarı (ml) ve içecek cinsini belirleyin.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // içecek seçeneklerini yatayda sıralayıp sığmayanları alt satıra geçiren alan
  Widget _buildBeverageSelector() {
    // Wrap: elemanlar satıra sığmadığında otomatik olarak bir alt satıra kaydırır
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _beverageOptions.map((bev) {
        final isSelected = bev == _selectedBeverage;
        // ChoiceChip: tekli seçim imkanı veren hazır etiket butonu
        return ChoiceChip(
          label: Text(bev),
          selected: isSelected,
          onSelected: (val) {
            // setState: seçilen yeni içeceği duruma kaydedip ekranı yeniler
            if (val) setState(() => _selectedBeverage = bev);
          },
          selectedColor: AppColors.neonCyan.withValues(alpha: 0.2),
          backgroundColor: AppColors.obsidianSurface,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.neonCyan : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.neonCyan : AppColors.obsidianBorder,
          ),
        );
      }).toList(),
    );
  }

  // miktar giriş kutusu
  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      // FilteringTextInputFormatter.digitsOnly: kutuya harf yazılmasını engeller, sadece rakam kabul eder
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // autofocus: sayfa açılır açılmaz klavyenin otomatik açılmasını sağlar
      autofocus: true,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        labelText: 'Tüketilen Miktar',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        suffixText: 'ml',
        suffixStyle: const TextStyle(
          color: AppColors.neonCyan,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: AppColors.obsidianSurface,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.obsidianBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.neonCyan, width: 2),
        ),
      ),
      onSubmitted: (_) => _submit(),
    );
  }

  // hızlı miktar seçimi butonları (150, 300, 450, 600 ml)
  Widget _buildQuickPresets() {
    const presets = [150, 300, 450, 600];
    return Row(
      children: presets.map((amount) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text('$amount ml'),
            backgroundColor: AppColors.obsidianSurface,
            labelStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            side: const BorderSide(color: AppColors.obsidianBorder),
            // basılan hızlı miktarı doğrudan metin kutusuna yazar
            onPressed: () =>
                setState(() => _amountController.text = amount.toString()),
          ),
        );
      }).toList(),
    );
  }

  // form onay butonu
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      // FilledButton.icon: zemin rengi dolu ve ikonlu onay butonu
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.obsidianBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        onPressed: _submit,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Kaydı Ekle',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

