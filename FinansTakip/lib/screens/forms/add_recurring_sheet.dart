import 'package:flutter/material.dart';
import '../../models/recurring_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';

class AddRecurringSheet extends StatefulWidget {
  final RecurringPaymentModel? initialRecurring;
  final FinanceState? state;
  final Function(RecurringPaymentModel) onSave;

  const AddRecurringSheet({
    super.key,
    this.initialRecurring,
    this.state,
    required this.onSave,
  });

  @override
  State<AddRecurringSheet> createState() => _AddRecurringSheetState();
}

class _AddRecurringSheetState extends State<AddRecurringSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  late int _selectedDay;
  late String _selectedCategory;
  late String _selectedIcon;

  final List<Map<String, dynamic>> _quickTemplates = [
    {'title': 'Netflix', 'amount': 299.99, 'cat': 'Abonelik', 'icon': 'netflix'},
    {'title': 'Spotify', 'amount': 99.99, 'cat': 'Abonelik', 'icon': 'spotify'},
    {'title': 'Ev Kirası', 'amount': 17500.0, 'cat': 'Kira', 'icon': 'rent'},
    {'title': 'İnternet', 'amount': 450.0, 'cat': 'Faturalar', 'icon': 'wifi'},
    {'title': 'Spor Salonu', 'amount': 1200.0, 'cat': 'Sağlık', 'icon': 'gym'},
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialRecurring;
    _titleController = TextEditingController(text: init?.title ?? '');
    _amountController = TextEditingController(
      text: init != null
          ? (init.amount % 1 == 0 ? init.amount.toInt().toString() : init.amount.toString())
          : '',
    );
    _selectedDay = init?.dueDay ?? 1;
    _selectedCategory = init?.category ?? 'Abonelik';
    _selectedIcon = init?.iconKey ?? 'netflix';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amt = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amt == null || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir tutar giriniz.')),
      );
      return;
    }

    final rec = RecurringPaymentModel(
      id: widget.initialRecurring?.id ?? 'rec_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: amt,
      category: _selectedCategory,
      dueDay: _selectedDay,
      repeatType: widget.initialRecurring?.repeatType ?? 'Aylık',
      isPaid: widget.initialRecurring?.isPaid ?? false,
      iconKey: _selectedIcon,
    );

    widget.onSave(rec);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.initialRecurring == null
              ? 'Düzenli ödeme eklendi ✓'
              : 'Düzenli ödeme güncellendi ✓',
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
                    'Düzenli Ödeme / Abonelik Ekle',
                    style: TextStyle(
                      fontSize: 18,
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
              const SizedBox(height: 12),

              // Hızlı Şablonlar
              Text(
                'Hızlı Şablonlar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickTemplates.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _quickTemplates[index];
                    final defaultPrice = (item['amount'] as num).toDouble();
                    final dynamicPrice = widget.state?.getTemplatePrice(item['title'] as String, defaultPrice) ?? defaultPrice;
                    final priceStr = dynamicPrice % 1 == 0
                        ? dynamicPrice.toInt().toString()
                        : dynamicPrice.toStringAsFixed(2);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _titleController.text = item['title'];
                          _amountController.text = priceStr;
                          _selectedCategory = item['cat'];
                          _selectedIcon = item['icon'];
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.dreamyLilacLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.dreamyLilac.withOpacity(0.4)),
                        ),
                        child: Text(
                          '${item['title']} (₺$priceStr)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forestPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Ödeme Adı',
                  hintText: 'Örn: Netflix, Ev Kirası, Aidat...',
                  prefixIcon: Icon(Icons.receipt_long_rounded),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Başlık giriniz' : null,
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Aylık Tutar (₺)',
                  hintText: '299.99',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Tutar giriniz';
                  final numVal = double.tryParse(val.replaceAll(',', '.'));
                  if (numVal == null || numVal <= 0) return 'Geçersiz tutar';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Ayın Hangi Günü? (1-31)
              Row(
                children: [
                  const Icon(Icons.event_repeat_rounded, color: AppColors.forestPrimary),
                  const SizedBox(width: 10),
                  Text(
                    'Ödeme Günü: Her ayın $_selectedDay. günü',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _selectedDay.toDouble(),
                min: 1,
                max: 31,
                divisions: 30,
                activeColor: AppColors.forestPrimary,
                label: '$_selectedDay. gün',
                onChanged: (val) {
                  setState(() {
                    _selectedDay = val.round();
                  });
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Düzenli Ödemeyi Kaydet'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
