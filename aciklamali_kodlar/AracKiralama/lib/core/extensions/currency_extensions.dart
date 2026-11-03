/// Para birimi ve sayı formatlama uzantıları.
// num türündeki tüm sayılara (int ve double) doğrudan .toCurrencyString diyebilmemizi sağlayan extension
extension CurrencyExtension on num {
  /// '1.500 ₺' veya '2.250 ₺' formatında para gösterimi.
  String get toCurrencyString {
    final String numStr = toStringAsFixed(0);
    // metinleri verimli şekilde hafızada birleştirmek için StringBuffer kullanıyoruz
    final StringBuffer buffer = StringBuffer();
    int count = 0;
    // sayıyı sondan başa doğru gezip her 3 basamakta bir binlik ayracı olan nokta koyuyoruz
    for (int i = numStr.length - 1; i >= 0; i--) {
      buffer.write(numStr[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    // ters çevrilmiş karakter dizisini düzeltip sonuna Türk Lirası sembolü ekliyoruz
    final String formatted = buffer.toString().split('').reversed.join('');
    return '$formatted ₺';
  }
}

