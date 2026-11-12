import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../core/constants/app_constants.dart';

class CurrencyFormatter {
  static final NumberFormat _tryFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );

  static final NumberFormat _tryCompactFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
  );

  static final NumberFormat _usdFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _usdCompactFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );

  static final NumberFormat _eurFormat = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 2,
  );

  static final NumberFormat _eurCompactFormat = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 0,
  );

  static String format(
    double amount, {
    bool showDecimals = true,
    String currency = AppConstants.currencyTRY,
  }) {
    try {
      final isInt = amount % 1 == 0;
      final cur = currency.toUpperCase();
      switch (cur) {
        case AppConstants.currencyUSD:
          return (!showDecimals || isInt)
              ? _usdCompactFormat.format(amount)
              : _usdFormat.format(amount);
        case AppConstants.currencyEUR:
          return (!showDecimals || isInt)
              ? _eurCompactFormat.format(amount)
              : _eurFormat.format(amount);
        case AppConstants.currencyTRY:
        default:
          return (!showDecimals || isInt)
              ? _tryCompactFormat.format(amount)
              : _tryFormat.format(amount);
      }
    } catch (_) {
      final sym = AppConstants.currencySymbol(currency);
      return '$sym${amount.toStringAsFixed(showDecimals ? 2 : 0)}';
    }
  }

  static String formatPlain(double amount) {
    try {
      final format = NumberFormat("#,##0.00", "tr_TR");
      return format.format(amount);
    } catch (_) {
      return amount.toStringAsFixed(2);
    }
  }
}

class DateFormatter {
  static bool _isLocaleInitialized = false;

  static Future<void> ensureInitialized() async {
    if (!_isLocaleInitialized) {
      await initializeDateFormatting('tr_TR', null);
      _isLocaleInitialized = true;
    }
  }

  static const List<String> _turkishMonths = [
    '',
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];

  static const List<String> _turkishMonthsShort = [
    '',
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara'
  ];

  static String formatShort(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Bugün';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Dün';
    }

    if (date.month >= 1 && date.month <= 12) {
      return '${date.day} ${_turkishMonthsShort[date.month]}';
    }
    return '${date.day}.${date.month}';
  }

  static String formatFull(DateTime date) {
    if (date.month >= 1 && date.month <= 12) {
      return '${date.day} ${_turkishMonths[date.month]} ${date.year}';
    }
    return '${date.day}.${date.month}.${date.year}';
  }

  static String formatMonthYear(DateTime date) {
    if (date.month >= 1 && date.month <= 12) {
      return '${_turkishMonths[date.month]} ${date.year}';
    }
    return '${date.month}/${date.year}';
  }
}
