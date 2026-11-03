import 'package:flutter/material.dart';
import '../../test/lib/models/asset_model.dart';
import '../../test/lib/models/transation_model.dart';

// StatelessWidget: durumu değişmeyen, yalnızca gelen veriyi ekranda sergileyen sabit sayfa
class MarketsListScreen extends StatelessWidget {
  const MarketsListScreen({super.key});

  // static const: bellekte tek bir defa oluşturulan, içeriği değiştirilemeyen sabit örnek veri listesi
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
    // SingleChildScrollView: içerik ekrana sığmadığında dikeyde kaydırılabilmesini sağlar
    return SingleChildScrollView(
      // BouncingScrollPhysics: iOS tarzı yaylanma efektli kaydırma davranışı
      physics: const BouncingScrollPhysics(),
      // EdgeInsets: widget çevresine iç veya dış boşluk vermeyi sağlar
      padding: const EdgeInsets.symmetric(vertical: 16),
      // Column: altındaki widget'ları dikey eksende alt alta dizer
      child: Column(
        // CrossAxisAlignment: ana eksene dik olan yatay eksendeki hizalamayı belirler (sola yaslar)
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
          // GridView.builder: elemanları ızgara şeklinde performanslı listeleyen widget (yalnızca ekrandakileri çizer)
          GridView.builder(
            // shrinkWrap: GridView'in sonsuz uzamasını engelleyip yalnızca elemanları kadar yer kaplamasını sağlar
            shrinkWrap: true,
            // NeverScrollableScrollPhysics: sayfanın kendi kaydırması olduğu için ızgaranın ayrıca kaymasını engeller
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // SliverGridDelegateWithFixedCrossAxisCount: ızgara sütun sayısını ve kartların boyut oranlarını belirler
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: yan yana kaç sütun olacağını belirler
              crossAxisCount: 2,
              // childAspectRatio: kartların genişliğinin yüksekliğine oranı
              childAspectRatio: 1.35,
              // crossAxisSpacing: sütunlar arasındaki yatay boşluk
              crossAxisSpacing: 12,
              // mainAxisSpacing: satırlar arasındaki dikey boşluk
              mainAxisSpacing: 12,
            ),
            // itemCount: ızgarada toplam kaç kart üretileceğini belirtir
            itemCount: assets.length,
            // itemBuilder: her bir kart için çalışıp o sıradaki veriyi widget'a dönüştürür
            itemBuilder: (context, index) {
              // o anki sıraya denk gelen varlık modelini değişkene alır
              final a = assets[index];
              final isPositive = a.change24h >= 0;
              // Container: kutu görünümü oluşturur
              return Container(
                padding: const EdgeInsets.all(14),
                // BoxDecoration: kutuya arka plan rengi, kenarlık, köşe yuvarlama ve gölge ekler
                decoration: BoxDecoration(
                  color: Colors.white,
                  // BorderRadius: kutunun köşelerini yuvarlatır
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  // BoxShadow: kutunun altına gölge efekti verir
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
                    // Row: elemanları yatayda yan yana dizer
                    Row(
                      // MainAxisAlignment: ana eksendeki hizalamayı belirler (burada elemanları iki uca yaslar)
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
                      // toStringAsFixed: sayıyı virgülden sonra 2 basamak olacak şekilde metne çevirir
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
          // SizedBox: dikeyde sabit boşluk bırakır
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
          // ListView.separated: elemanların arasına otomatik ayırıcı çizgi ekleyen performanslı liste yapısı
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            // separatorBuilder: her elemanın arasına konulacak ayırıcı çizgiyi (Divider) oluşturur
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 0.8,
              indent: 72,
              color: Color(0xFFF1F5F9),
            ),
            itemBuilder: (context, index) {
              final t = transactions[index];
              // ListTile: liste satırları için başlık, alt başlık ve simge alanları hazır gelen Material bileşeni
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                // leading: satırın en solundaki simge veya görsel alanı
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
                // title: ana başlık metni
                title: Text(t.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.5)),
                // subtitle: başlığın altındaki açıklama metni
                subtitle: Text('${t.category} • ${t.date}',
                    style: const TextStyle(
                        fontSize: 11.5, color: Color(0xFF64748B))),
                // trailing: satırın en sağındaki alan
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

