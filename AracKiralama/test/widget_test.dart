import 'package:arac_kiralama/core/theme/theme_controller.dart';
import 'package:arac_kiralama/features/auth/controllers/auth_controller.dart';
import 'package:arac_kiralama/features/auth/models/user_model.dart';
import 'package:arac_kiralama/features/cars/controllers/car_controller.dart';
import 'package:arac_kiralama/features/cars/models/car_model.dart';
import 'package:arac_kiralama/features/cars/views/car_detail_view.dart';
import 'package:arac_kiralama/features/cars/views/my_cars_view.dart';
import 'package:arac_kiralama/features/profile/views/settings_view.dart';
import 'package:arac_kiralama/features/reservations/controllers/reservation_controller.dart';
import 'package:arac_kiralama/features/reservations/models/reservation_model.dart';
import 'package:arac_kiralama/features/reservations/views/create_reservation_view.dart';
import 'package:arac_kiralama/features/reservations/views/incoming_requests_view.dart';
import 'package:arac_kiralama/features/reservations/views/renter_reservations_view.dart';
import 'package:arac_kiralama/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Senaryo 1 & Navigasyon: Rol değişimi ve dinamik menü testi',
      (WidgetTester tester) async {
    final AuthController authCtrl = AuthController.instance;

    // Kiralayan rolü testi
    authCtrl.switchRole(UserRole.kiralayan);
    await tester.pumpWidget(const AracKiralamaApp());
    await tester.pumpAndSettle();

    expect(find.text('Araçlar'), findsOneWidget);
    expect(find.text('Rezervasyonlarım'), findsOneWidget);
    expect(find.text('Gelen Talepler'), findsNothing);

    // Araç Sahibi rolü testi
    authCtrl.switchRole(UserRole.aracSahibi);
    await tester.pumpAndSettle();

    expect(find.text('Araçlarım'), findsWidgets);
    expect(find.text('Gelen Talepler'), findsOneWidget);

    // Kiralayana geri dön
    authCtrl.switchRole(UserRole.kiralayan);
    await tester.pumpAndSettle();
  });

  testWidgets('Senaryo 2, 3 & 4: Araç sahibi araç ekleme, listeleme ve düzenleme',
      (WidgetTester tester) async {
    final CarController carCtrl = CarController.instance;
    const String testCarId = 'car_scenario_test';

    const Car newCar = Car(
      id: testCarId,
      brand: 'Audi',
      modelName: 'RS6 Avant',
      year: 2024,
      dailyPrice: 5500.0,
      fuelType: FuelType.benzin,
      transmission: TransmissionType.otomatik,
      category: CarCategory.spor,
      seats: 5,
      imageUrl: 'https://example.com/rs6.jpg',
      ownerId: 'user_1',
      ownerName: 'Ahmet Yılmaz',
    );

    // Araç ekleme (Senaryo 2)
    carCtrl.addCar(newCar);

    // Araçlarım ekranında görünme (Senaryo 3)
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MyCarsView())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Audi RS6 Avant'), findsOneWidget);

    // Araç düzenleme (Senaryo 4)
    final Car updated = newCar.copyWith(dailyPrice: 6000.0);
    carCtrl.updateCar(updated);
    await tester.pumpAndSettle();
    expect(carCtrl.getCarById(testCarId)?.dailyPrice, 6000.0);

    // Temizlik
    carCtrl.deleteCar(testCarId);
  });

  testWidgets('Senaryo 5 & 11: Araç detay ekranı ve geri butonu testi',
      (WidgetTester tester) async {
    final Car car = CarController.instance.carsListenable.value.first;

    await tester.pumpWidget(
      MaterialApp(home: CarDetailView(car: car)),
    );
    await tester.pumpAndSettle();

    expect(find.text(car.fullName), findsOneWidget);
    expect(find.text('Hemen Kirala'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets(
      'Senaryo 6, 7 & 11: Kiralama ekranı, fiyat hesaplama, geri butonu ve rezervasyon',
      (WidgetTester tester) async {
    final Car car = CarController.instance.carsListenable.value.first;

    await tester.pumpWidget(
      MaterialApp(home: CreateReservationView(car: car)),
    );
    await tester.pumpAndSettle();

    // Başlık ve geri butonu kontrolü
    expect(find.text('Araç Kirala'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    // Fiyat ve gün hesaplama testi
    final (int days, double total) =
        ReservationController.instance.calculateRentalCost(
      start: DateTime(2026, 7, 1),
      end: DateTime(2026, 7, 5),
      dailyPrice: car.dailyPrice,
    );
    expect(days, 4);
    expect(total, 4 * car.dailyPrice);

    // Rezervasyon oluşturma
    final Reservation newRes = Reservation(
      id: 'res_scenario_test',
      carId: car.id,
      carBrand: car.brand,
      carModel: car.modelName,
      carImageUrl: car.imageUrl,
      dailyPrice: car.dailyPrice,
      renterId: 'user_1',
      renterName: 'Ahmet Yılmaz',
      renterPhone: '+90 532 555 0123',
      ownerId: car.ownerId,
      ownerName: car.ownerName,
      startDate: DateTime(2026, 7, 1),
      endDate: DateTime(2026, 7, 5),
      totalDays: 4,
      totalPrice: total,
      licenseClass: 'B',
      licenseYear: 2019,
      createdAt: DateTime.now(),
    );

    ReservationController.instance.createReservation(newRes);

    // Kiralayanın Rezervasyonlarım ekranında görmesi (Senaryo 7)
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RenterReservationsView())),
    );
    await tester.pumpAndSettle();
    expect(find.text(car.fullName), findsWidgets);
  });

  testWidgets(
      'Senaryo 8 & 9: Araç sahibi gelen talepler ve rezervasyon onaylama/reddetme',
      (WidgetTester tester) async {
    final ReservationController resCtrl = ReservationController.instance;

    // Gelen talepler ekranı (Senaryo 8)
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: IncomingRequestsView())),
    );
    await tester.pumpAndSettle();

    // Talebi onaylama (Senaryo 9)
    final bool approved = resCtrl.approveReservation('res_101');
    expect(approved, isTrue);
    expect(resCtrl.getById('res_101')?.status, ReservationStatus.onaylandi);

    // Reddetme testi
    resCtrl.updateStatus('res_scenario_test', ReservationStatus.reddedildi);
    expect(resCtrl.getById('res_scenario_test')?.status,
        ReservationStatus.reddedildi);
  });

  testWidgets('Senaryo 10: Ayarlar ekranı ve tema değiştirme testi',
      (WidgetTester tester) async {
    final ThemeController themeCtrl = ThemeController.instance;

    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Görünüm ve Tema'), findsOneWidget);
    expect(find.text('Aydınlık Tema'), findsOneWidget);
    expect(find.text('Karanlık Tema'), findsOneWidget);
    expect(find.text('Sistem Temasını Takip Et'), findsOneWidget);
    expect(find.text('Güvenli Çıkış Yap'), findsOneWidget);

    // Tema değiştirme
    themeCtrl.setThemeMode(ThemeMode.light);
    expect(themeCtrl.isLightMode, isTrue);

    themeCtrl.setThemeMode(ThemeMode.system);
    expect(themeCtrl.isSystemMode, isTrue);

    themeCtrl.setThemeMode(ThemeMode.dark);
    expect(themeCtrl.isDarkMode, isTrue);
  });

  testWidgets('Senaryo 12: Araç sahibi kendi aracını kiralayamaz, ilanı düzenle butonu gösterilir',
      (WidgetTester tester) async {
    final AuthController authCtrl = AuthController.instance;
    authCtrl.switchRole(UserRole.aracSahibi);

    // user_1'in kendi aracı (car_2 - Mercedes C200)
    final Car myCar = CarController.instance.getCarById('car_2')!;

    await tester.pumpWidget(
      MaterialApp(home: CarDetailView(car: myCar)),
    );
    await tester.pumpAndSettle();

    // Kendi aracı olduğu için "İlanı Düzenle" görünmeli, "Hemen Kirala" GÖRÜNMEMELİDİR.
    expect(find.text('İlanı Düzenle'), findsOneWidget);
    expect(find.text('Hemen Kirala'), findsNothing);
    expect(find.text('Kendi İlanınız'), findsOneWidget);

    // Kiralayan rolüne geri al
    authCtrl.switchRole(UserRole.kiralayan);
    await tester.pumpAndSettle();
  });
}
