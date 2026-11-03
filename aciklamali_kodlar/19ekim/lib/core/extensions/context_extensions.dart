import 'package:flutter/material.dart';

/// BuildContext üzerinde tema ve ekran boyutu erişimini kolaylaştıran extension'lar.
// extension: var olan bir sınıfa (burada BuildContext) yeni yardımcı getter ve metotlar eklemeyi sağlar
extension BuildContextExtensions on BuildContext {
  // Theme.of(this): geçerli tema ayarlarına doğrudan context.theme üzerinden erişim sunar
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // MediaQuery.sizeOf: ekranın genişlik ve yükseklik ölçülerini verir
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
}

/// Sayısal değerler için formatlama yardımcıları.
// num türündeki sayılara (int ve double) özel metot ekler
extension NumberExtensions on num {
  /// Mililitreyi Litreye çevirir (örn: 2500 -> 2.5L)
  String toLiterString() {
    final liters = this / 1000.0;
    // tam sayı ise küsurat göstermez, ondalıklı ise virgülden sonra 1 basamak bırakır
    return liters == liters.roundToDouble()
        ? '${liters.toInt()}L'
        : '${liters.toStringAsFixed(1)}L';
  }
}

