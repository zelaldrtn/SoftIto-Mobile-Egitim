import 'package:flutter/material.dart';

/// BuildContext üzerinde tema ve ekran boyutu erişimini kolaylaştıran extension'lar.
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
}

/// Sayısal değerler için formatlama yardımcıları.
extension NumberExtensions on num {
  /// Mililitreyi Litreye çevirir (örn: 2500 -> 2.5L)
  String toLiterString() {
    final liters = this / 1000.0;
    return liters == liters.roundToDouble()
        ? '${liters.toInt()}L'
        : '${liters.toStringAsFixed(1)}L';
  }
}
