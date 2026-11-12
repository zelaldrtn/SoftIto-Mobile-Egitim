import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/transaction_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/custom_chart.dart';
import '../../widgets/money_wrapped_sheet.dart';

class AnalyticsTab extends StatefulWidget {
  final FinanceState state;

  const AnalyticsTab({super.key, required this.state});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'monthly'; // 'weekly', 'monthly', 'yearly'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openWrapped(BuildContext context) {
    final catExpenses = widget.state.categoryExpensesThisMonth;
    String topCat = 'Genel';
    double topAmt = 0;
    if (catExpenses.isNotEmpty) {
      final entries = catExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topCat = entries.first.key;
      topAmt = entries.first.value;
    }
    final goalTitle = widget.state.primaryGoal?.title ?? 'Hayallerim';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MoneyWrappedSheet(
        totalIncome: widget.state.thisMonthIncome,
        totalExpense: widget.state.thisMonthExpense,
        totalSaving: widget.state.thisMonthSaving,
        topExpenseCategory: topCat,
        topExpenseCategoryAmount: topAmt,
        highlightSavingGoal: goalTitle,
        usableMoney: widget.state.usableMoney,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Üst TabBar: Analizler & Raporlar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.creamCardAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.forestPrimary,
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(text: 'Harcama Dağılımı'),
                Tab(text: 'Dönem Raporları'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExpensesAnalysisTab(context, isDark),
                _buildReportsTab(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. Görünüm: Harcama Dağılımı & Pasta / Çubuk Grafikler
  Widget _buildExpensesAnalysisTab(BuildContext context, bool isDark) {
    final catExpenses = widget.state.categoryExpensesThisMonth;
    final totalExpense = widget.state.thisMonthExpense;
    final needVsWant = widget.state.needVsWantExpensesThisMonth;
    final needTotal = needVsWant['İhtiyaç'] ?? 0;
    final wantTotal = needVsWant['İstek'] ?? 0;
    final needRatio = totalExpense > 0 ? (needTotal / totalExpense).clamp(0.0, 1.0) : 0.5;

    // En çok harcama yapılan kategori
    String topCat = 'Henüz veri yok';
    double topAmt = 0.0;
    if (catExpenses.isNotEmpty) {
      final entries = catExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      topCat = entries.first.key;
      topAmt = entries.first.value;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dönem Seçici Filtre (Haftalık, Aylık, Yıllık)
          Row(
            children: [
              _buildPeriodChip('Haftalık', 'weekly'),
              const SizedBox(width: 8),
              _buildPeriodChip('Aylık', 'monthly'),
              const SizedBox(width: 8),
              _buildPeriodChip('Yıllık', 'yearly'),
            ],
          ),
          const SizedBox(height: 14),

          // Pasta / Halka Grafik Kartı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(24),
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
                      'Kategori Bazlı Gider Dağılımı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.forestSoftBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedPeriod == 'weekly'
                            ? 'Bu Hafta'
                            : (_selectedPeriod == 'yearly' ? 'Bu Yıl' : 'Bu Ay'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: EditorialDonutChart(
                    data: catExpenses,
                    totalAmount: totalExpense,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // En Çok Harcama Yapılan Kategori Kartı
          if (catExpenses.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardAlt : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE27396).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_rounded, color: Color(0xFFE27396), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'En Çok Harcama Yapılan Kategori',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          topCat,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(topAmt, currency: widget.state.primaryCurrency),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFFE27396)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],

          // İstek vs İhtiyaç Oranı Kartı
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(22),
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
                      'İhtiyaç vs. İstek Dengesi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '50/30 Kuralı',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (needRatio * 100).toInt(),
                        child: Container(
                          height: 14,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                      Expanded(
                        flex: ((1 - needRatio) * 100).toInt().clamp(1, 100),
                        child: Container(
                          height: 14,
                          color: AppColors.dreamyYellow,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 10, color: AppColors.forestPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'Zorunlu İhtiyaç: ${CurrencyFormatter.format(needTotal, showDecimals: false, currency: widget.state.primaryCurrency)} (%${(needRatio * 100).toStringAsFixed(0)})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 10, height: 10, color: AppColors.dreamyYellow),
                        const SizedBox(width: 6),
                        Text(
                          'İstek: ${CurrencyFormatter.format(wantTotal, showDecimals: false, currency: widget.state.primaryCurrency)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Son 7 Gün Çubuk Grafiği
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalık Harcama Trendi (Son 7 Gün)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                WeeklyBarChart(dailyData: widget.state.last7DaysExpenses),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Görünüm: Dönem Raporları & Kart Bazlı Harcama
  Widget _buildReportsTab(BuildContext context, bool isDark) {
    final state = widget.state;
    final now = DateTime.now();

    // Önceki ay hesaplaması (Karşılaştırma için)
    final prevMonthDate = DateTime(now.year, now.month - 1, 1);
    final prevMonthExpenses = state.transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == prevMonthDate.year &&
            t.date.month == prevMonthDate.month)
        .fold(0.0, (sum, t) => sum + t.amountInPrimary);

    final expenseDifference = state.thisMonthExpense - prevMonthExpenses;
    final isExpenseIncreased = expenseDifference > 0;

    // Kart bazlı harcama hesaplaması
    final Map<String, double> cardExpenses = {};
    for (var tx in state.transactions) {
      if (tx.type == TransactionType.expense &&
          tx.date.year == now.year &&
          tx.date.month == now.month) {
        final key = tx.accountName ?? (tx.cardId != null ? 'Kart Harcaması' : 'Nakit Harcama');
        cardExpenses[key] = (cardExpenses[key] ?? 0.0) + tx.amountInPrimary;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Önceki Ayla Karşılaştırma Kartı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isExpenseIncreased
                    ? [const Color(0xFF4A1E2B), const Color(0xFF6B2B3E)]
                    : [AppColors.forestDeep, AppColors.forestPrimary],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (isExpenseIncreased ? const Color(0xFF6B2B3E) : AppColors.forestDeep)
                      .withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Önceki Ayla Karşılaştırma',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(
                      isExpenseIncreased ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      color: AppColors.dreamyYellow,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bu Ayki Gider', style: TextStyle(color: Color(0xFFD8EADE), fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(state.thisMonthExpense, currency: state.primaryCurrency),
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Geçen Ayki Gider', style: TextStyle(color: Color(0xFFD8EADE), fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(prevMonthExpenses, currency: state.primaryCurrency),
                          style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  prevMonthExpenses > 0
                      ? (isExpenseIncreased
                          ? 'Geçen aya göre ${CurrencyFormatter.format(expenseDifference.abs(), currency: state.primaryCurrency)} daha fazla harcama yapıldı.'
                          : 'Geçen aya göre ${CurrencyFormatter.format(expenseDifference.abs(), currency: state.primaryCurrency)} tasarruf sağlandı!')
                      : 'Geçmiş ay verisi sınırlı. İşlemleriniz kaydedildikçe karşılaştırma netleşecektir.',
                  style: const TextStyle(color: AppColors.dreamyYellow, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Kart / Hesap Bazlı Harcama Dağılımı
          if (cardExpenses.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hesap & Kart Bazlı Harcama Dağılımı',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  ...cardExpenses.entries.map((entry) {
                    final ratio = state.thisMonthExpense > 0
                        ? (entry.value / state.thisMonthExpense).clamp(0.0, 1.0)
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(
                                CurrencyFormatter.format(entry.value, currency: state.primaryCurrency),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: ratio,
                            backgroundColor: Colors.grey.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation(AppColors.forestPrimary),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Paylaşılabilir Aylık Karne
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${AppConstants.appName} Finansal Karnen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                _buildSummaryStatRow('Toplam Gelir', CurrencyFormatter.format(state.thisMonthIncome, currency: state.primaryCurrency)),
                _buildSummaryStatRow('Toplam Gider', CurrencyFormatter.format(state.thisMonthExpense, currency: state.primaryCurrency)),
                _buildSummaryStatRow('Birikime Ayrılan', CurrencyFormatter.format(state.thisMonthSaving, currency: state.primaryCurrency)),
                _buildSummaryStatRow(
                  'Tasarruf Oranı',
                  state.thisMonthIncome > 0
                      ? '%${((state.thisMonthSaving / state.thisMonthIncome) * 100).toStringAsFixed(1)}'
                      : '%0',
                ),
                _buildSummaryStatRow('Net Kullanılabilir', CurrencyFormatter.format(state.usableMoney, currency: state.primaryCurrency)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openWrapped(context),
                    icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    label: const Text('Money Wrapped Kartlarını Aç'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedPeriod = value);
      },
    );
  }

  Widget _buildSummaryStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
