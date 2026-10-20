import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:destek_bul/core/theme/theme_controller.dart';
import 'package:destek_bul/features/auth/controllers/auth_controller.dart';
import 'package:destek_bul/features/auth/models/user_role.dart';
import 'package:destek_bul/features/projects/controllers/projects_controller.dart';
import 'package:destek_bul/features/projects/models/project_model.dart';
import 'package:destek_bul/main.dart';

void main() {
  group('Destek Bul Unit & Smoke Testleri', () {
    setUp(() {
      AuthController.instance.logout();
      ProjectsController.instance.initialize();
      ProjectsController.instance.setCategory('Tümü');
      ProjectsController.instance.setSearchQuery('');
    });

    test('ProjectsController başlangıç verilerini başarıyla yükler', () {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      expect(controller.projectsNotifier.value.isNotEmpty, isTrue);
      expect(controller.filteredProjectsNotifier.value.isNotEmpty, isTrue);
    });

    test('Tema değiştirme işlevi doğru çalışır', () {
      final ThemeController themeController = ThemeController.instance;
      themeController.setThemeMode(ThemeMode.light);
      expect(themeController.themeModeNotifier.value, ThemeMode.light);

      themeController.setThemeMode(ThemeMode.dark);
      expect(themeController.themeModeNotifier.value, ThemeMode.dark);
    });

    test('Projeyi beğenme ve kaydetme state değişiklikleri doğru yansır', () {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      final ProjectModel firstProject = controller.projectsNotifier.value.first;
      final int initialLikes = firstProject.likesCount;
      final bool initialIsLiked = firstProject.isLiked;

      controller.toggleLike(firstProject.id);

      final ProjectModel updated = controller.projectsNotifier.value
          .firstWhere((ProjectModel p) => p.id == firstProject.id);

      expect(updated.isLiked, !initialIsLiked);
      expect(
        updated.likesCount,
        initialIsLiked ? initialLikes - 1 : initialLikes + 1,
      );
    });

    test('Destek Bul arama ve filtreleme çalışır', () {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      controller.setCategory('Yeşil Enerji');
      expect(
        controller.filteredProjectsNotifier.value
            .every((ProjectModel p) => p.category == 'Yeşil Enerji'),
        isTrue,
      );

      controller.setCategory('Tümü');
      controller.setSearchQuery('SolarDrone');
      expect(
        controller.filteredProjectsNotifier.value.any(
          (ProjectModel p) => p.title.contains('SolarDrone'),
        ),
        isTrue,
      );
    });

    test('Kullanıcı kendi belirlediği kategoriyi ekleyebilir ve liste güncellenir', () {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      const String customCategory = 'Biyoteknoloji & Genom';
      controller.addCategory(customCategory);

      expect(controller.categoriesNotifier.value.contains(customCategory), isTrue);

      controller.setCategory(customCategory);
      expect(controller.selectedCategoryNotifier.value, customCategory);
    });

    test('Yatırımcı ve Girişimci oturum açma ve kapatma doğru çalışır', () {
      final AuthController authController = AuthController.instance;

      authController.login(
        email: 'investor@test.com',
        password: 'pass123456',
        role: UserRole.investor,
        name: 'Murat Yatırımcı',
      );

      expect(authController.currentUserNotifier.value, isNotNull);
      expect(authController.currentUserNotifier.value!.role, UserRole.investor);
      expect(authController.currentUserNotifier.value!.role.isInvestor, isTrue);

      authController.loginDemo(UserRole.entrepreneur);
      expect(authController.currentUserNotifier.value!.role, UserRole.entrepreneur);
      expect(authController.currentUserNotifier.value!.role.isEntrepreneur, isTrue);

      authController.logout();
      expect(authController.currentUserNotifier.value, isNull);
    });

    testWidgets('DestekBulApp oturum açılmamışken LoginView ekranını gösterir',
        (WidgetTester tester) async {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      await tester.pumpWidget(const DestekBulApp());
      expect(find.text('Destek Bul'), findsOneWidget);
      expect(find.text('Yatırımcı'), findsOneWidget);
      expect(find.text('Yatırım Alan'), findsOneWidget);
      expect(find.text('Demo Yatırımcı'), findsOneWidget);
      expect(find.text('Demo Girişimci'), findsOneWidget);
    });

    testWidgets('DestekBulApp oturum açılınca HomeView ekranını gösterir',
        (WidgetTester tester) async {
      final ProjectsController controller = ProjectsController.instance;
      controller.initialize();

      AuthController.instance.loginDemo(UserRole.investor);

      await tester.pumpWidget(const DestekBulApp());
      expect(find.text('Proje Paylaş'), findsOneWidget);
      expect(find.text('5 Girişim Bulundu'), findsOneWidget);
    });
  });
}
