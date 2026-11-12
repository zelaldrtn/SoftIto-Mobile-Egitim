import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/saving_goal_model.dart';
import '../../features/accounts/models/account_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';

class DepositGoalDialog extends StatefulWidget {
  final SavingGoalModel goal;
  final FinanceState? state;
  final Function(double amount, String? note, {String? sourceCardId, String? sourceCashAccountId}) onDeposit;

  const DepositGoalDialog({
    super.key,
    required this.goal,
    this.state,
    required this.onDeposit,
  });

  @override
  State<DepositGoalDialog> createState() => _DepositGoalDialogState();
}

class _DepositGoalDialogState extends State<DepositGoalDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final List<double> _quickAmounts = [500, 1000, 2500, 5000];

  bool _deductFromAccount = false;
  String? _selectedCardId;
  String? _selectedCashAccountId;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      final debitCards = widget.state!.cards.where((c) => c.cardType == CardType.debit).toList();
      if (debitCards.isNotEmpty) {
        _selectedCardId = debitCards.first.id;
      } else if (widget.state!.cashAccounts.isNotEmpty) {
        _selectedCashAccountId = widget.state!.cashAccounts.first.id;
      }
    }
  }

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

    widget.onDeposit(
      amt,
      _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      sourceCardId: _deductFromAccount ? _selectedCardId : null,
      sourceCashAccountId: _deductFromAccount ? _selectedCashAccountId : null,
    );
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${CurrencyFormatter.format(amt, currency: widget.goal.currency)} ${widget.goal.title} hedefine eklendi! 🎉',
        ),
        backgroundColor: AppColors.forestPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final debitCards = widget.state?.cards.where((c) => c.cardType == CardType.debit).toList() ?? [];
    final cashAccounts = widget.state?.cashAccounts ?? [];

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
            'Kalan: ${CurrencyFormatter.format(widget.goal.remainingAmount, currency: widget.goal.currency)}',
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
                      '+${AppConstants.currencySymbol(widget.goal.currency)}${val.toStringAsFixed(0)}',
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
              decoration: InputDecoration(
                labelText: 'Eklenecek Tutar (${AppConstants.currencySymbol(widget.goal.currency)})',
                hintText: '1000',
                prefixIcon: const Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 14),

            // Seçenek: Hesaptan Düşerek mi eklenecek?
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hesaptan Düşerek Ekle', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text('Banka kartı veya nakit hesabı bakiyesinden eksilir', style: TextStyle(fontSize: 11)),
              value: _deductFromAccount,
              activeColor: AppColors.forestPrimary,
              onChanged: (val) => setState(() => _deductFromAccount = val),
            ),

            if (_deductFromAccount) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCardId != null
                    ? 'card_$_selectedCardId'
                    : (_selectedCashAccountId != null ? 'cash_$_selectedCashAccountId' : null),
                decoration: const InputDecoration(
                  labelText: 'Kaynak Hesap',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: [
                  ...debitCards.map((c) => DropdownMenuItem(
                        value: 'card_${c.id}',
                        child: Text('${c.cardName} (${CurrencyFormatter.format(c.currentBalance, currency: c.currency)})'),
                      )),
                  ...cashAccounts.map((a) => DropdownMenuItem(
                        value: 'cash_${a.id}',
                        child: Text('${a.accountName} (${CurrencyFormatter.format(a.balance, currency: a.currency)})'),
                      )),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      if (val.startsWith('card_')) {
                        _selectedCardId = val.substring(5);
                        _selectedCashAccountId = null;
                      } else {
                        _selectedCashAccountId = val.substring(5);
                        _selectedCardId = null;
                      }
                    });
                  }
                },
              ),
            ],

            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Not (İsteğe bağlı)',
                hintText: 'Hedef birikim notu...',
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
