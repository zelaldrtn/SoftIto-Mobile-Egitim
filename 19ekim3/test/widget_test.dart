import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım app smoke and interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Başlık ve başlangıç su miktarı doğrulanır
    expect(find.text('Susadım - Su Takibi'), findsOneWidget);
    expect(find.text('0 / 2000 ml'), findsOneWidget);

    // +250 ml butonuna tıklanır
    await tester.tap(find.text('+250 ml'));
    await tester.pumpAndSettle();

    // Su miktarının 250 ml'ye çıktığı doğrulanır
    expect(find.text('250 / 2000 ml'), findsOneWidget);

    // Egzersiz sekmesine geçiş yapılır
    await tester.tap(find.text('Egzersiz'));
    await tester.pumpAndSettle();

    expect(find.text('Susadım - Egzersiz & Kalori'), findsOneWidget);
    expect(find.text('Yakılan Kalori'), findsOneWidget);

    // Koşu egzersizi eklenir
    await tester.tap(find.text('Koşu (30dk)'));
    await tester.pumpAndSettle();

    expect(find.text('280 kcal'), findsOneWidget);

    // Tema değiştirme butonuna tıklanır
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
  });
}
