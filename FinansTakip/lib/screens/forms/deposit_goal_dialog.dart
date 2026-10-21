import 'package:flutter/material.dart';
import '../../models/saving_goal_model.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';

class DepositGoalDialog extends StatefulWidget {
  final SavingGoalModel goal;
  final Function(double amount, String? note) onDeposit;

  const DepositGoalDialog({
    super.key,
    required this.goal,
    required this.onDeposit,
  });

  @override
  State<DepositGoalDialog> createState() => _DepositGoalDialogState();
}

class _DepositGoalDialogState extends State<DepositGoalDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final List<double> _quickAmounts = [500, 1000, 2500, 5000];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amt = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amt == null || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir birikim tutarı giriniz.')),
      );
      return;
    }

    widget.onDeposit(amt, _noteController.text.trim().isEmpty ? null : _noteController.text.trim());
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${CurrencyFormatter.format(amt)} ${widget.goal.title} hedefine eklendi! 🎉'),
        backgroundColor: AppColors.forestPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.creamCard,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.savings_rounded, color: AppColors.forestPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.goal.title}\'na Birikim Ekle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kalan: ${CurrencyFormatter.format(widget.goal.remainingAmount)}',
            style: const TextStyle(fontSize: 12, color: AppColors.forestPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hızlı Tutar Butonları
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAmounts.map((val) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _amountController.text = val.toStringAsFixed(0);
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.forestSoftBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '+₺${val.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.forestPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Eklenecek Tutar (₺)',
                hintText: '1000',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Not (İsteğe bağlı)',
                hintText: 'Maaştan kalanla...',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Birikimi Kaydet'),
        ),
      ],
    );
  }
}
