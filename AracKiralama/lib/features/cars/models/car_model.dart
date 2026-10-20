/// Araç yakıt türlerini tanımlayan enum.
enum FuelType {
  benzin('Benzin'),
  dizel('Dizel'),
  hibrit('Hibrit'),
  elektrik('Elektrik');

  const FuelType(this.label);

  /// Arayüzde kullanıcıya gösterilecek Türkçe etiket.
  final String label;
}

/// Araç vites tiplerini tanımlayan enum.
enum TransmissionType {
  otomatik('Otomatik'),
  manuel('Manuel');

  const TransmissionType(this.label);

  /// Arayüzde kullanıcıya gösterilecek Türkçe etiket.
  final String label;
}

/// Araç kasa ve kullanım kategorilerini tanımlayan enum.
enum CarCategory {
  tum('Tümü'),
  sedan('Sedan'),
  suv('SUV'),
  spor('Spor'),
  elektrikli('Elektrikli'),
  hatchback('Hatchback');

  const CarCategory(this.label);

  /// Kategori filtre çipleri ve açılır listelerde gösterilen etiket.
  final String label;
}

/// Araç Kiralama platformundaki her bir aracı temsil eden değişmez (immutable) veri modeli.
class Car {
  const Car({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.year,
    required this.dailyPrice,
    required this.fuelType,
    required this.transmission,
    required this.category,
    required this.seats,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    this.rating = 4.8,
    this.reviewCount = 18,
    this.isAvailable = true,
    this.licenseClassRequired = 'B',
    this.minLicenseYears = 2,
    this.description = 'Bakımları yetkili serviste yapılmış, temiz ve konforlu araç.',
  });

  /// Aracın benzersiz kimlik numarası (örn. 'car_1').
  final String id;

  /// Araç üretici markası (örn. 'BMW', 'Mercedes-Benz').
  final String brand;

  /// Araç model adı (örn. '320i M Sport').
  final String modelName;

  /// Aracın model yılı (örn. 2024).
  final int year;

  /// Günlük kiralama ücreti (TL bazında).
  final double dailyPrice;

  /// Yakıt tipi (Benzin, Dizel, Hibrit, Elektrik).
  final FuelType fuelType;

  /// Şanzıman türü (Otomatik veya Manuel).
  final TransmissionType transmission;

  /// Araç kategorisi (Sedan, SUV, Spor vb.).
  final CarCategory category;

  /// Koltuk sayısı (örn. 5).
  final int seats;

  /// Aracın internet üzerindeki kapak fotoğrafı URL'si.
  final String imageUrl;

  /// Aracı sisteme ekleyen araç sahibinin kullanıcı kimliği.
  final String ownerId;

  /// Araç sahibinin adı ve soyadı.
  final String ownerName;

  /// Kullanıcı puan ortalaması (1.0 - 5.0 aralığında).
  final double rating;

  /// Toplam yapılan kullanıcı değerlendirmesi sayısı.
  final int reviewCount;

  /// Aracın şu anda kiralanmaya uygun olup olmadığını belirten bayrak.
  final bool isAvailable;

  /// Bu aracı kiralamak için zorunlu olan asgari ehliyet sınıfı (örn. 'B').
  final String licenseClassRequired;

  /// Bu aracı kiralamak için gereken asgari ehliyet yaşı (yıl cinsinden).
  final int minLicenseYears;

  /// Araç sahibinin girdiği detaylı araç açıklaması ve kuralları.
  final String description;

  /// Marka ve modeli birleştirerek tam araç adını döner (örn. 'BMW 320i M Sport').
  String get fullName => '$brand $modelName';

  /// Mevcut nesnenin değerlerini koruyarak yalnızca değişen alanları güncellemek için
  /// kullanılan fonksiyonel kopyalama metodu.
  Car copyWith({
    String? id,
    String? brand,
    String? modelName,
    int? year,
    double? dailyPrice,
    FuelType? fuelType,
    TransmissionType? transmission,
    CarCategory? category,
    int? seats,
    String? imageUrl,
    String? ownerId,
    String? ownerName,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
    String? licenseClassRequired,
    int? minLicenseYears,
    String? description,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      modelName: modelName ?? this.modelName,
      year: year ?? this.year,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      category: category ?? this.category,
      seats: seats ?? this.seats,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
      licenseClassRequired: licenseClassRequired ?? this.licenseClassRequired,
      minLicenseYears: minLicenseYears ?? this.minLicenseYears,
      description: description ?? this.description,
    );
  }
}
