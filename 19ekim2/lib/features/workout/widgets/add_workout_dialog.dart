import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yeni antrenman kaydı ekleme diyaloğu.
class AddWorkoutDialog extends StatefulWidget {
  final void Function(
    String title,
    int durationMinutes,
    int caloriesBurned,
    String intensity,
  ) onAdd;

  const AddWorkoutDialog({
    super.key,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context, {
    required void Function(
      String title,
      int durationMinutes,
      int caloriesBurned,
      String intensity,
    ) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutDialog(onAdd: onAdd),
    );
  }

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final TextEditingController _titleController =
      TextEditingController(text: 'Ağırlık Antrenmanı');
  final TextEditingController _durationController =
      TextEditingController(text: '30');
  final TextEditingController _calorieController =
      TextEditingController(text: '220');
  String _selectedIntensity = 'Orta';

  final List<String> _workoutPresets = const [
    'Ağırlık',
    'Koşu',
    'HIIT',
    'Bisiklet',
    'Yürüyüş',
    'Yüzme',
  ];

  final List<String> _intensities = const ['Hafif', 'Orta', 'Yüksek'];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _calorieController.dispose();
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
          const SizedBox(height: 14),
          _buildInputRow(isDark),
          const SizedBox(height: 14),
          _buildIntensitySelector(isDark),
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
          'Antrenman Kaydet',
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
    final secondary = AppColors.secondaryFor(isDark);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _workoutPresets.map((preset) {
          final isSelected = _titleController.text == preset;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(preset),
              selected: isSelected,
              selectedColor: secondary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimaryFor(isDark),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: AppColors.surfaceElevatedFor(isDark),
              side: BorderSide(
                color: isSelected ? secondary : AppColors.cardBorderFor(isDark),
              ),
              onSelected: (_) {
                setState(() {
                  _titleController.text = preset;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: AppColors.textPrimaryFor(isDark),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Süre (dk)',
              suffixText: 'dk',
              prefixIcon: Icon(
                Icons.timer_outlined,
                color: AppColors.secondaryFor(isDark),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _calorieController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: AppColors.textPrimaryFor(isDark),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Kalori (kcal)',
              suffixText: 'kcal',
              prefixIcon: Icon(
                Icons.local_fire_department_outlined,
                color: isDark ? AppColors.neonOrange : AppColors.lightOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntensitySelector(bool isDark) {
    return Row(
      children: [
        Text(
          'Yoğunluk: ',
          style: TextStyle(
            color: AppColors.textSecondaryFor(isDark),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        ..._intensities.map((intensity) {
          final isSelected = _selectedIntensity == intensity;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(intensity),
              selected: isSelected,
              selectedColor: AppColors.secondaryFor(isDark),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondaryFor(isDark),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: AppColors.surfaceElevatedFor(isDark),
              onSelected: (_) {
                setState(() {
                  _selectedIntensity = intensity;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    final secondary = AppColors.secondaryFor(isDark);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
        ),
        onPressed: _handleSubmit,
        icon: const Icon(Icons.fitness_center_rounded),
        label: const Text('Egzersizi Kaydet'),
      ),
    );
  }

  void _handleSubmit() {
    final title = _titleController.text.trim().isEmpty
        ? 'Antrenman'
        : _titleController.text.trim();
    final duration = int.tryParse(_durationController.text.trim()) ?? 30;
    final calories = int.tryParse(_calorieController.text.trim()) ?? 200;

    widget.onAdd(title, duration, calories, _selectedIntensity);
    Navigator.of(context).pop();
  }
}
