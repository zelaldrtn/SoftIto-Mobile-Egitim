import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'providers/finance_state.dart';
import 'screens/home_screen.dart';
import 'utils/formatters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DateFormatter.ensureInitialized();

  // Supabase servisini başlat (Environment variables veya varsayılanlar)
  await SupabaseService.instance.initialize();

  runApp(const MoneyPlanApp());
}

class MoneyPlanApp extends StatefulWidget {
  const MoneyPlanApp({super.key});

  @override
  State<MoneyPlanApp> createState() => _MoneyPlanAppState();
}

class _MoneyPlanAppState extends State<MoneyPlanApp> {
  late final FinanceState _financeState;

  @override
  void initState() {
    super.initState();
    _financeState = FinanceState();
  }

  @override
  void dispose() {
    _financeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _financeState,
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _financeState.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: HomeScreen(state: _financeState),
        );
      },
    );
  }
}
