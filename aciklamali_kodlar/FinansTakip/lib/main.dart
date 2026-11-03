import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'providers/finance_state.dart';
import 'screens/home_screen.dart';

import 'utils/formatters.dart';

// uygulama başlangıç noktası; asenkron yerelleştirme işlemleri için async olarak tanımlandı
void main() async {
  // Flutter motoru ile widget bağlarını güvenceye alıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // Türkçe tarih/saat formatlamalarını (intl paketi) hazır hale getiriyoruz
  await DateFormatter.ensureInitialized();
  runApp(const MoneyPlanApp());
}

// uygulamanın kök widget'ı
class MoneyPlanApp extends StatefulWidget {
  const MoneyPlanApp({super.key});

  @override
  State<MoneyPlanApp> createState() => _MoneyPlanAppState();
}

class _MoneyPlanAppState extends State<MoneyPlanApp> {
  // uygulamanın tüm finansal durumunu yöneten merkezi state nesnesi
  late final FinanceState _financeState;

  @override
  void initState() {
    super.initState();
    _financeState = FinanceState();
  }

  @override
  void dispose() {
    // bellek sızıntısını önlemek için state nesnesini serbest bırakıyoruz
    _financeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder ile FinanceState'teki tüm notifyListeners() çağrılarını dinliyoruz
    return ListenableBuilder(
      listenable: _financeState,
      builder: (context, _) {
        return MaterialApp(
          title: 'MoneyPlan',
          // sağ üst köşedeki hata ayıklama bandını kapatır
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // aktif temayı kullanıcının seçtiği duruma göre ayarlar
          themeMode: _financeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: HomeScreen(state: _financeState),
        );
      },
    );
  }
}

