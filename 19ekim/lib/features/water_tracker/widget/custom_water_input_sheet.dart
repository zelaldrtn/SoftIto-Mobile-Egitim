import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Kullanıcının dilediği içecek türünü ve miktarını (örn: 300ml) girebileceği alt sayfa (bottom sheet).
class CustomWaterInputSheet extends StatefulWidget {
  const CustomWaterInputSheet({
    super.key,
    required this.onAddWater,
  });

  final void Function(int amount, String label) onAddWater;

  static Future<void> show(
    BuildContext context, {
    required void Function(int amount, String label) onAddWater,
  }) {
    return showModalBottomSheet<void>(
      context: context,
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
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '300');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _amountController.text.trim();
    final amount = int.tryParse(text);
    if (amount != null && amount > 0) {
      widget.onAddWater(amount, _selectedBeverage);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
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

  Widget _buildBeverageSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _beverageOptions.map((bev) {
        final isSelected = bev == _selectedBeverage;
        return ChoiceChip(
          label: Text(bev),
          selected: isSelected,
          onSelected: (val) {
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

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            onPressed: () =>
                setState(() => _amountController.text = amount.toString()),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
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
