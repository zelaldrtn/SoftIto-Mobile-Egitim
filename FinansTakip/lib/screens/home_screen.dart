import 'package:flutter/material.dart';
import '../providers/finance_state.dart';
import '../theme/app_theme.dart';
import 'tabs/overview_tab.dart';
import 'tabs/transactions_tab.dart';
import 'tabs/analytics_tab.dart';
import 'tabs/dreams_tab.dart';
import 'tabs/budgets_tab.dart';
import 'forms/add_transaction_sheet.dart';

class HomeScreen extends StatefulWidget {
  final FinanceState state;

  const HomeScreen({super.key, required this.state});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _navigateToTransactions() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _openAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTransactionSheet(
        onSave: (tx) => widget.state.addTransaction(tx),
      ),
    );
  }

  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Demo Verilerini Sıfırla'),
        content: const Text(
          'Tüm kayıtlar ilk varsayılan demo haline getirilecektir. Onaylıyor musunuz?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.state.resetAll();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tüm veriler başlangıç demo durumuna sıfırlandı.'),
                    backgroundColor: AppColors.forestPrimary,
                  ),
                );
              }
            },
            child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String get _appBarTitle {
    switch (_currentIndex) {
      case 0:
        return 'MoneyPlan';
      case 1:
        return 'İşlemlerim';
      case 2:
        return 'Analiz & Raporlar';
      case 3:
        return 'Hayallerim';
      case 4:
        return 'Bütçe & Ödemeler';
      default:
        return 'MoneyPlan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;

    if (widget.state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      OverviewTab(
        state: widget.state,
        onNavigateToTransactions: _navigateToTransactions,
      ),
      TransactionsTab(state: widget.state),
      AnalyticsTab(state: widget.state),
      DreamsTab(state: widget.state),
      BudgetsTab(state: widget.state),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.forestPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.spa_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              _appBarTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          // Tema Değiştirme Butonu (Açık / Koyu)
          IconButton(
            tooltip: isDark ? 'Açık Mod' : 'Koyu Mod',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.dreamyYellow : AppColors.forestPrimary,
            ),
            onPressed: widget.state.toggleTheme,
          ),
          // Seçenekler Menüsü
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'reset') {
                _showResetConfirmDialog();
              } else if (val == 'add') {
                _openAddTransaction(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, size: 18, color: AppColors.forestPrimary),
                    SizedBox(width: 8),
                    Text('Yeni İşlem Ekle'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Demo Verilerine Sıfırla'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.creamCard,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          indicatorColor: isDark
              ? AppColors.forestMint.withOpacity(0.2)
              : AppColors.forestSoftBg,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.forestPrimary),
              label: 'Genel Bakış',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.forestPrimary),
              label: 'İşlemler',
            ),
            NavigationDestination(
              icon: Icon(Icons.donut_large_outlined),
              selectedIcon: Icon(Icons.donut_large_rounded, color: AppColors.forestPrimary),
              label: 'Analizler',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded, color: AppColors.dreamyLilac),
              label: 'Hayallerim',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.forestPrimary),
              label: 'Bütçe',
            ),
          ],
        ),
      ),
    );
  }
}
