/// Tarih işlemleri ve görsel formatlama uzantıları.
extension DateTimeExtension on DateTime {
  /// 'GG.AA.YYYY' formatında metin döndürür.
  String get toFormattedString {
    final String dayStr = day.toString().padLeft(2, '0');
    final String monthStr = month.toString().padLeft(2, '0');
    return '$dayStr.$monthStr.$year';
  }

  /// İki tarih arasındaki gün farkını hesaplar (minimum 1 gün).
  int daysBetween(DateTime other) {
    final DateTime start = DateTime(year, month, day);
    final DateTime end = DateTime(other.year, other.month, other.day);
    final int diff = end.difference(start).inDays;
    return diff > 0 ? diff : 1;
  }
}
