import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../theme/app_theme.dart';
import '../models/account_model.dart';

class AddCardDialog extends StatefulWidget {
  final FinancialCard? initialCard;
  final Function(FinancialCard card) onSave;

  const AddCardDialog({
    super.key,
    this.initialCard,
    required this.onSave,
  });

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bankController;
  late final TextEditingController _balanceController;
  late final TextEditingController _limitController;
  late final TextEditingController _debtController;

  CardType _cardType = CardType.debit;
  String _currency = AppConstants.currencyTRY;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCard?.cardName ?? '');
    _bankController = TextEditingController(text: widget.initialCard?.bankName ?? '');
    _balanceController = TextEditingController(
      text: widget.initialCard != null && widget.initialCard!.currentBalance > 0
          ? widget.initialCard!.currentBalance.toStringAsFixed(0)
          : '',
    );
    _limitController = TextEditingController(
      text: widget.initialCard != null && widget.initialCard!.creditLimit > 0
          ? widget.initialCard!.creditLimit.toStringAsFixed(0)
          : '',
    );
    _debtController = TextEditingController(
      text: widget.initialCard != null && widget.initialCard!.currentDebt > 0
          ? widget.initialCard!.currentDebt.toStringAsFixed(0)
          : '',
    );
    _cardType = widget.initialCard?.cardType ?? CardType.debit;
    _currency = widget.initialCard?.currency ?? AppConstants.currencyTRY;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _balanceController.dispose();
    _limitController.dispose();
    _debtController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final balance = double.tryParse(_balanceController.text.replaceAll(',', '.')) ?? 0.0;
    final limit = double.tryParse(_limitController.text.replaceAll(',', '.')) ?? 0.0;
    final debt = double.tryParse(_debtController.text.replaceAll(',', '.')) ?? 0.0;

    final card = FinancialCard(
      id: widget.initialCard?.id ?? 'card_${DateTime.now().millisecondsSinceEpoch}',
      cardName: _nameController.text.trim(),
      bankName: _bankController.text.trim(),
      cardType: _cardType,
      currency: _currency,
      openingBalance: balance,
      currentBalance: _cardType == CardType.debit ? balance : 0.0,
      creditLimit: _cardType == CardType.credit ? limit : 0.0,
      currentDebt: _cardType == CardType.credit ? debt : 0.0,
    );

    widget.onSave(card);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const Icon(Icons.credit_card, color: AppColors.forestPrimary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.initialCard != null ? 'Kartı Düzenle' : 'Yeni Kart Ekle',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Kart Türü Seçimi (Banka Kartı / Kredi Kartı)
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Banka Kartı')),
                      selected: _cardType == CardType.debit,
                      onSelected: (val) {
                        if (val) setState(() => _cardType = CardType.debit);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Kredi Kartı')),
                      selected: _cardType == CardType.credit,
                      onSelected: (val) {
                        if (val) setState(() => _cardType = CardType.credit);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Kart Adı
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Kart Adı',
                  hintText: 'örn. Maaş Kartım, Bonus',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Kart adı giriniz' : null,
              ),
              const SizedBox(height: 12),

              // Banka Adı
              TextFormField(
                controller: _bankController,
                decoration: const InputDecoration(
                  labelText: 'Banka Adı',
                  hintText: 'örn. Garanti, İş Bankası',
                  prefixIcon: Icon(Icons.account_balance_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Banka adı giriniz' : null,
              ),
              const SizedBox(height: 12),

              // Para Birimi Seçimi
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _currency,
                decoration: const InputDecoration(
                  labelText: 'Para Birimi',
                  prefixIcon: Icon(Icons.currency_exchange_outlined),
                ),
                items: AppConstants.supportedCurrencies.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(
                      '$c (${AppConstants.currencySymbol(c)})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _currency = val);
                },
              ),
              const SizedBox(height: 12),

              // Banka Kartı İçin: Açılış / Mevcut Bakiye
              if (_cardType == CardType.debit) ...[
                TextFormField(
                  controller: _balanceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Açılış Bakiyesi (${AppConstants.currencySymbol(_currency)})',
                    hintText: '0.00',
                    prefixIcon: const Icon(Icons.wallet),
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final n = double.tryParse(val.replaceAll(',', '.'));
                      if (n == null || n < 0) return 'Geçerli bir bakiye giriniz';
                    }
                    return null;
                  },
                ),
              ],

              // Kredi Kartı İçin: Toplam Limit ve Mevcut Borç
              if (_cardType == CardType.credit) ...[
                TextFormField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Toplam Limit (${AppConstants.currencySymbol(_currency)})',
                    hintText: 'örn. 25000',
                    prefixIcon: const Icon(Icons.speed),
                  ),
                  validator: (val) {
                    final n = double.tryParse(val?.replaceAll(',', '.') ?? '');
                    if (n == null || n <= 0) return 'Geçerli bir limit giriniz';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _debtController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Mevcut Borç (${AppConstants.currencySymbol(_currency)})',
                    hintText: 'örn. 4500 (Borç yoksa 0)',
                    prefixIcon: const Icon(Icons.money_off),
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final n = double.tryParse(val.replaceAll(',', '.'));
                      if (n == null || n < 0) return 'Geçerli bir borç tutarı giriniz';
                    }
                    return null;
                  },
                ),
              ],

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
                    child: const Text('Kaydet'),
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
