import 'package:flutter_test/flutter_test.dart';
import 'package:digidia/main.dart';

void main() {
  testWidgets('DigiDia v1 ana ekran ve bilesenleri basariyla yuklenir', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const DigiDiaApp());
    await tester.pumpAndSettle();

    // Başlık ve takvim kontrollerinin ekranda olduğunu doğrula
    expect(find.text('DigiDia v1'), findsOneWidget);
    expect(find.text('Günlük Yaz'), findsWidgets);
  });
}
