/// Rezervasyonun yaşam döngüsündeki güncel durumunu tanımlayan enum.
enum ReservationStatus {
  beklemede('Onay Bekliyor'),
  onaylandi('Onaylandı'),
  reddedildi('Reddedildi'),
  tamamlandi('Tamamlandı'),
  iptalEdildi('İptal Edildi');

  const ReservationStatus(this.label);

  /// Arayüzdeki rozetlerde ve bildirimlerde gösterilen Türkçe metin.
  final String label;

  /// Rezervasyonun henüz onay veya red kararı bekleyip beklemediğini sorgular.
  bool get isPending => this == ReservationStatus.beklemede;

  /// Rezervasyonun araç sahibi tarafından onaylanıp onaylanmadığını sorgular.
  bool get isApproved => this == ReservationStatus.onaylandi;

  /// Rezervasyonun araç sahibi tarafından reddedilip reddedilmediğini sorgular.
  bool get isRejected => this == ReservationStatus.reddedildi;

  /// Rezervasyonun kiralayan kullanıcı tarafından iptal edilip edilmediğini sorgular.
  bool get isCancelled => this == ReservationStatus.iptalEdildi;
}

/// Kiralama işleminin tüm detaylarını (araç, kiralayan, sahip, tarihler, ücret ve ehliyet)
/// saklayan değişmez (immutable) rezervasyon veri modeli.
class Reservation {
  const Reservation({
    required this.id,
    required this.carId,
    required this.carBrand,
    required this.carModel,
    required this.carImageUrl,
    required this.dailyPrice,
    required this.renterId,
    required this.renterName,
    required this.renterPhone,
    required this.ownerId,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.totalPrice,
    required this.licenseClass,
    required this.licenseYear,
    this.status = ReservationStatus.beklemede,
    required this.createdAt,
  });

  /// Rezervasyonun benzersiz kimlik numarası (örn. 'res_101').
  final String id;

  /// Kiralanan aracın sistemdeki kimliği.
  final String carId;

  /// Kiralanan aracın markası (araç silinse bile tarihçede korunması için doğrudan tutulur).
  final String carBrand;

  /// Kiralanan aracın modeli.
  final String carModel;

  /// Kiralanan aracın görsel URL'si.
  final String carImageUrl;

  /// Kiralama anındaki günlük kiralama bedeli.
  final double dailyPrice;

  /// Aracı kiralayan kullanıcının kimliği.
  final String renterId;

  /// Aracı kiralayan kullanıcının adı soyadı.
  final String renterName;

  /// Kiralayan kullanıcının iletişim telefon numarası.
  final String renterPhone;

  /// Aracın sahibinin kullanıcı kimliği.
  final String ownerId;

  /// Araç sahibinin adı soyadı.
  final String ownerName;

  /// Kiralama başlangıç tarihi.
  final DateTime startDate;

  /// Kiralama bitiş / teslim tarihi.
  final DateTime endDate;

  /// Toplam kiralanan gün sayısı.
  final int totalDays;

  /// Toplam kiralama bedeli (TL).
  final double totalPrice;

  /// Kiralayanın beyan ettiği sürücü belgesi sınıfı (örn. 'B').
  final String licenseClass;

  /// Kiralayanın sürücü belgesini aldığı yıl (örn. 2018).
  final int licenseYear;

  /// Rezervasyonun mevcut durumu (beklemede, onaylandı, vb.).
  final ReservationStatus status;

  /// Rezervasyon talebinin oluşturulduğu tarih ve saat.
  final DateTime createdAt;

  /// Marka ve modeli birleştirerek aracın tam adını döner.
  String get carFullName => '$carBrand $carModel';

  /// Belirli alanları güncelleyerek yeni bir Reservation nesnesi üretir.
  Reservation copyWith({
    String? id,
    String? carId,
    String? carBrand,
    String? carModel,
    String? carImageUrl,
    double? dailyPrice,
    String? renterId,
    String? renterName,
    String? renterPhone,
    String? ownerId,
    String? ownerName,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    double? totalPrice,
    String? licenseClass,
    int? licenseYear,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      renterId: renterId ?? this.renterId,
      renterName: renterName ?? this.renterName,
      renterPhone: renterPhone ?? this.renterPhone,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      totalPrice: totalPrice ?? this.totalPrice,
      licenseClass: licenseClass ?? this.licenseClass,
      licenseYear: licenseYear ?? this.licenseYear,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
