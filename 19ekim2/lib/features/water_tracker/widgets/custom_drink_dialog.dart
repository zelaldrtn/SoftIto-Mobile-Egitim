import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Kullanıcının özel ml (örneğin 300 ml) ve içecek türü girmesini sağlayan diyalog.
class CustomDrinkDialog extends StatefulWidget {
  final void Function(String title, int amountMl, int iconCode) onAdd;

  const CustomDrinkDialog({
    super.key,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required void Function(String title, int amountMl, int iconCode) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CustomDrinkDialog(onAdd: onAdd),
    );
  }

  @override
  State<CustomDrinkDialog> createState() => _CustomDrinkDialogState();
}

class _CustomDrinkDialogState extends State<CustomDrinkDialog> {
  final TextEditingController _amountController = TextEditingController(text: '300');
  final TextEditingController _titleController = TextEditingController(text: 'Su');
  final int _selectedIconCode = 0xe356; // Icons.local_drink_rounded

  final List<int> _quickPresets = const [150, 250, 300, 350, 500, 750];
  final List<String> _drinkPresets = const [
    'Su',
    'Maden Suyu',
    'Yeşil Çay',
    'Kahve',
    'Protein Shake',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          _buildPresetChips(isDark),
          const SizedBox(height: 16),
          _buildAmountField(isDark),
          const SizedBox(height: 14),
          _buildDrinkTypeChips(isDark),
          const SizedBox(height: 20),
          _buildSubmitButton(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Özel İçecek / Su Ekle',
          style: TextStyle(
            color: AppColors.textPrimaryFor(isDark),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: AppColors.textSecondaryFor(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChips(bool isDark) {
    final primary = AppColors.primaryFor(isDark);
    return Wrap(
      spacing: 8,
      children: _quickPresets.map((amount) {
        final isSelected = _amountController.text == amount.toString();
        return ChoiceChip(
          label: Text('$amount ml'),
          selected: isSelected,
          selectedColor: primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimaryFor(isDark),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          backgroundColor: AppColors.surfaceElevatedFor(isDark),
          side: BorderSide(
            color: isSelected ? primary : AppColors.cardBorderFor(isDark),
          ),
          onSelected: (_) {
            setState(() {
              _amountController.text = amount.toString();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAmountField(bool isDark) {
    final primary = AppColors.primaryFor(isDark);
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: AppColors.textPrimaryFor(isDark),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: 'Miktar (ml)',
        suffixText: 'ml',
        prefixIcon: Icon(Icons.water_drop_outlined, color: primary),
      ),
    );
  }

  Widget _buildDrinkTypeChips(bool isDark) {
    final primary = AppColors.primaryFor(isDark);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _drinkPresets.map((drink) {
          final isSelected = _titleController.text == drink;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(drink),
              selected: isSelected,
              selectedColor: AppColors.waterGlassFor(isDark),
              checkmarkColor: primary,
              labelStyle: TextStyle(
                color: isSelected ? primary : AppColors.textSecondaryFor(isDark),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.surfaceElevatedFor(isDark),
              side: BorderSide(
                color: isSelected ? primary : AppColors.cardBorderFor(isDark),
              ),
              onSelected: (_) {
                setState(() {
                  _titleController.text = drink;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryFor(isDark),
          foregroundColor: Colors.white,
        ),
        onPressed: _handleSubmit,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('İçeceği Kaydet'),
      ),
    );
  }

  void _handleSubmit() {
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    final title = _titleController.text.trim().isEmpty
        ? 'Su'
        : _titleController.text.trim();
    if (amount > 0) {
      widget.onAdd(title, amount, _selectedIconCode);
      Navigator.of(context).pop();
    }
  }
}
