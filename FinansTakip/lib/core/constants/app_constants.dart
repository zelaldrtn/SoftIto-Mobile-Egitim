class AppConstants {
  static const String appName = 'Money Plan';

  // Supabase Configuration Defaults
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vtpxswnecyypweeydhmy.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Supported Currencies
  static const String currencyTRY = 'TRY';
  static const String currencyUSD = 'USD';
  static const String currencyEUR = 'EUR';

  static const List<String> supportedCurrencies = [
    currencyTRY,
    currencyUSD,
    currencyEUR,
  ];

  static String currencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case currencyUSD:
        return '\$';
      case currencyEUR:
        return '€';
      case currencyTRY:
      default:
        return '₺';
    }
  }

  // Storage Keys
  static const String keyPrimaryCurrency = 'moneyplan_primary_currency';
  static const String keyThemeMode = 'moneyplan_theme_mode';
  static const String keyNotifyBudget = 'moneyplan_notify_budget';
  static const String keyNotifyRecurring = 'moneyplan_notify_recurring';
  static const String keyNotifySavings = 'moneyplan_notify_savings';
  static const String keyExchangeRates = 'moneyplan_exchange_rates';
}

