import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:aliskanlik_takibi/services/storage_service.dart';
import 'package:aliskanlik_takibi/services/habit_provider.dart';
import 'package:aliskanlik_takibi/screens/room_screen.dart';
import 'package:aliskanlik_takibi/widgets/game3d/room_game_view.dart';
import 'package:aliskanlik_takibi/widgets/isometric_room_view.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('tr_TR', null);
  });

  testWidgets('Room3DGameView renders 3D room, camera controls, gesture hint and reacts to buttons', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Room3DGameView(
              isDark: false,
              isNightMode: false,
              onToggleNightMode: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify 3D Game View and controls
    expect(find.byType(Room3DGameView), findsOneWidget);
    expect(find.text('Taşı & Düzenle'), findsOneWidget);
    expect(find.text('360° Kamera'), findsOneWidget);

    // Verify Camera HUD buttons
    expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_in_ar_rounded), findsOneWidget);
    expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    expect(find.byIcon(Icons.grid_3x3_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);

    // Tap mode buttons
    await tester.tap(find.text('360° Kamera'));
    await tester.pump();

    await tester.tap(find.text('Taşı & Düzenle'));
    await tester.pump();

    // Tap zoom buttons
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();

    // Verify gesture hint badge and close it
    expect(find.byIcon(Icons.touch_app_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.close_rounded), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('RoomScreen allows switching seamlessly between 3D Oda Oyunu and 2D İzometrik', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: RoomScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // By default 3D Oda Oyunu is active
    expect(find.text('3D Oda Oyunu'), findsOneWidget);
    expect(find.text('2D İzometrik'), findsOneWidget);
    expect(find.byType(Room3DGameView), findsOneWidget);
    expect(find.byType(IsometricRoomView), findsNothing);

    // Switch to 2D İzometrik
    await tester.tap(find.text('2D İzometrik'));
    await tester.pumpAndSettle();

    expect(find.byType(IsometricRoomView), findsOneWidget);
    expect(find.byType(Room3DGameView), findsNothing);

    // Switch back to 3D Oda Oyunu
    await tester.tap(find.text('3D Oda Oyunu'));
    await tester.pumpAndSettle();

    expect(find.byType(Room3DGameView), findsOneWidget);
    expect(find.byType(IsometricRoomView), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Tema Testi: Açık ve koyu temada eşya hareketi temayı değiştirmez', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    // Açık tema ayarla
    provider.setThemeMode(ThemeMode.light);
    expect(provider.themeMode, ThemeMode.light);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const RoomScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 3D oda görünümünde bir eşyanın konumunu güncelle
    final placedItems = provider.roomItems.where((i) => i.isPlaced).toList();
    expect(placedItems.isNotEmpty, true);
    final firstItem = placedItems.first;

    // Eşyayı sürükle / hareket ettir
    provider.updateRoomItemPosition(firstItem.id, firstItem.positionX + 0.5, firstItem.positionZ + 0.3);
    await tester.pumpAndSettle();

    // Tema hala LIGHT olmalı, eşya hareketi temayı DEĞİŞTİRMEMELİ
    expect(provider.themeMode, ThemeMode.light);

    // Koyu temaya geçiş testi
    provider.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(provider.themeMode, ThemeMode.dark);

    // Koyu temada da eşyayı hareket ettir
    provider.updateRoomItemPosition(firstItem.id, firstItem.positionX - 0.2, firstItem.positionZ - 0.1);
    await tester.pumpAndSettle();

    // Koyu tema korunmalı
    expect(provider.themeMode, ThemeMode.dark);
    expect(tester.takeException(), isNull);
  });

  test('Mağaza ve 3D Oda Bağlantısı Testi: Satın alma, 3D odaya eklenme ve çift eklenmenin engellenmesi', () async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    // Kullanıcıya test için yeterli puan ver
    provider.addPoints(5000);
    final initialPoints = provider.pointsBalance;

    // Henüz sahip olunmayan bir eşya bul
    final unownedItem = provider.roomItems.firstWhere((i) => !i.isOwned);
    final unownedId = unownedItem.id;
    final itemCost = unownedItem.price;

    // Satın al
    final success = provider.buyRoomItem(unownedId);
    expect(success, true, reason: 'Yeterli puanla satın alma başarılı olmalı');

    // Puan düşmüş olmalı
    expect(provider.pointsBalance, initialPoints - itemCost);

    // Eşya artık sahip olunmalı ve 3D odada yerleştirilmiş olmalı
    final boughtItem = provider.roomItems.firstWhere((i) => i.id == unownedId);
    expect(boughtItem.isOwned, true);
    expect(boughtItem.isPlaced, true);
    expect(boughtItem.positionX, isNotNull);
    expect(boughtItem.positionZ, isNotNull);

    // 3D odada yerleşen eşyalar listesinde bulunmalı
    final placedIn3D = provider.roomItems.where((i) => i.isPlaced && i.id == unownedId).toList();
    expect(placedIn3D.length, 1);

    // AYNI EŞYAYI İKİNCİ KEZ SATIN ALMAYI DENE -> Engellenmeli!
    final buyAgain = provider.buyRoomItem(unownedId);
    expect(buyAgain, false, reason: 'Aynı eşya iki kez satın alınamaz');

    // Puan tekrar DÜŞMEMELİ
    expect(provider.pointsBalance, initialPoints - itemCost);

    // Katalogda aynı ID ile çift kayıt OLMAMALI
    final duplicateMatches = provider.roomItems.where((i) => i.id == unownedId).toList();
    expect(duplicateMatches.length, 1, reason: 'Katalogda aynı eşyadan iki kopya olamaz');
  });

  test('Veri Tutarlılığı Testi: Eşya hareketi, rotasyonu ve satın almalar SharedPreferences üzerinde kalıcıdır', () async {
    // 1. Adım: İlk oturumda bir eşyayı hareket ettir ve kaydet
    final storage1 = await StorageService.init();
    final provider1 = HabitProvider(storage1);

    final item = provider1.roomItems.firstWhere((i) => i.isPlaced);
    const double targetX = 1.35;
    const double targetZ = -0.85;
    const double targetRot = 90.0;

    provider1.updateRoomItemPosition(item.id, targetX, targetZ, rotationY: targetRot);

    // 2. Adım: Yeni bir StorageService ve HabitProvider örneği (uygulamanın yeniden açılması simülasyonu)
    final storage2 = await StorageService.init();
    final provider2 = HabitProvider(storage2);

    final reloadedItem = provider2.roomItems.firstWhere((i) => i.id == item.id);

    // 3. Adım: Değerlerin korunduğunu doğrula
    expect(reloadedItem.positionX, closeTo(targetX, 0.001));
    expect(reloadedItem.positionZ, closeTo(targetZ, 0.001));
    expect(reloadedItem.rotationY, closeTo(targetRot, 0.001));
    expect(reloadedItem.isPlaced, true);
  });

  testWidgets('UX Testi: Mağazadan eşya satın alındığında direkt odaya döner', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);
    provider.addPoints(5000);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: RoomScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Mağaza ekranını aç
    await tester.tap(find.text('Mobilya Al'));
    await tester.pumpAndSettle();

    // Mağaza ekranının açıldığını doğrula
    expect(find.text('Oda Mağazası & Katalog'), findsOneWidget);

    // 2. Bir eşya satın al butonuna tıkla
    final buyButton = find.textContaining('Satın Al').first;
    await tester.tap(buyButton);
    await tester.pumpAndSettle();

    // 3. Mağaza kapandı ve DİREKT ODA EKRANINA DÖNDÜ!
    expect(find.text('Oda Mağazası & Katalog'), findsNothing);
    expect(find.byType(Room3DGameView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Alt Tepsi Testi: Kaydırma okları mevcuttur ve taşma yapmaz', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Room3DGameView(
              isDark: false,
              isNightMode: false,
              onToggleNightMode: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Sol ve sağ kaydırma oklarının varlığını doğrula
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

    // Sağa kaydırma okuna bas
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();

    // Sola kaydırma okuna bas
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

