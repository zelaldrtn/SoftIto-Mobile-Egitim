import 'package:flutter_test/flutter_test.dart';
import 'package:digidia/features/diary/controllers/diary_controller.dart';
import 'package:digidia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  group('DiaryController Testleri', () {
    late DiaryController diaryController;
    final testDate = DateTime(2026, 10, 20);

    setUp(() {
      diaryController = DiaryController(initialEntries: {});
    });

    tearDown(() {
      diaryController.dispose();
    });

    test('Bos gunluk kaydedilmek istendiginde dogrulama yapilir ve kaydedilmez', () {
      final successEmpty = diaryController.saveEntry(
        date: testDate,
        content: '',
      );
      expect(successEmpty, isFalse);
      expect(diaryController.hasEntry(testDate), isFalse);

      final successWhitespace = diaryController.saveEntry(
        date: testDate,
        content: '   \n  ',
      );
      expect(successWhitespace, isFalse);
      expect(diaryController.hasEntry(testDate), isFalse);
    });

    test('Gecerli gunluk basariyla kaydedilir ve ruh hali ile iliskilendirilir', () {
      final success = diaryController.saveEntry(
        date: testDate,
        content: 'Bugun cok verimli bir gundu.',
        moodEmoji: '✨',
      );

      expect(success, isTrue);
      expect(diaryController.hasEntry(testDate), isTrue);

      final entry = diaryController.getEntry(testDate);
      expect(entry, isNotNull);
      expect(entry!.content, 'Bugun cok verimli bir gundu.');
      expect(entry.moodEmoji, '✨');
    });

    test('Ayni tarihe yeni icerik kaydedildiginde tek kayit guncellenir', () {
      diaryController.saveEntry(
        date: testDate,
        content: 'Ilk metin',
        moodEmoji: '😊',
      );

      diaryController.saveEntry(
        date: testDate,
        content: 'Guncellenmis metin',
        moodEmoji: '🥰',
      );

      final entry = diaryController.getEntry(testDate);
      expect(entry!.content, 'Guncellenmis metin');
      expect(entry.moodEmoji, '🥰');
      expect(diaryController.entriesListenable.value.length, 1);
    });

    test('Gunluk basariyla silinir', () {
      diaryController.saveEntry(
        date: testDate,
        content: 'Silinecek gunluk',
      );
      expect(diaryController.hasEntry(testDate), isTrue);

      final deleted = diaryController.deleteEntry(testDate);
      expect(deleted, isTrue);
      expect(diaryController.hasEntry(testDate), isFalse);
    });
  });

  group('ThemeController Testleri', () {
    test('Gunduz ve gece temalari arasinda gecis yapilir', () {
      final controller = ThemeController(ThemeMode.light);
      expect(controller.isDarkMode, isFalse);

      controller.toggleTheme();
      expect(controller.isDarkMode, isTrue);
      expect(controller.value, ThemeMode.dark);

      controller.toggleTheme();
      expect(controller.isDarkMode, isFalse);
      expect(controller.value, ThemeMode.light);

      controller.dispose();
    });
  });
}
