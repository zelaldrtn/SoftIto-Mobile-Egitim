import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moneyplan/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MoneyPlanApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyPlanApp());
    await tester.pumpAndSettle();
    expect(find.text('MoneyPlan'), findsWidgets);
  });
}
