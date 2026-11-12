import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/exchange_rate_service.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/formatters.dart';
import '../../../providers/finance_state.dart';
import '../models/account_model.dart';

class DebtPaymentDialog extends StatefulWidget {
  final FinanceState state;
  final FinancialCard? preselectedCard;

  const DebtPaymentDialog({
    super.key,
    required this.state,
    this.preselectedCard,
  });

  @override
  State<DebtPaymentDialog> createState() => _DebtPaymentDialogState();
}

class _DebtPaymentDialogState extends State<DebtPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  FinancialCard? _selectedCreditCard;
  String _sourceType = 'debit_card'; // 'debit_card' veya 'cash_account'
  String? _selectedSourceCardId;
  String? _selectedSourceCashId;

  @override
  void initState() {
    super.initState();
    final creditCards = widget.state.cards.where((c) => c.cardType == CardType.credit).toList();
    if (widget.preselectedCard != null && widget.preselectedCard!.cardType == CardType.credit) {
      _selectedCreditCard = widget.preselectedCard;
    } else if (creditCards.isNotEmpty) {
      _selectedCreditCard = creditCards.first;
    }

    // Varsayılan kaynak hesap seçimi
    final debitCards = widget.state.cards.where((c) => c.cardType == CardType.debit).toList();
    if (debitCards.isNotEmpty) {
      _selectedSourceCardId = debitCards.first.id;
      _sourceType = 'debit_card';
    } else if (widget.state.cashAccounts.isNotEmpty) {
      _selectedSourceCashId = widget.state.cashAccounts.first.id;
      _sourceType = 'cash_account';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCreditCard == null) return;

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    if (amount <= 0) return;

    try {
      await widget.state.payCreditCardDebt(
        creditCardId: _selectedCreditCard!.id,
        paidAmount: amount,
        sourceCardId: _sourceType == 'debit_card' ? _selectedSourceCardId : null,
        sourceCashAccountId: _sourceType == 'cash_account' ? _selectedSourceCashId : null,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_selectedCreditCard!.cardName} borcu için ${CurrencyFormatter.format(amount, currency: _selectedCreditCard!.currency)} ödeme yapıldı.',
            ),
            backgroundColor: AppColors.forestPrimary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditCards = widget.state.cards.where((c) => c.cardType == CardType.credit).toList();
    final debitCards = widget.state.cards.where((c) => c.cardType == CardType.debit).toList();
    final cashAccounts = widget.state.cashAccounts;

    if (creditCards.isEmpty) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Kredi Kartı Bulunamadı'),
        content: const Text('Borç ödemesi yapmak için önce bir kredi kartı eklemelisiniz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
        ],
      );
    }

    final card = _selectedCreditCard ?? creditCards.first;

    // Kaynak hesaba göre kur hesabı
    String sourceCurrency = card.currency;
    if (_sourceType == 'debit_card' && _selectedSourceCardId != null) {
      final src = debitCards.firstWhere((c) => c.id == _selectedSourceCardId, orElse: () => debitCards.first);
      sourceCurrency = src.currency;
    } else if (_sourceType == 'cash_account' && _selectedSourceCashId != null) {
      final src = cashAccounts.firstWhere((a) => a.id == _selectedSourceCashId, orElse: () => cashAccounts.first);
      sourceCurrency = src.currency;
    }

    final isDifferentCurrency = sourceCurrency != card.currency;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.forestPrimary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.credit_score_rounded, color: AppColors.forestPrimary),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Kredi Kartı Borç Ödeme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ödenecek Kredi Kartı Seçimi
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: card.id,
                decoration: const InputDecoration(
                  labelText: 'Borcu Ödenecek Kart',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                items: creditCards.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(
                      '${c.cardName} (${c.bankName})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCreditCard = creditCards.firstWhere((c) => c.id == val);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Kart Borç Bilgi Kartı
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.forestSoftBg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.forestMint.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mevcut Borç', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          CurrencyFormatter.format(card.currentDebt, currency: card.currency),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFE26D5C)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Kullanılabilir Limit', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          CurrencyFormatter.format(card.availableLimit, currency: card.currency),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.forestPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ödeme Kaynağı Türü
              const Text('Ödeme Kaynağı:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Banka Kartı')),
                      selected: _sourceType == 'debit_card',
                      onSelected: (val) {
                        if (val && debitCards.isNotEmpty) {
                          setState(() {
                            _sourceType = 'debit_card';
                            _selectedSourceCardId = debitCards.first.id;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Nakit Hesabı')),
                      selected: _sourceType == 'cash_account',
                      onSelected: (val) {
                        if (val && cashAccounts.isNotEmpty) {
                          setState(() {
                            _sourceType = 'cash_account';
                            _selectedSourceCashId = cashAccounts.first.id;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Kaynak Hesap Seçici
              if (_sourceType == 'debit_card' && debitCards.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedSourceCardId,
                  decoration: const InputDecoration(
                    labelText: 'Ödeme Yapılacak Banka Kartı',
                    prefixIcon: Icon(Icons.payment),
                  ),
                  items: debitCards.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text(
                        '${c.cardName} (${CurrencyFormatter.format(c.currentBalance, currency: c.currency)})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedSourceCardId = val),
                ),
              ] else if (_sourceType == 'cash_account' && cashAccounts.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedSourceCashId,
                  decoration: const InputDecoration(
                    labelText: 'Ödeme Yapılacak Nakit Hesabı',
                    prefixIcon: Icon(Icons.wallet),
                  ),
                  items: cashAccounts.map((a) {
                    return DropdownMenuItem(
                      value: a.id,
                      child: Text(
                        '${a.accountName} (${CurrencyFormatter.format(a.balance, currency: a.currency)})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedSourceCashId = val),
                ),
              ],
              const SizedBox(height: 12),

              // Ödenecek Tutar
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Ödenecek Tutar (${AppConstants.currencySymbol(card.currency)})',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixIcon: TextButton(
                    onPressed: () {
                      _amountController.text = card.currentDebt.toStringAsFixed(0);
                    },
                    child: const Text('Tüm Borç'),
                  ),
                ),
                validator: (val) {
                  final n = double.tryParse(val?.replaceAll(',', '.') ?? '');
                  if (n == null || n <= 0) return 'Geçerli bir tutar giriniz';
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              // Kur Dönüşüm Bilgisi
              if (isDifferentCurrency) ...[
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  final amt = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
                  final converted = ExchangeRateService.instance.convert(
                    amt,
                    from: card.currency,
                    to: sourceCurrency,
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.dreamyLilacLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Döviz Dönüşümü: ${CurrencyFormatter.format(amt, currency: card.currency)} = ${CurrencyFormatter.format(converted, currency: sourceCurrency)} (${ExchangeRateService.instance.formatRateInfo(from: card.currency, to: sourceCurrency)})',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4C2775)),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama (İsteğe bağlı)',
                  hintText: 'örn. Asgari ödeme, dönem borcu',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Vazgeç'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Borcu Öde'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

