import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım v1 tema geçişi, smoke test ve sekme kontrolü',
      (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Başlık ve su takip kartını doğrula
    expect(find.text('Susadım v1'), findsOneWidget);
    expect(find.text('GÜNLÜK HİDRASYON'), findsOneWidget);

    // Tema değiştirme butonuna basarak aydınlık moda geç
    final themeToggleBtn = find.byTooltip('Aydınlık Moda Geç');
    expect(themeToggleBtn, findsOneWidget);
    await tester.tap(themeToggleBtn);
    await tester.pumpAndSettle();

    // Aydınlık modda tooltip'in 'Karanlık Moda Geç' olduğunu doğrula
    expect(find.byTooltip('Karanlık Moda Geç'), findsOneWidget);
    expect(globalThemeController.themeMode.value, ThemeMode.light);

    // Tekrar basıp karanlık moda dön
    await tester.tap(find.byTooltip('Karanlık Moda Geç'));
    await tester.pumpAndSettle();
    expect(globalThemeController.themeMode.value, ThemeMode.dark);

    // Hızlı +250 ml su ekleme butonuna bas ve kontrol et
    final add250Btn = find.text('+250 ml').first;
    await tester.tap(add250Btn);
    await tester.pumpAndSettle();

    // Egzersiz sekmesine geçişi test et
    final workoutTab = find.text('Egzersiz');
    expect(workoutTab, findsOneWidget);
    await tester.tap(workoutTab);
    await tester.pumpAndSettle();

    // Egzersiz özet kartını doğrula
    expect(find.text('YAKILAN ENERJİ & SÜRE'), findsOneWidget);
  });
}
