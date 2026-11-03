/// Tarih işlemleri ve görsel formatlama uzantıları.
// DateTime sınıfına özel pratik fonksiyonlar ekleyen genişletme (extension)
extension DateTimeExtension on DateTime {
  /// 'GG.AA.YYYY' formatında metin döndürür.
  String get toFormattedString {
    // tek haneli gün ve ayların başına sıfır ekleyerek standart 2 haneli gösterim sağlıyoruz
    final String dayStr = day.toString().padLeft(2, '0');
    final String monthStr = month.toString().padLeft(2, '0');
    return '$dayStr.$monthStr.$year';
  }

  /// İki tarih arasındaki gün farkını hesaplar (minimum 1 gün).
  int daysBetween(DateTime other) {
    // saat ve dakikayı sıfırlayarak sadece gün bazında net fark alıyoruz
    final DateTime start = DateTime(year, month, day);
    final DateTime end = DateTime(other.year, other.month, other.day);
    final int diff = end.difference(start).inDays;
    return diff > 0 ? diff : 1;
  }
}

