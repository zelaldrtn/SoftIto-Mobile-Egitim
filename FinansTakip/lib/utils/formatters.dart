import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
  );

  static String format(double amount, {bool showDecimals = true}) {
    try {
      if (!showDecimals || amount % 1 == 0) {
        return _compactCurrencyFormat.format(amount);
      }
      return _currencyFormat.format(amount);
    } catch (_) {
      return '₺${amount.toStringAsFixed(showDecimals ? 2 : 0)}';
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
