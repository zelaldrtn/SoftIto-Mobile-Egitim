import 'package:flutter/material.dart';
import 'screens/01_layout_screen.dart';
import 'screens/02_markets_list_screen.dart';
import 'screens/03_transfer_form_screen.dart';

// uygulamanın başlangıç noktası, uygulama açılınca ilk bu fonksiyon çalışır
void main() {
  // yazdığımız kök widget'ı ekrana çizip Flutter uygulamasını başlatır
  runApp(const DtmMasteryApp());
}

// StatelessWidget: ekran çizildikten sonra kendi kendine durumu (state) değişmeyen sabit yapılar için kullanılır
class DtmMasteryApp extends StatelessWidget {
  // constructor: widget ağacında widget'ı benzersiz tanımlayan key bilgisini üst sınıfa iletir
  const DtmMasteryApp({super.key});

  @override
  // build metodu widget'ın ekrandaki görünümünü oluşturur, context ise widget'ın ağaçtaki yerini belirtir
  Widget build(BuildContext context) {
    // MaterialApp: tema, gezinme ve dil gibi temel Material Design ayarlarını barındıran çatı widget
    return MaterialApp(
      // sağ üst köşedeki debug bandını gizler
      debugShowCheckedModeBanner: false,
      title: 'DTM Flutter Mastery Studio',
      // uygulamanın genel renk, yazı ve bileşen temasını belirler
      theme: ThemeData(
        // Material 3 tasarım kurallarını aktif eder
        useMaterial3: true,
        fontFamily: 'sans-serif',
        // tek bir ana renkten uygulamanın uyumlu tüm renk paletini otomatik üretir
        colorScheme: ColorScheme.fromSeed(
          // paletin üretileceği ana tohum renk
          seedColor: const Color(0xFF6366F1),
          // temanın açık mı koyu mu olacağını belirler
          brightness: Brightness.light,
        ),
        // sayfaların varsayılan arka plan rengi
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        // tüm sayfalardaki AppBar bileşenlerinin ortak görünüm ayarları
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          // elevation: AppBar'ın altındaki gölge seviyesini belirler (0 olunca gölge kalkar)
          elevation: 0,
          // surfaceTintColor: Material 3'te kaydırma sırasında yüzeye otomatik ton eklenmesini kontrol eder
          surfaceTintColor: Colors.transparent,
          // centerTitle: başlığı yatayda ortalar
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      // uygulama açıldığında ilk ekrana gelecek olan ana sayfa
      home: const MainMasteryNavigationHub(),
    );
  }
}

// StatefulWidget: ekrandaki veriler veya kullanıcı etkileşimiyle durumu değişebilen dinamik yapılar için kullanılır
class MainMasteryNavigationHub extends StatefulWidget {
  const MainMasteryNavigationHub({super.key});

  @override
  // bu widget'ın durumunu (state) takip edecek ve yönetecek sınıfı oluşturur
  State<MainMasteryNavigationHub> createState() =>
      _MainMasteryNavigationHubState();
}

// alt tire (_) bu sınıfın sadece bu dosya içinden erişilebilir (private) olduğunu gösterir
class _MainMasteryNavigationHubState extends State<MainMasteryNavigationHub> {
  // o an seçili olan sekmenin sıra numarasını (index) hafızada tutar
  int _currentIndex = 0;

  // sekmelerde gösterilecek sayfaların listesi
  final List<Widget> _screens = const [
    LayoutScreen(),
    MarketsListScreen(),
    TransferFormScreen(),
  ];

  // sekmelere göre AppBar'da değişecek başlıklar
  final List<String> _titles = const [
    'DTM 1. Bölüm: Layout & Styling',
    'DTM 2. Bölüm: Piyasalar & Listeler',
    'DTM 3. Bölüm: Transfer & Formlar',
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel iskeletini (appBar, body, bottomNavigationBar) oluşturur
    return Scaffold(
      appBar: AppBar(
        // seçili sekmenin index'ine göre ilgili başlığı ekrana yazar
        title: Text(_titles[_currentIndex]),
        // sağ üst köşedeki butonlar ve eylemler
        actions: [
          IconButton(
            tooltip: 'Bilgi',
            icon: const Icon(Icons.info_outline, color: Color(0xFF6366F1)),
            // butona basılınca bu fonksiyon çalışır
            onPressed: () {
              // ekrana açılır diyalog kutusu (pop-up) getirir
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('DTM Flutter Mastery'),
                  content: const Text(
                    '14 ve 15 Ekim birleştirilmiş canlı ders projesidir.\n\n'
                    '• Sekme 1: Container, Row, Column, Expanded, Stack\n'
                    '• Sekme 2: GridView.builder, ListView.separated\n'
                    '• Sekme 3: Form Validasyonu, ModalBottomSheet, SnackBar',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                        // Navigator.pop: açılan diyalog penceresini kapatıp önceki ekrana döner
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Anladım')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // IndexedStack: sekmelerdeki bütün sayfaları bellekte canlı tutar, sadece seçili olanı gösterir (sayfa durumu sıfırlanmaz)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // ekranın altındaki sekmeli gezinme çubuğu
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        // kullanıcı başka bir sekmeye dokunduğunda seçilen sekmenin sıra numarasını verir
        onDestinationSelected: (index) {
          // setState: arayüze değişkenin değiştiğini bildirir ve build metodunu yeniden çalıştırarak ekranı günceller
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 2,
        // seçili olan sekme ikonunun arkasındaki vurgu rengi
        indicatorColor: const Color(0x266366F1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF6366F1)),
            label: 'Layout',
          ),
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart_outlined),
            selectedIcon:
                Icon(Icons.candlestick_chart, color: Color(0xFF6366F1)),
            label: 'Piyasalar',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon:
                Icon(Icons.account_balance_wallet, color: Color(0xFF6366F1)),
            label: 'Cüzdan/Form',
          ),
        ],
      ),
    );
  }
}

