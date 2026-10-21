import 'package:flutter/material.dart';
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

    // En yüksek kategori bul
    String topCat = 'Bulunamadı';
    if (catExpenses.isNotEmpty) {
      final entries = catExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      topCat = entries.first.key;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pasta Grafik Kartı
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
                      'Kategori Bazlı Dağılım',
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
                      child: const Text(
                        'Bu Ay',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                EditorialDonutChart(
                  data: catExpenses,
                  totalAmount: totalExpense,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Akıllı Finansal Yorum Kutusu
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardAlt : const Color(0xFFF0F7F2),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.forestLight.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.forestPrimary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: AppColors.forestPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akıllı Harcama Yorumu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalExpense > 0
                            ? 'Bu ay en yüksek harcama kalemin "$topCat" oldu. İsteğe bağlı harcamaların toplam harcamanın %${(100 - (needRatio * 100)).toStringAsFixed(0)}\'ini oluşturuyor. Tasarruf hedeflerine sadık kalıyorsun!'
                            : 'Bu ay henüz harcama verisi girilmedi. Harcamalarını kaydettikçe burada kişiselleştirilmiş içgörüler göreceksin.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

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
                          'Zorunlu İhtiyaç: ${CurrencyFormatter.format(needTotal, showDecimals: false)} (%${(needRatio * 100).toStringAsFixed(0)})',
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
                          'İstek: ${CurrencyFormatter.format(wantTotal, showDecimals: false)}',
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

  // 2. Görünüm: Dönem Raporları & Bütçe Önerileri
  Widget _buildReportsTab(BuildContext context, bool isDark) {
    final state = widget.state;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gelecek Ay Bütçe Önerisi Kutusu (AI / Akıllı Tahmin)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forestDeep.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.dreamyYellow, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Gelecek Ay Bütçe Önerileri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Geçmiş harcama ortalamalarına dayanarak Kasım ayı için önerilen tahsisler:',
                  style: TextStyle(color: Color(0xFFD8EADE), fontSize: 13),
                ),
                const SizedBox(height: 14),
                _buildSuggestionRow('Market & Gıda', '₺7.500', 'Geçmiş ortalama: ₺7.000'),
                _buildSuggestionRow('Faturalar & Sabit', '₺2.200', 'Mevcut abonelikler dahil'),
                _buildSuggestionRow('Yeme-İçme & Sosyal', '₺4.000', 'Tasarruf için %10 azaltıldı'),
                _buildSuggestionRow('Hedef Birikim Payı', '₺8.000', 'Tokyo seyahati fonuna'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Paylaşılabilir Aylık Özet Kartı
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MoneyPlan Finansal Karnen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Aylık finansal özet panosu kopyalandı! 📋'),
                            backgroundColor: AppColors.forestPrimary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                _buildSummaryStatRow('Toplam Gelir', CurrencyFormatter.format(state.thisMonthIncome)),
                _buildSummaryStatRow('Toplam Gider', CurrencyFormatter.format(state.thisMonthExpense)),
                _buildSummaryStatRow('Birikime Ayrılan', CurrencyFormatter.format(state.thisMonthSaving)),
                _buildSummaryStatRow(
                  'Tasarruf Oranı',
                  state.thisMonthIncome > 0
                      ? '%${((state.thisMonthSaving / state.thisMonthIncome) * 100).toStringAsFixed(1)}'
                      : '%0',
                ),
                _buildSummaryStatRow('Net Kullanılabilir', CurrencyFormatter.format(state.usableMoney)),
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

  Widget _buildSuggestionRow(String title, String amount, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              Text(
                note,
                style: const TextStyle(color: Color(0xFFB4D2BE), fontSize: 11),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.dreamyYellow,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
