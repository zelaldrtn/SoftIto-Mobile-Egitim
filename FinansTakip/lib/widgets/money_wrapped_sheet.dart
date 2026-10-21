import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class MoneyWrappedSheet extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;
  final double totalSaving;
  final String topExpenseCategory;
  final double topExpenseCategoryAmount;
  final String highlightSavingGoal;
  final double usableMoney;

  const MoneyWrappedSheet({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSaving,
    required this.topExpenseCategory,
    required this.topExpenseCategoryAmount,
    required this.highlightSavingGoal,
    required this.usableMoney,
  });

  @override
  State<MoneyWrappedSheet> createState() => _MoneyWrappedSheetState();
}

class _MoneyWrappedSheetState extends State<MoneyWrappedSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final int _totalPages = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Sürükleme Çizgisi
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          // Story / Sayfa İlerleme Çubukları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(_totalPages, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? AppColors.dreamyYellow
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // Üst Başlık & Kapat Butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.dreamyYellow, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'MONEY WRAPPED 2026',
                      style: TextStyle(
                        color: AppColors.dreamyYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Kartlar PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (idx) {
                setState(() {
                  _currentPage = idx;
                });
              },
              children: [
                // Kart 1: Giriş & Toplam Akış
                _buildStoryCard(
                  emoji: '✨',
                  title: 'Finansal Yolculuğun',
                  subtitle: 'Bu ay toplamda hesabına',
                  highlight: CurrencyFormatter.format(widget.totalIncome, showDecimals: false),
                  footerText: 'gelir girişi oldu. Paranı bilinçle yönettin!',
                  bgGradient: [const Color(0xFF133E2B), const Color(0xFF1E5638)],
                ),

                // Kart 2: Harcama & En Çok Nereye Gitti
                _buildStoryCard(
                  emoji: '🛍️',
                  title: 'En Büyük Harcama Kalemin',
                  subtitle: 'Bu ay en çok bütçe ayırdığın alan:',
                  highlight: widget.topExpenseCategory,
                  secondaryHighlight: CurrencyFormatter.format(
                    widget.topExpenseCategoryAmount,
                    showDecimals: false,
                  ),
                  footerText: 'Toplam harcaman ise ${CurrencyFormatter.format(widget.totalExpense, showDecimals: false)} oldu.',
                  bgGradient: [const Color(0xFF371B49), const Color(0xFF592D73)],
                ),

                // Kart 3: Birikim & Başarı
                _buildStoryCard(
                  emoji: '💎',
                  title: 'Geleceğe Yatırım',
                  subtitle: 'Hayallerin için tam',
                  highlight: CurrencyFormatter.format(widget.totalSaving, showDecimals: false),
                  footerText: '${widget.highlightSavingGoal} hedefin emin adımlarla büyüyor!',
                  bgGradient: [const Color(0xFF1B3B34), const Color(0xFF2C6356)],
                ),

                // Kart 4: Sonuç & Tebrik
                _buildStoryCard(
                  emoji: '🏆',
                  title: 'Harika Bir Ay Geçirdin!',
                  subtitle: 'Kullanılabilir serbest bakiyen:',
                  highlight: CurrencyFormatter.format(widget.usableMoney, showDecimals: false),
                  footerText: 'Finansal özgürlük adım adım inşa edilir. MoneyPlan yanında!',
                  bgGradient: [const Color(0xFF263C1E), const Color(0xFF456834)],
                ),
              ],
            ),
          ),

          // Alt Gezinme Butonları
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 16),
                    label: const Text('Geri', style: TextStyle(color: Colors.white70)),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _totalPages - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dreamyYellow,
                    foregroundColor: const Color(0xFF1E2818),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentPage < _totalPages - 1 ? 'İleri' : 'Harika! Kapat',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String highlight,
    String? secondaryHighlight,
    required String footerText,
    required List<Color> bgGradient,
  }) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgGradient,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 54)),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFD4E5DB), fontSize: 15),
          ),
          const SizedBox(height: 16),
          Text(
            highlight,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.dreamyYellow,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          if (secondaryHighlight != null) ...[
            const SizedBox(height: 6),
            Text(
              secondaryHighlight,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFC7DECE),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
