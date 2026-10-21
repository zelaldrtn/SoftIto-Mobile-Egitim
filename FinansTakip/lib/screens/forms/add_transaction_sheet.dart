import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';

class AddTransactionSheet extends StatefulWidget {
  final TransactionModel? initialTransaction;
  final Function(TransactionModel) onSave;

  const AddTransactionSheet({
    super.key,
    this.initialTransaction,
    required this.onSave,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late TransactionType _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late bool _isNeed;

  final List<String> _incomeCategories = ['Maaş', 'Ek Gelir', 'Yatırım', 'Hediye', 'Diğer'];
  final List<String> _expenseCategories = [
    'Market',
    'Yemek',
    'Kira',
    'Faturalar',
    'Giyim',
    'Ulaşım',
    'Eğlence',
    'Sağlık',
    'Eğitim',
    'Diğer'
  ];
  final List<String> _savingCategories = ['Birikim', 'Altın', 'Döviz', 'Hisse/Fon', 'Kumbara'];

  @override
  void initState() {
    super.initState();
    final init = widget.initialTransaction;
    _titleController = TextEditingController(text: init?.title ?? '');
    _amountController = TextEditingController(
      text: init != null ? init.amount.toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: init?.note ?? '');
    _selectedType = init?.type ?? TransactionType.expense;
    _selectedCategory = init?.category ?? 'Market';
    _selectedDate = init?.date ?? DateTime.now();
    _isNeed = init?.isNeed ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<String> get _currentCategories {
    switch (_selectedType) {
      case TransactionType.income:
        return _incomeCategories;
      case TransactionType.expense:
        return _expenseCategories;
      case TransactionType.saving:
        return _savingCategories;
    }
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _selectedType = type;
      final cats = _currentCategories;
      if (!cats.contains(_selectedCategory)) {
        _selectedCategory = cats.first;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.forestPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amountString = _amountController.text.replaceAll(',', '.').trim();
    final amount = double.tryParse(amountString);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen 0\'dan büyük geçerli bir tutar giriniz.'),
          backgroundColor: AppColors.dreamyCoral,
        ),
      );
      return;
    }

    final tx = TransactionModel(
      id: widget.initialTransaction?.id ?? 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      type: _selectedType,
      isNeed: _isNeed,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    widget.onSave(tx);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.initialTransaction == null
              ? 'İşlem başarıyla eklendi ✨'
              : 'İşlem güncellendi ✓',
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
              // Başlık
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialTransaction == null ? 'Yeni İşlem Ekle' : 'İşlemi Düzenle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
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

              // İşlem Türü Seçimi (Gelir / Gider / Birikim)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTypeChip('Gider', TransactionType.expense, AppColors.dreamyCoral),
                    _buildTypeChip('Gelir', TransactionType.income, AppColors.forestPrimary),
                    _buildTypeChip('Birikim', TransactionType.saving, AppColors.dreamyLilac),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Başlık Input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'İşlem Açıklaması',
                  hintText: 'Örn: Haftalık market, Maaş, Kahve...',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir başlık giriniz.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Tutar Input
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Tutar (₺)',
                  hintText: '0,00',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir tutar giriniz.';
                  }
                  final val = double.tryParse(value.replaceAll(',', '.'));
                  if (val == null || val <= 0) {
                    return 'Geçerli bir pozitif tutar giriniz.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Kategori Seçimi (Dropdown)
              DropdownButtonFormField<String>(
                value: _currentCategories.contains(_selectedCategory)
                    ? _selectedCategory
                    : _currentCategories.first,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _currentCategories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              // Tarih Seçici Butonu
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardAlt : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.forestPrimary),
                      const SizedBox(width: 12),
                      Text(
                        DateFormatter.formatFull(_selectedDate),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Değiştir',
                        style: TextStyle(
                          color: AppColors.forestPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // İstek vs İhtiyaç Seçimi (Yalnızca Gider ise göster)
              if (_selectedType == TransactionType.expense) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Harcama Niteliği',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _isNeed ? 'Zorunlu / Temel Gider' : 'İsteğe Bağlı / Keyfi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _isNeed ? AppColors.forestPrimary : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isNeed = true),
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isNeed
                                      ? AppColors.forestPrimary
                                      : (isDark ? Colors.black26 : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isNeed
                                        ? AppColors.forestPrimary
                                        : (isDark ? AppColors.darkBorder : AppColors.warmBorder),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: _isNeed ? Colors.white : Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'İhtiyaç',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: _isNeed ? FontWeight.w700 : FontWeight.w500,
                                        color: _isNeed
                                            ? Colors.white
                                            : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isNeed = false),
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isNeed
                                      ? AppColors.dreamyYellow
                                      : (isDark ? Colors.black26 : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: !_isNeed
                                        ? AppColors.dreamyYellow
                                        : (isDark ? AppColors.darkBorder : AppColors.warmBorder),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: 16,
                                      color: !_isNeed ? const Color(0xFF6B4E00) : Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'İstek',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: !_isNeed ? FontWeight.w700 : FontWeight.w500,
                                        color: !_isNeed
                                            ? const Color(0xFF6B4E00)
                                            : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Not Input (Opsiyonel)
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Not (İsteğe bağlı)',
                  hintText: 'Eklemek istediğiniz özel bir not...',
                  prefixIcon: Icon(Icons.sticky_note_2_outlined),
                ),
              ),

              const SizedBox(height: 24),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    widget.initialTransaction == null ? 'İşlemi Kaydet' : 'Değişiklikleri Güncelle',
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, TransactionType type, Color color) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTypeChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
