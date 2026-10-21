import 'package:flutter/material.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/recurring_item.dart';
import '../forms/add_recurring_sheet.dart';

class BudgetsTab extends StatelessWidget {
  final FinanceState state;

  const BudgetsTab({super.key, required this.state});

  void _showSetBudgetDialog(BuildContext context, String category, double currentLimit) {
    final controller = TextEditingController(text: currentLimit.toStringAsFixed(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.creamCard,
        title: Text(
          '$category Limiti Belirle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aylık harcama tavanını giriniz:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Limit (₺)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text.replaceAll(',', '.'));
              if (val != null && val > 0) {
                state.setBudgetLimit(category, val);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$category limiti güncellendi ✓'),
                    backgroundColor: AppColors.forestPrimary,
                  ),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _openAddRecurring(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddRecurringSheet(
        onSave: (rec) => state.addRecurringPayment(rec),
      ),
    );
  }

  void _showDeleteRecurringDialog(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aboneliği Sil'),
        content: Text('"$title" kaydını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.deleteRecurringPayment(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abonelik silindi.')),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final budgets = state.budgets;
    final recurring = state.recurring;
    final catExpenses = state.categoryExpensesThisMonth;

    // Sabit gider toplamı
    double totalRecurringAmount = recurring.fold(0.0, (sum, r) => sum + r.amount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Abonelik & Sabit Gider Özeti Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.creamCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.dreamyLilac.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.repeat_rounded,
                      color: AppColors.dreamyLilac,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aylık Sabit & Zorunlu Gider',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalRecurringAmount, showDecimals: false),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openAddRecurring(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    child: const Text('Ekle +', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Kategori Bütçe Limitleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aylık Kategori Bütçeleri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => _showSetBudgetDialog(
                    context,
                    'Yeni Kategori',
                    3000,
                  ),
                  child: const Text('Limit Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...budgets.map((b) {
              final spent = b.category == 'Genel Bütçe'
                  ? state.thisMonthExpense
                  : (catExpenses[b.category] ?? 0.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BudgetProgressCard(
                  category: b.category,
                  spent: spent,
                  limit: b.limitAmount,
                  onEditLimit: () => _showSetBudgetDialog(context, b.category, b.limitAmount),
                ),
              );
            }),

            const SizedBox(height: 24),

            // 3. Düzenli Ödemeler ve Abonelikler Listesi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Abonelikler ve Faturalar 📅',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (recurring.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: const Text('Henüz düzenli ödeme kaydı eklenmedi.'),
              )
            else
              ...recurring.map((rec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onLongPress: () => _showDeleteRecurringDialog(context, rec.id, rec.title),
                    borderRadius: BorderRadius.circular(20),
                    child: RecurringItem(
                      payment: rec,
                      onTogglePaid: () => state.toggleRecurringPaid(rec.id),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
