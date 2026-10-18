import 'package:flutter/material.dart';
import '../models/transation_model.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.50;

  final List<TransactionItem> _history = [
    const TransactionItem(
      id: 'tx_init_1',
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'Bugün, 11:30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: 'tx_init_2',
      title: 'Merve Demir',
      category: 'Hızlı Transfer',
      date: 'Dün, 15:45',
      amount: 2400.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
  ];

  void _openTransferModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return _TransferBottomSheet(
          currentBalance: _balance,
          onTransferConfirmed: (amount, recipient) {
            setState(() {
              _balance -= amount;
              _history.insert(
                0,
                TransactionItem(
                  id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                  title: recipient,
                  category: 'Hızlı Transfer',
                  date: 'Şimdi',
                  amount: amount,
                  isExpense: true,
                  icon: Icons.send_rounded,
                ),
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '₺${amount.toStringAsFixed(2)} tutarındaki transfer $recipient kişisine başarıyla gönderildi!',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x05000000),
                    offset: Offset(0, 4),
                    blurRadius: 10),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kullanılabilir Bakiye',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Text(
                      '₺${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _openTransferModal,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Transfer Yap'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.security, color: Color(0xFF4F46E5), size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Form girişlerinde GlobalKey<FormState> ve TextEditingController kullanılmıştır. Geçersiz tutar veya bakiye yetersizliğinde kırmızı uyarı verir.',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF3730A3), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Transfer Geçmişi (Dinamik Liste)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final item = _history[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x1FEF4444),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_upward,
                      color: Color(0xFFEF4444), size: 20),
                ),
                title: Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('${item.category} • ${item.date}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF64748B))),
                trailing: Text(
                  '-₺${item.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFFEF4444)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TransferBottomSheet extends StatefulWidget {
  final double currentBalance;
  final Function(double amount, String recipient) onTransferConfirmed;

  const _TransferBottomSheet({
    required this.currentBalance,
    required this.onTransferConfirmed,
  });

  @override
  State<_TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<_TransferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _recipientController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.trim());
      final recipient = _recipientController.text.trim();
      Navigator.pop(context);
      widget.onTransferConfirmed(amount, recipient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Hızlı Para Transferi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Mevcut Bakiyeniz: ₺${widget.currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Alıcı Adı veya Cüzdan Adresi',
                hintText: 'Ör: Ahmet Yılmaz',
                prefixIcon: const Icon(Icons.person_outline),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (v) {
                if (v == null || v.trim().length < 3) {
                  return 'En az 3 karakterli geçerli alıcı girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Gönderilecek Tutar (₺)',
                hintText: '0.00',
                prefixIcon: const Icon(Icons.payments_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Lütfen bir tutar girin';
                }
                final val = double.tryParse(v.trim());
                if (val == null || val <= 0) {
                  return 'Geçerli bir pozitif tutar girin';
                }
                if (val > widget.currentBalance) {
                  return 'Yetersiz bakiye!';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _submit,
                child: const Text('Transferi Gerçekleştir',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}