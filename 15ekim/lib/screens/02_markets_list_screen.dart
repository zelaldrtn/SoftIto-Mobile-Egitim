import 'package:flutter/material.dart';
import '../../test/lib/models/asset_model.dart';
import '../../test/lib/models/transation_model.dart';

class MarketsListScreen extends StatelessWidget {
  const MarketsListScreen({super.key});

  static const List<Asset> assets = [
    Asset(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 67420.50,
        change24h: 4.25,
        balance: 0.428),
    Asset(
        symbol: 'ETH',
        name: 'Ethereum',
        price: 3520.10,
        change24h: -1.80,
        balance: 4.250),
    Asset(
        symbol: 'SOL',
        name: 'Solana',
        price: 154.20,
        change24h: 12.40,
        balance: 85.00),
    Asset(
        symbol: 'AVAX',
        name: 'Avalanche',
        price: 28.40,
        change24h: 0.50,
        balance: 340.00),
  ];

  static const List<TransactionItem> transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'Apple Store Zorlu Center',
      category: 'Teknoloji / Donanım',
      date: 'Bugün, 14:20',
      amount: 64999.00,
      isExpense: true,
      icon: Icons.laptop_mac,
    ),
    TransactionItem(
      id: 'tx_2',
      title: 'Yazılım Danışmanlık Hakediş',
      category: 'Kurumsal Gelir',
      date: 'Dün, 09:00',
      amount: 125000.00,
      isExpense: false,
      icon: Icons.account_balance,
    ),
    TransactionItem(
      id: 'tx_3',
      title: 'Starbucks Coffee Kadıköy',
      category: 'Yeme & İçme',
      date: '13 Ekim, 16:45',
      amount: 185.50,
      isExpense: true,
      icon: Icons.coffee,
    ),
    TransactionItem(
      id: 'tx_4',
      title: 'Temettü / Hisse Dağıtımı',
      category: 'Yatırım Getirisi',
      date: '12 Ekim, 11:30',
      amount: 3420.75,
      isExpense: false,
      icon: Icons.trending_up,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Canlı Portföy Varlıkları (GridView)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.35,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final a = assets[index];
              final isPositive = a.change24h >= 0;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x05000000),
                        offset: Offset(0, 4),
                        blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a.symbol,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          '${isPositive ? '+' : ''}${a.change24h}%',
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${a.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A)),
                    ),
                    Text('${a.balance} ${a.symbol}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Son İşlemler (ListView.separated)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 0.8,
              indent: 72,
              color: Color(0xFFF1F5F9),
            ),
            itemBuilder: (context, index) {
              final t = transactions[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: t.isExpense
                        ? const Color(0x1FEF4444)
                        : const Color(0x1F10B981),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    t.icon,
                    color: t.isExpense
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF10B981),
                    size: 22,
                  ),
                ),
                title: Text(t.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.5)),
                subtitle: Text('${t.category} • ${t.date}',
                    style: const TextStyle(
                        fontSize: 11.5, color: Color(0xFF64748B))),
                trailing: Text(
                  '${t.isExpense ? '-' : '+'}₺${t.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: t.isExpense
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF10B981),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
