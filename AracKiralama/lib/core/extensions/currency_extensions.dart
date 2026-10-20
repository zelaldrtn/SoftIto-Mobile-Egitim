/// Para birimi ve sayı formatlama uzantıları.
extension CurrencyExtension on num {
  /// '1.500 ₺' veya '2.250 ₺' formatında para gösterimi.
  String get toCurrencyString {
    final String numStr = toStringAsFixed(0);
    final StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      buffer.write(numStr[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    final String formatted = buffer.toString().split('').reversed.join('');
    return '$formatted ₺';
  }
}
