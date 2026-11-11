import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/saving_goal_model.dart';
import '../../theme/app_theme.dart';

class AddGoalSheet extends StatefulWidget {
  final SavingGoalModel? initialGoal;
  final Function(SavingGoalModel) onSave;

  const AddGoalSheet({
    super.key,
    this.initialGoal,
    required this.onSave,
  });

  @override
  State<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetAmountController;
  late TextEditingController _savedAmountController;
  late TextEditingController _quoteController;

  late int _priority;
  late String _selectedIconKey;
  String? _imagePath;

  final List<Map<String, dynamic>> _iconOptions = [
    {'key': 'laptop', 'label': 'Teknoloji', 'icon': Icons.laptop_mac_rounded},
    {'key': 'travel', 'label': 'Seyahat', 'icon': Icons.flight_takeoff_rounded},
    {'key': 'car', 'label': 'Araba', 'icon': Icons.directions_car_filled_rounded},
    {'key': 'house', 'label': 'Ev', 'icon': Icons.home_rounded},
    {'key': 'emergency', 'label': 'Acil Durum', 'icon': Icons.shield_rounded},
    {'key': 'wedding', 'label': 'Özel Gün', 'icon': Icons.favorite_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialGoal;
    _titleController = TextEditingController(text: init?.title ?? '');
    _targetAmountController = TextEditingController(
      text: init != null ? init.targetAmount.toStringAsFixed(0) : '',
    );
    _savedAmountController = TextEditingController(
      text: init != null ? init.savedAmount.toStringAsFixed(0) : '0',
    );
    _quoteController = TextEditingController(text: init?.quote ?? '');
    _priority = init?.priority ?? 1;
    _selectedIconKey = init?.iconKey ?? 'laptop';
    _imagePath = init?.imagePath;
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _imagePath = picked.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilemedi: $e'),
            backgroundColor: AppColors.dreamyCoral,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _savedAmountController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final target = double.tryParse(_targetAmountController.text.replaceAll(',', '.'));
    final saved = double.tryParse(_savedAmountController.text.replaceAll(',', '.')) ?? 0.0;

    if (target == null || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçerli bir hedef tutar giriniz.'),
          backgroundColor: AppColors.dreamyCoral,
        ),
      );
      return;
    }

    final goal = SavingGoalModel(
      id: widget.initialGoal?.id ?? 'goal_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      targetAmount: target,
      savedAmount: saved,
      priority: _priority,
      iconKey: _selectedIconKey,
      quote: _quoteController.text.trim().isEmpty ? null : _quoteController.text.trim(),
      imagePath: _imagePath,
    );

    widget.onSave(goal);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.initialGoal == null
              ? 'Hedef başarıyla oluşturuldu 🎯'
              : 'Hedef güncellendi ✓',
        ),
        backgroundColor: AppColors.forestPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialGoal == null ? 'Yeni Birikim Hedefi' : 'Hedefi Düzenle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // İkon Seçimi
              Text(
                'Hedef Türü & İkon',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _iconOptions.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _iconOptions[index];
                    final isSelected = item['key'] == _selectedIconKey;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIconKey = item['key'];
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.forestPrimary
                              : (isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.forestPrimary
                                : (isDark ? AppColors.darkBorder : AppColors.warmBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              size: 18,
                              color: isSelected ? Colors.white : AppColors.forestPrimary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Hedef Adı
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Hedef Adı',
                  hintText: 'Örn: Japonya Seyahati, Yeni Araba...',
                  prefixIcon: Icon(Icons.flag_rounded),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Hedef adı giriniz' : null,
              ),

              const SizedBox(height: 14),

              // Hedef Tutar & Mevcut Birikim
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _targetAmountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Hedef Tutar (₺)',
                        hintText: '50000',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Tutar giriniz';
                        final numVal = double.tryParse(val.replaceAll(',', '.'));
                        if (numVal == null || numVal <= 0) return 'Geçersiz tutar';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _savedAmountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Mevcut Birikmiş (₺)',
                        hintText: '0',
                        prefixIcon: Icon(Icons.savings_outlined),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Öncelik Seçimi (1: Yüksek, 2: Orta, 3: Düşük)
              Text(
                'Öncelik Derecesi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip(1, '1. En Yüksek Öncelik'),
                  const SizedBox(width: 8),
                  _buildPriorityChip(2, '2. Orta'),
                  const SizedBox(width: 8),
                  _buildPriorityChip(3, '3. Düşük'),
                ],
              ),

              const SizedBox(height: 14),

              // Motive Edici Not
              TextFormField(
                controller: _quoteController,
                decoration: const InputDecoration(
                  labelText: 'Vision Board Motive Cümlesi',
                  hintText: 'Örn: Kiraz çiçekleri altında unutulmaz bir bahar 🌸',
                  prefixIcon: Icon(Icons.auto_awesome),
                ),
              ),

              const SizedBox(height: 16),

              // Pinterest Tarzı Fotoğraf Seçimi (Galeriden)
              Text(
                'Vision Board Fotoğrafı (Pinterest Tarzı)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              if (_imagePath != null && _imagePath!.isNotEmpty)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(_imagePath!),
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100,
                          color: Colors.grey.withOpacity(0.2),
                          alignment: Alignment.center,
                          child: const Text('Fotoğraf yüklenemedi'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, size: 16, color: Colors.white),
                          onPressed: () => setState(() => _imagePath = null),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library_outlined, size: 20),
                    label: const Text('Galeriden Fotoğraf Seç 📸'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.initialGoal == null ? 'Hedefi Başlat' : 'Hedefi Güncelle'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(int level, String label) {
    final isSelected = _priority == level;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _priority = level;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.dreamyYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.dreamyYellow : AppColors.warmBorder,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? const Color(0xFF5A4400) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
