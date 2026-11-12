import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/formatters.dart';
import '../../../providers/finance_state.dart';
import '../models/account_model.dart';
import 'add_card_dialog.dart';
import 'add_cash_account_dialog.dart';
import 'debt_payment_dialog.dart';

class AccountsManagementSheet extends StatefulWidget {
  final FinanceState state;

  const AccountsManagementSheet({super.key, required this.state});

  @override
  State<AccountsManagementSheet> createState() => _AccountsManagementSheetState();
}

class _AccountsManagementSheetState extends State<AccountsManagementSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  void _openAddCard(BuildContext context, {FinancialCard? card}) {
    showDialog(
      context: context,
      builder: (_) => AddCardDialog(
        initialCard: card,
        onSave: (newCard) {
          if (card != null) {
            widget.state.updateCard(newCard);
          } else {
            widget.state.addCard(newCard);
          }
        },
      ),
    );
  }

  void _openAddCash(BuildContext context, {CashAccount? account}) {
    showDialog(
      context: context,
      builder: (_) => AddCashAccountDialog(
        initialAccount: account,
        onSave: (newAcc) {
          if (account != null) {
            widget.state.updateCashAccount(newAcc);
          } else {
            widget.state.addCashAccount(newAcc);
          }
        },
      ),
    );
  }

  void _confirmDeleteCard(FinancialCard card) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kartı Sil'),
        content: Text(
          '"${card.cardName}" kartını silmek istediğinize emin misiniz?\n\n'
          'Geçmiş işlemleriniz ve hesap kayıtlarınız kaybolmayacaktır.'
          '${card.cardType == CardType.credit && card.currentDebt > 0 ? '\n\nKalan borcunuz borçlar listesinde saklanacaktır.' : ''}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.state.deleteCard(card.id);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCash(CashAccount account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nakit Hesabını Sil'),
        content: Text(
          '"${account.accountName}" nakit hesabını silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.state.deleteCashAccount(account.id);
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.creamCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Başlık Barı
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_rounded, color: AppColors.forestPrimary),
                    SizedBox(width: 8),
                    Text(
                      'Hesaplarım ve Kartlarım',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.forestPrimary,
            indicatorColor: AppColors.forestPrimary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Kartlar (${widget.state.cards.length})'),
              Tab(text: 'Nakit Hesaplar (${widget.state.cashAccounts.length})'),
            ],
          ),

          // Tab Bar Görünümleri
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Kartlar Sekmesi
                _buildCardsTab(context, isDark),
                // 2. Nakit Hesaplar Sekmesi
                _buildCashTab(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsTab(BuildContext context, bool isDark) {
    final cards = widget.state.cards;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Banka ve Kredi Kartları', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ElevatedButton.icon(
              onPressed: () => _openAddCard(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Kart Ekle'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (cards.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Kayıtlı kart bulunmuyor.')),
          )
        else
          ...cards.map((card) {
            final isCredit = card.cardType == CardType.credit;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardAlt : Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCredit
                                  ? AppColors.dreamyLilac.withOpacity(0.15)
                                  : AppColors.forestPrimary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCredit ? Icons.credit_card : Icons.account_balance_wallet,
                              color: isCredit ? AppColors.dreamyLilac : AppColors.forestPrimary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.cardName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              Text(
                                '${card.bankName} • ${isCredit ? 'Kredi Kartı' : 'Banka Kartı'}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _openAddCard(context, card: card),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            onPressed: () => _confirmDeleteCard(card),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  if (!isCredit) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mevcut Bakiye', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(
                          CurrencyFormatter.format(card.currentBalance, currency: card.currency),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.forestPrimary,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mevcut Borç', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(
                          CurrencyFormatter.format(card.currentDebt, currency: card.currency),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE26D5C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kullanılabilir Limit', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(
                          CurrencyFormatter.format(card.availableLimit, currency: card.currency),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (card.currentDebt > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => DebtPaymentDialog(
                                state: widget.state,
                                preselectedCard: card,
                              ),
                            );
                          },
                          icon: const Icon(Icons.credit_score, size: 16),
                          label: const Text('Borç Öde'),
                        ),
                      ),
                  ],
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildCashTab(BuildContext context, bool isDark) {
    final cashAccounts = widget.state.cashAccounts;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Nakit Cüzdan & Kasalar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ElevatedButton.icon(
              onPressed: () => _openAddCash(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Hesap Ekle'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (cashAccounts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Kayıtlı nakit hesap bulunmuyor.')),
          )
        else
          ...cashAccounts.map((acc) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardAlt : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.dreamyYellow.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.wallet, color: Color(0xFF9E7C10), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            acc.accountName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          Text(
                            acc.currency,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(acc.balance, currency: acc.currency),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _openAddCash(context, account: acc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        onPressed: () => _confirmDeleteCash(acc),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
