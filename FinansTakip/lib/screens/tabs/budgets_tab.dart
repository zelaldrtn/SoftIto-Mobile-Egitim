import 'package:flutter/material.dart';
import '../../models/recurring_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/recurring_item.dart';
import '../forms/add_recurring_sheet.dart';

class BudgetsTab extends StatelessWidget {
  final FinanceState state;

  const BudgetsTab({super.key, required this.state});

  void _showSetBudgetDialog(BuildContext context, {String? category, double? currentLimit}) {
    final isNewCategory = category == null || category.isEmpty;
    final categoryController = TextEditingController(text: isNewCategory ? '' : category);
    final limitController = TextEditingController(
      text: currentLimit != null && currentLimit > 0
          ? (currentLimit % 1 == 0 ? currentLimit.toInt().toString() : currentLimit.toString())
          : '3000',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<String> suggestedCategories = [
      'Market',
      'Yemek',
      'Kira',
      'Faturalar',
      'Abonelik',
      'Giyim',
      'Eğlence',
      'Ulaşım',
      'Sağlık',
      'Eğitim',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: isDark ? AppColors.darkCard : AppColors.creamCard,
          title: Text(
            isNewCategory ? 'Yeni Kategori Limiti Ekle' : '$category Limiti Belirle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewCategory) ...[
                  const Text(
                    'Kategori Adı:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: categoryController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Adı',
                      hintText: 'Örn: Market, Kira, Ulaşım...',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: suggestedCategories.map((cat) {
                      final isSelected = categoryController.text.trim().toLowerCase() == cat.toLowerCase();
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            categoryController.text = cat;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.forestPrimary
                                : (isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.forestPrimary
                                  : (isDark ? AppColors.darkBorder : AppColors.warmBorder),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                ],
                const Text(
                  'Aylık harcama tavanını giriniz:',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: limitController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Limit (₺)',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final catName = categoryController.text.trim();
                final val = double.tryParse(limitController.text.replaceAll(',', '.'));
                if (catName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir kategori adı giriniz.'),
                      backgroundColor: AppColors.dreamyCoral,
                    ),
                  );
                  return;
                }
                if (val != null && val > 0) {
                  state.setBudgetLimit(catName, val);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$catName limiti güncellendi ✓'),
                      backgroundColor: AppColors.forestPrimary,
                    ),
                  );
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddRecurring(BuildContext context, {RecurringPaymentModel? rec}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddRecurringSheet(
        initialRecurring: rec,
        state: state,
        onSave: (saved) {
          if (rec == null) {
            state.addRecurringPayment(saved);
          } else {
            state.updateRecurringPayment(saved);
          }
        },
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
                ElevatedButton.icon(
                  onPressed: () => _showSetBudgetDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Limit Ekle', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
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
                  onEditLimit: () => _showSetBudgetDialog(
                    context,
                    category: b.category,
                    currentLimit: b.limitAmount,
                  ),
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
                    onTap: () => _openAddRecurring(context, rec: rec),
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
