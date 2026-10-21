import 'package:flutter/material.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/usable_money_card.dart';
import '../../widgets/stat_summary_card.dart';
import '../../widgets/transaction_item.dart';
import '../../widgets/vision_board_card.dart';
import '../../widgets/recurring_item.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/money_wrapped_sheet.dart';
import '../forms/deposit_goal_dialog.dart';
import '../forms/add_transaction_sheet.dart';

class OverviewTab extends StatelessWidget {
  final FinanceState state;
  final VoidCallback onNavigateToTransactions;

  const OverviewTab({
    super.key,
    required this.state,
    required this.onNavigateToTransactions,
  });

  void _showDeleteDialog(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İşlemi Sil'),
        content: Text('"$title" işlemini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.deleteTransaction(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('İşlem silindi.')),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openWrapped(BuildContext context) {
    final catExpenses = state.categoryExpensesThisMonth;
    String topCat = 'Market';
    double topAmt = 0;
    if (catExpenses.isNotEmpty) {
      final entries = catExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topCat = entries.first.key;
      topAmt = entries.first.value;
    }

    final goalTitle = state.primaryGoal?.title ?? 'Hayallerim';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MoneyWrappedSheet(
        totalIncome: state.thisMonthIncome,
        totalExpense: state.thisMonthExpense,
        totalSaving: state.thisMonthSaving,
        topExpenseCategory: topCat,
        topExpenseCategoryAmount: topAmt,
        highlightSavingGoal: goalTitle,
        usableMoney: state.usableMoney,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGoal = state.primaryGoal;
    final recentTransactions = state.transactions.take(5).toList();
    final upcomingRecurring = state.recurring.where((r) => !r.isPaid).take(3).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Akıllı "Kullanılabilir Para" ve Önerilen Harcama Kartı
          UsableMoneyCard(
            usableMoney: state.usableMoney,
            currentBalance: state.currentBalance,
            upcomingRecurring: state.upcomingUnpaidRecurringAmount,
            reservedSavings: state.thisMonthSaving,
            protectedBuffer: state.protectedBufferAmount,
            dailyRecommended: state.dailyRecommendedSpend,
            weeklyRecommended: state.weeklyRecommendedSpend,
          ),

          const SizedBox(height: 18),

          // 2. Gelir, Gider, Birikim Özet Mini Kartları
          StatSummaryCards(
            income: state.thisMonthIncome,
            expense: state.thisMonthExpense,
            saving: state.thisMonthSaving,
          ),

          const SizedBox(height: 20),

          // 3. Money Wrapped Banner (Dreamy Dokunuş)
          InkWell(
            onTap: () => _openWrapped(context),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C1943), Color(0xFF4C2775)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4C2775).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.dreamyYellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.dreamyYellow,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aylık Money Wrapped ✨',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Finansal alışkanlıklarını keşfet ve paylaş',
                          style: TextStyle(
                            color: Color(0xFFD6C8E8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 4. Aylık Genel Bütçe İlerlemesi
          BudgetProgressCard(
            category: 'Ekim Ayı Genel Bütçesi',
            spent: state.thisMonthExpense,
            limit: state.monthlyGeneralBudgetLimit,
          ),

          const SizedBox(height: 24),

          // 5. Öne Çıkan Birikim Hedefi (Vision Board Kartı)
          if (primaryGoal != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Öne Çıkan Hedefim 🎯',
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
            VisionBoardCard(
              goal: primaryGoal,
              onDepositTap: () {
                showDialog(
                  context: context,
                  builder: (_) => DepositGoalDialog(
                    goal: primaryGoal,
                    onDeposit: (amt, note) {
                      state.depositToGoal(primaryGoal.id, amt, note: note);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // 6. Yaklaşan Zorunlu Ödemeler
          if (upcomingRecurring.isNotEmpty) ...[
            Text(
              'Yaklaşan Ödemeler 🔔',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...upcomingRecurring.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RecurringItem(
                  payment: item,
                  onTogglePaid: () => state.toggleRecurringPaid(item.id),
                ),
              );
            }),
            const SizedBox(height: 14),
          ],

          // 7. Son İşlemler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son İşlemler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onNavigateToTransactions,
                child: const Text('Tümünü Gör'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (recentTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text('Henüz işlem kaydedilmemiş.'),
            )
          else
            ...recentTransactions.map((tx) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TransactionItem(
                  transaction: tx,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => AddTransactionSheet(
                        initialTransaction: tx,
                        onSave: (updated) => state.updateTransaction(updated),
                      ),
                    );
                  },
                  onDelete: () => _showDeleteDialog(context, tx.id, tx.title),
                ),
              );
            }),
        ],
      ),
    );
  }
}
