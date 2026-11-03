import 'package:flutter/material.dart';
import '../../test/lib/models/transation_model.dart';

// StatefulWidget: kullanıcı etkileşimi ve form girişleriyle durumu değişebilen ekran yapısı
class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  // kullanıcının anlık bakiye bilgisini tutan değişken
  double _balance = 148950.50;

  // yapılan transferlerin geçmişini tutan dinamik liste
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

  // transfer formunu alttan açılır pencere (bottom sheet) olarak açan fonksiyon
  void _openTransferModal() {
    // showModalBottomSheet: ekranın altından yukarı doğru açılan modal sayfa gösterir
    showModalBottomSheet(
      context: context,
      // isScrollControlled: klavye açıldığında içeriğin yukarı kaymasını ve modalın tam yükseklik alabilmesini sağlar
      isScrollControlled: true,
      backgroundColor: Colors.white,
      // RoundedRectangleBorder: modal pencerenin üst köşelerini yuvarlatır
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return _TransferBottomSheet(
          currentBalance: _balance,
          // modal içinden gelen transfer bilgilerini yakalayan callback fonksiyonu
          onTransferConfirmed: (amount, recipient) {
            // setState: bakiyeyi günceller, yeni işlemi listeye ekler ve ekranı yeniler
            setState(() {
              _balance -= amount;
              // insert: yeni transferi listenin en başına (0. sıraya) ekler
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

            // ScaffoldMessenger.of(context).showSnackBar: işlem sonucunu kullanıcıya bildiren alt bildirim çubuğu gösterir
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF10B981),
                // SnackBarBehavior.floating: bildirimin alta yapışmak yerine havada asılı durmasını sağlar
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
    // SingleChildScrollView: içerik ekrana sığmadığında dikeyde kaydırılabilmesini sağlar
    return SingleChildScrollView(
      // BouncingScrollPhysics: iOS tarzı yaylanma efektli kaydırma davranışı
      physics: const BouncingScrollPhysics(),
      // EdgeInsets: widget kenarlarından boşluk bırakmayı sağlar
      padding: const EdgeInsets.all(20),
      // Column: altındaki widget'ları dikey eksende alt alta dizer
      child: Column(
        // CrossAxisAlignment: ana eksene dik olan yatay eksendeki hizalamayı belirler (sola yaslar)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container: boyut, dolgu, kenarlık ve gölge gibi özellikleri tek kutuda toplar
          Container(
            padding: const EdgeInsets.all(20),
            // BoxDecoration: kutuya köşe yuvarlama, kenarlık rengi ve gölge verir
            decoration: BoxDecoration(
              color: Colors.white,
              // BorderRadius: kutunun köşelerini yuvarlatır
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              // BoxShadow: kutunun altına gölge efekti verir
              boxShadow: const [
                BoxShadow(
                    color: Color(0x05000000),
                    offset: Offset(0, 4),
                    blurRadius: 10),
              ],
            ),
            // Row: elemanları yatayda yan yana dizer
            child: Row(
              // MainAxisAlignment: ana eksendeki hizalamayı belirler (elemanları iki uca yaslar)
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
                // ElevatedButton.icon: simgeli ve arka plan rengi olan yükseltilmiş buton
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
          // SizedBox: araya sabit dikey boşluk bırakır
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
                // Expanded: Row içinde kalan boş alanın tamamını doldurarak metnin taşmasını önler
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
          // ListView.separated: aralarına otomatik ayırıcı çizgi ekleyen performanslı liste yapısı
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length,
            // separatorBuilder: her eleman arasına konulacak ayırıcı çizgiyi belirler
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final item = _history[index];
              // ListTile: başlık, alt başlık ve simge alanları hazır gelen liste satırı
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

// transfer formunu içeren alt modal pencere widget'ı
class _TransferBottomSheet extends StatefulWidget {
  // üst sayfadan aktarılan mevcut bakiye bilgisi
  final double currentBalance;
  // transfer onaylandığında sonucu üst widget'a ileten geri çağırma (callback) fonksiyonu
  final Function(double amount, String recipient) onTransferConfirmed;

  // required: widget oluşturulurken bu parametrelerin girilmesini zorunlu kılar
  const _TransferBottomSheet({
    required this.currentBalance,
    required this.onTransferConfirmed,
  });

  @override
  State<_TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<_TransferBottomSheet> {
  // GlobalKey<FormState>: formun durumunu yönetmek ve doğrulama (validation) işlemlerini tetiklemek için kullanılan benzersiz anahtar
  final _formKey = GlobalKey<FormState>();
  // late: değişkenin hemen değil, initState içinde ilk kullanım öncesinde başlatılacağını belirtir
  // TextEditingController: metin kutusuna girilen veriyi okumak ve kontrol etmek için kullanılır
  late final TextEditingController _recipientController;
  late final TextEditingController _amountController;

  @override
  // initState: widget ekrana ilk çizildiğinde sadece bir kez çalışır, başlangıç ayarları burada yapılır
  void initState() {
    super.initState();
    _recipientController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  // dispose: widget ekrandan kaldırıldığında belleği temizlemek için controller'ları kapatır (bellek sızıntısını önler)
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // transfer formunu doğrulayıp işlemi başlatan fonksiyon
  void _submit() {
    // validate(): formdaki tüm kutuların kurallarını kontrol eder, hata yoksa true döner
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.trim());
      final recipient = _recipientController.text.trim();
      // Navigator.pop: modal pencereyi kapatıp ana ekrana döner
      Navigator.pop(context);
      // widget.: State sınıfı içinden üstteki StatefulWidget'ın parametrelerine erişip callback fonksiyonunu çalıştırır
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
        // MediaQuery.of(context).viewInsets.bottom: klavye açıldığında klavyenin yüksekliğini alarak formun klavye arkasında kalmasını engeller
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      // Form: altındaki form alanlarını tek bir çatı altında toplayıp ortak doğrulamayı sağlar
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
            // TextFormField: kullanıcıdan metin girişi almak ve doğrulama kuralları (validator) belirlemek için kullanılır
            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Alıcı Adı veya Cüzdan Adresi',
                hintText: 'Ör: Ahmet Yılmaz',
                prefixIcon: const Icon(Icons.person_outline),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              // validator: girilen değeri kontrol eder; kurala uymuyorsa hata mesajı, sorun yoksa null döner
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
              // keyboardType: klavyeyi sadece sayı ve ondalık girişine uygun şekilde açar
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

