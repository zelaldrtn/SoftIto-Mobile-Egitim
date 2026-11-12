import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../theme/app_theme.dart';
import '../models/account_model.dart';

class AddCashAccountDialog extends StatefulWidget {
  final CashAccount? initialAccount;
  final Function(CashAccount account) onSave;

  const AddCashAccountDialog({
    super.key,
    this.initialAccount,
    required this.onSave,
  });

  @override
  State<AddCashAccountDialog> createState() => _AddCashAccountDialogState();
}

class _AddCashAccountDialogState extends State<AddCashAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;

  String _currency = AppConstants.currencyTRY;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialAccount?.accountName ?? '');
    _balanceController = TextEditingController(
      text: widget.initialAccount != null && widget.initialAccount!.balance > 0
          ? widget.initialAccount!.balance.toStringAsFixed(0)
          : '',
    );
    _currency = widget.initialAccount?.currency ?? AppConstants.currencyTRY;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final balance = double.tryParse(_balanceController.text.replaceAll(',', '.')) ?? 0.0;

    final account = CashAccount(
      id: widget.initialAccount?.id ?? 'cash_${DateTime.now().millisecondsSinceEpoch}',
      accountName: _nameController.text.trim(),
      currency: _currency,
      balance: balance,
    );

    widget.onSave(account);
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
                    child: const Icon(Icons.wallet, color: AppColors.forestPrimary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.initialAccount != null ? 'Nakit Hesabını Düzenle' : 'Yeni Nakit Hesabı',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hesap Adı',
                  hintText: 'örn. Cüzdan, Kasa, Dolar Zarfı',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Hesap adı giriniz' : null,
              ),
              const SizedBox(height: 12),

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

              TextFormField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Mevcut Bakiye (${AppConstants.currencySymbol(_currency)})',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    final n = double.tryParse(val.replaceAll(',', '.'));
                    if (n == null || n < 0) return 'Geçerli bir bakiye giriniz';
                  }
                  return null;
                },
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

