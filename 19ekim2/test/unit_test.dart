import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';

void main() {
  group('ThemeController Birim Testleri', () {
    late ThemeController controller;

    setUp(() {
      controller = ThemeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('varsayılan tema dark olmalı ve toggleTheme light moda geçirmeli', () {
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDark, true);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.light);
      expect(controller.isDark, false);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDark, true);
    });

    test('setTheme belirli modu atayabilmeli', () {
      controller.setTheme(ThemeMode.light);
      expect(controller.themeMode.value, ThemeMode.light);
    });
  });

  group('WaterTrackerController Birim Testleri', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('addCustomDrink 300 ml eklediğinde mevcut su artmalı', () {
      final initial = controller.currentWater.value;
      controller.addCustomDrink('Su', 300, 0xe356);
      expect(controller.currentWater.value, initial + 300);
      expect(controller.history.value.first.amountMl, 300);
      expect(controller.history.value.first.title, 'Su');
    });

    test('resetWater tüm suyu sıfırlamalı', () {
      controller.resetWater();
      expect(controller.currentWater.value, 0);
      expect(controller.history.value.isEmpty, true);
    });

    test('removeEntry kaydı silip suyu düşürmeli', () {
      controller.addWater(amountMl: 500, title: 'Büyük Şişe');
      final entryId = controller.history.value.first.id;
      final current = controller.currentWater.value;
      controller.removeEntry(entryId);
      expect(controller.currentWater.value, current - 500);
    });
  });

  group('WorkoutController Birim Testleri', () {
    late WorkoutController controller;

    setUp(() {
      controller = WorkoutController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('addWorkout kalori ve süreyi artırmalı', () {
      final initCalories = controller.todayCalories.value;
      final initMinutes = controller.todayMinutes.value;

      controller.addWorkout('Yüzme', 40, 350, 'Yüksek');

      expect(controller.todayCalories.value, initCalories + 350);
      expect(controller.todayMinutes.value, initMinutes + 40);
      expect(controller.workouts.value.first.title, 'Yüzme');
    });

    test('resetWorkout antrenmanları sıfırlamalı', () {
      controller.resetWorkout();
      expect(controller.todayCalories.value, 0);
      expect(controller.todayMinutes.value, 0);
      expect(controller.workouts.value.isEmpty, true);
    });
  });
}
