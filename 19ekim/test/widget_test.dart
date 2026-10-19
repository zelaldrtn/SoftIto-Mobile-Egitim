import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  group('Birim Testleri (Unit Tests)', () {
    test('WaterTrackerController su ekleme ve hedef hesaplama testi', () {
      final controller = WaterTrackerController(dailyTargetMl: 2000);
      expect(controller.currentMl, 0);
      expect(controller.remainingMl, 2000);
      expect(controller.percentage, 0);

      controller.addWater(500, label: 'Şişe');
      expect(controller.currentMl, 500);
      expect(controller.remainingMl, 1500);
      expect(controller.percentage, 25);
      expect(controller.logs.length, 1);

      controller.removeLog(controller.logs.first.id);
      expect(controller.currentMl, 0);
      expect(controller.logs.isEmpty, true);
    });

    test('WorkoutController egzersiz ekleme ve kalori testi', () {
      final controller = WorkoutController(dailyCalorieTarget: 500);
      expect(controller.totalCalories, 0);
      expect(controller.totalMinutes, 0);

      controller.addSession(
        title: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 250,
      );
      expect(controller.totalCalories, 250);
      expect(controller.totalMinutes, 30);
      expect(controller.calorieProgress, 0.5);

      controller.resetDaily();
      expect(controller.totalCalories, 0);
      expect(controller.sessions.isEmpty, true);
    });
  });

  group('Arayüz Testleri (Widget Tests)', () {
    void setDeviceSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('SusadimApp başlatma, grafikler ve su ekleme testi', (WidgetTester tester) async {
      setDeviceSize(tester);
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      // Başlık, varsayılan ml ve haftalık grafik kontrolü
      expect(find.text('SUSADIM'), findsOneWidget);
      expect(find.text('0 ml'), findsOneWidget);
      expect(find.text('Haftalık Su Grafiği'), findsOneWidget);

      // +200 ml butonuna tıklama
      final quickButton = find.text('+200');
      expect(quickButton, findsOneWidget);
      await tester.tap(quickButton);
      await tester.pumpAndSettle();

      expect(find.text('200 ml'), findsOneWidget);
    });

    testWidgets('Kullanıcı özel miktar (300 ml) içecek ekleme testi', (WidgetTester tester) async {
      setDeviceSize(tester);
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      // Özel miktar ekleme butonuna scroll edip tıklama
      final customButton = find.text('+ Özel Miktar / İçecek Ekle (örn. 300 ml)');
      expect(customButton, findsOneWidget);
      await tester.ensureVisible(customButton);
      await tester.pumpAndSettle();

      await tester.tap(customButton);
      await tester.pumpAndSettle();

      // Modal bottom sheet açıldığını doğrulama
      expect(find.text('Özel İçecek & Miktar Ekle'), findsOneWidget);
      expect(find.text('Kaydı Ekle'), findsOneWidget);

      // Kaydı Ekle butonuna basarak varsayılan 300 ml kaydetme
      await tester.tap(find.text('Kaydı Ekle'));
      await tester.pumpAndSettle();

      // Değerin 300 ml olarak güncellendiğini doğrulama
      expect(find.text('300 ml'), findsOneWidget);
    });

    testWidgets('Sekme geçişi ve egzersiz grafiği testi', (WidgetTester tester) async {
      setDeviceSize(tester);
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      // Egzersiz sekmesine geçiş
      final workoutTab = find.text('Egzersiz');
      expect(workoutTab, findsOneWidget);
      await tester.tap(workoutTab);
      await tester.pumpAndSettle();

      // Egzersiz ekranı ve grafik kontrolü
      expect(find.text('Yakılan Kalori'), findsOneWidget);
      expect(find.text('Haftalık Kalori Grafiği'), findsOneWidget);
      expect(find.text('+ Özel Egzersiz Ekle (Süre & Kalori)'), findsOneWidget);
    });
  });
}
