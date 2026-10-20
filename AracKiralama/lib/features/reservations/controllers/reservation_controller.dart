import 'package:flutter/foundation.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../cars/models/car_model.dart';
import '../models/reservation_model.dart';

/// Rezervasyon iş mantığı, onaylama, reddetme, tarih çakışması ve ehliyet uygunluk kontrolü denetleyicisi.
/// Tüm kiralama taleplerinin yaşam döngüsü bu denetleyici üzerinden yönetilir.
class ReservationController {
  // Özel kurucu: Başlangıç rezervasyon listesini reaktif bildirimciye yükler.
  ReservationController._() {
    _reservationsNotifier =
        ValueNotifier<List<Reservation>>(_initialReservations);
  }

  /// Singleton örneği: Rezervasyon durumları uygulama genelinde senkronize çalışır.
  static final ReservationController instance = ReservationController._();

  /// Tüm rezervasyonların reaktif listesi.
  late final ValueNotifier<List<Reservation>> _reservationsNotifier;

  /// Rezervasyon değişikliklerini dinlemek isteyen UI bileşenleri için dinlenebilir nesne.
  ValueListenable<List<Reservation>> get reservationsListenable =>
      _reservationsNotifier;

  /// Güncel rezervasyon listesinin anlık kopyası.
  List<Reservation> get allReservations => _reservationsNotifier.value;

  /// Kullanıcının ehliyet sınıfı ve ehliyet alış yılı ile aracın kiralama şartlarını karşılaştırır.
  /// Şartlar sağlanmıyorsa açıklayıcı hata mesajı, uygunsa `null` döner.
  String? validateDriverLicense({
    required String userLicenseClass,
    required int userLicenseYear,
    required Car car,
  }) {
    // 1. Ehliyet Sınıfı Kontrolü (örn. 'B' sınıfı gerekiyor mu?)
    if (userLicenseClass.trim().toUpperCase() !=
        car.licenseClassRequired.toUpperCase()) {
      return 'Bu araç için en az "${car.licenseClassRequired}" sınıfı ehliyet gereklidir. (Mevcut: $userLicenseClass)';
    }

    // 2. Ehliyet Yaşı / Deneyimi Kontrolü (örn. en az 2 yıllık ehliyet zorunlu mu?)
    final int currentYear = DateTime.now().year;
    final int experienceYears = currentYear - userLicenseYear;
    if (experienceYears < car.minLicenseYears) {
      return 'Bu araç için en az ${car.minLicenseYears} yıllık ehliyet tecrübesi gereklidir. (Mevcut: $experienceYears yıl)';
    }

    return null; // Tüm ehliyet şartları sağlandı.
  }

  /// Seçilen kiralama başlangıç ve bitiş tarihleri arasındaki gün sayısını
  /// ve aracın günlük ücretine göre toplam kiralama bedelini hesaplar.
  (int days, double totalPrice) calculateRentalCost({
    required DateTime start,
    required DateTime end,
    required double dailyPrice,
  }) {
    final int days = start.daysBetween(end);
    final double total = days * dailyPrice;
    return (days, total);
  }

  /// Yeni bir kiralama talebini listeye ekler ve araç sahibinin onayına sunar.
  void createReservation(Reservation reservation) {
    _reservationsNotifier.value = <Reservation>[
      reservation,
      ..._reservationsNotifier.value,
    ];
  }

  /// Belirtilen araç için belirtilen tarih aralığında çakışan başka bir ONAYLI rezervasyon olup olmadığını sorgular.
  /// Çift rezervasyon (double booking) oluşmasını engeller.
  bool hasDateConflict({
    required String carId,
    required DateTime start,
    required DateTime end,
    String? excludeReservationId,
  }) {
    // Saat/dakika farklarından etkilenmemek için yalnızca yıl-ay-gün olarak normalize edilir.
    final DateTime checkStart = DateTime(start.year, start.month, start.day);
    final DateTime checkEnd = DateTime(end.year, end.month, end.day);

    return _reservationsNotifier.value.any((Reservation r) {
      // Farklı bir araca aitse veya incelenen rezervasyonun kendisiyse yoksay.
      if (r.carId != carId) return false;
      if (r.id == excludeReservationId) return false;

      // Yalnızca onaylanmış rezervasyonlar takvimi kilitler (reddedilen veya beklemedekiler kilitlemez).
      if (r.status != ReservationStatus.onaylandi) return false;

      final DateTime rStart =
          DateTime(r.startDate.year, r.startDate.month, r.startDate.day);
      final DateTime rEnd =
          DateTime(r.endDate.year, r.endDate.month, r.endDate.day);

      // İki tarih aralığının kesişim kuralı: !(rEnd < checkStart || rStart > checkEnd)
      return !rEnd.isBefore(checkStart) && !rStart.isAfter(checkEnd);
    });
  }

  /// Araç sahibinin rezervasyonu onaylamasını sağlar.
  /// Onay öncesi tarih çakışması kontrolü yapılır; çakışma varsa işlem iptal edilir ve hata döner.
  bool approveReservation(
    String reservationId, {
    void Function(String reason)? onError,
  }) {
    final Reservation? res = getById(reservationId);
    if (res == null) return false;

    // Tarih çakışması kontrolü
    if (hasDateConflict(
      carId: res.carId,
      start: res.startDate,
      end: res.endDate,
      excludeReservationId: res.id,
    )) {
      onError?.call(
        'Bu araç için seçilen tarih aralığında zaten onaylanmış başka bir rezervasyon bulunmaktadır.',
      );
      return false;
    }

    // Çakışma yoksa durumunu 'onaylandı' olarak güncelle.
    updateStatus(reservationId, ReservationStatus.onaylandi);
    return true;
  }

  /// Kimlik numarasına göre rezervasyonu arar.
  Reservation? getById(String id) {
    try {
      return _reservationsNotifier.value.firstWhere((Reservation r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Bir rezervasyonun durumunu (beklemede, onaylandi, reddedildi, iptalEdildi vb.) günceller.
  void updateStatus(String reservationId, ReservationStatus newStatus) {
    _reservationsNotifier.value = _reservationsNotifier.value.map((Reservation r) {
      return r.id == reservationId ? r.copyWith(status: newStatus) : r;
    }).toList();
  }

  /// Kiralayan kullanıcının aktif rezervasyonunu iptal etmesini sağlar.
  void cancelReservation(String reservationId) {
    updateStatus(reservationId, ReservationStatus.iptalEdildi);
  }

  /// Belirtilen kiralayana (renterId) ait geçmiş ve aktif rezervasyonları döner.
  List<Reservation> getForRenter(String renterId) {
    return _reservationsNotifier.value
        .where((Reservation r) => r.renterId == renterId)
        .toList();
  }

  /// Belirtilen araç sahibine (ownerId) ait araçlar için gelen kiralama taleplerini döner.
  List<Reservation> getForOwner(String ownerId) {
    return _reservationsNotifier.value
        .where((Reservation r) => r.ownerId == ownerId)
        .toList();
  }

  /// Uygulama açılışında demo amacıyla gösterilen başlangıç rezervasyonları.
  static final List<Reservation> _initialReservations = <Reservation>[
    Reservation(
      id: 'res_101',
      carId: 'car_2',
      carBrand: 'Mercedes-Benz',
      carModel: 'C200 4MATIC AMG',
      carImageUrl:
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=800&q=80',
      dailyPrice: 3100.0,
      renterId: 'renter_99',
      renterName: 'Selim Aydın',
      renterPhone: '+90 533 111 2233',
      ownerId: 'user_1',
      ownerName: 'Ahmet Yılmaz',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      totalDays: 3,
      totalPrice: 9300.0,
      licenseClass: 'B',
      licenseYear: 2018,
      status: ReservationStatus.beklemede,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Reservation(
      id: 'res_102',
      carId: 'car_1',
      carBrand: 'BMW',
      carModel: '320i M Sport',
      carImageUrl:
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80',
      dailyPrice: 2850.0,
      renterId: 'user_1',
      renterName: 'Ahmet Yılmaz',
      renterPhone: '+90 532 555 0123',
      ownerId: 'user_owner_1',
      ownerName: 'Mert Aksoy',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      totalDays: 3,
      totalPrice: 8550.0,
      licenseClass: 'B',
      licenseYear: 2019,
      status: ReservationStatus.onaylandi,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
