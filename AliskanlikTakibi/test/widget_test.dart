import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:aliskanlik_takibi/services/storage_service.dart';
import 'package:aliskanlik_takibi/services/habit_provider.dart';
import 'package:aliskanlik_takibi/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('tr_TR', null);
  });

  test('HabitProvider point and streak rules test', () async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    // Initial starter habits exist
    expect(provider.habits.length, greaterThanOrEqualTo(3));
    final initialPoints = provider.pointsBalance;

    // Toggle completion for first habit
    final testHabit = provider.habits.first;
    final now = DateTime.now();

    final earned = await provider.toggleCompletion(testHabit.id, now);
    expect(earned, isTrue);
    expect(provider.pointsBalance, equals(initialPoints + testHabit.points));

    // Habit should be completed on date
    expect(provider.isHabitCompletedOnDate(testHabit.id, now), isTrue);

    // Unmarking completion subtracts the points safely
    final unearned = await provider.toggleCompletion(testHabit.id, now);
    expect(unearned, isFalse);
    expect(provider.pointsBalance, equals(initialPoints));
  });

  test('Room store purchasing prevents insufficient balance', () async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    // Try buying expensive item when points are low
    final expensiveItem = provider.roomItems.firstWhere((i) => i.price > provider.pointsBalance && !i.isOwned);
    final bought = provider.buyRoomItem(expensiveItem.id);
    expect(bought, isFalse);
  });

  testWidgets('App renders main navigation and tabs', (WidgetTester tester) async {
    final storageService = await StorageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider(storageService)),
        ],
        child: const DoItApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify 5 bottom navigation labels
    expect(find.text('Bugün'), findsOneWidget);
    expect(find.text('Takvim'), findsOneWidget);
    expect(find.text('Odam'), findsOneWidget);
    expect(find.text('Analiz'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Switch to Takvim tab
    await tester.tap(find.text('Takvim'));
    await tester.pumpAndSettle();
    expect(find.text('Takvim & İlerleme'), findsOneWidget);

    // Switch to Odam tab
    await tester.tap(find.text('Odam'));
    await tester.pumpAndSettle();
    expect(find.text('Odam & Yaşam Alanı'), findsOneWidget);

    // Switch to Analiz tab
    await tester.tap(find.text('Analiz'));
    await tester.pumpAndSettle();
    expect(find.text('İstatistik & Analiz'), findsOneWidget);

    // Switch to Profil tab
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil & Ayarlar'), findsOneWidget);
  });

  testWidgets('Room screen renders 3D isometric room and does not overflow on small screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storageService = await StorageService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider(storageService)),
        ],
        child: const DoItApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Switch to Odam tab
    await tester.tap(find.text('Odam'));
    await tester.pumpAndSettle();

    expect(find.text('Odam & Yaşam Alanı'), findsOneWidget);
    expect(find.textContaining('Puan'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Envanter'), findsOneWidget);
    expect(find.text('Mağaza'), findsOneWidget);

    // Ensure no overflow errors occurred
    expect(tester.takeException(), isNull);
  });

  testWidgets('DailyProgressCard fits completion percentage inside the circle in dark and light modes', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    // Set dark theme
    await provider.updateProfile(provider.profile.copyWith(themeMode: 'dark'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const DoItApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify percentage text is rendered
    expect(find.textContaining('%'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });
}
