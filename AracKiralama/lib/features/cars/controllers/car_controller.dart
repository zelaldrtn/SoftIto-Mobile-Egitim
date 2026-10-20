import 'package:flutter/foundation.dart';
import '../models/car_model.dart';

/// Araç listeleme, arama ve filtreleme iş mantığını yöneten merkezi denetleyici.
/// Singleton deseniyle çalışır ve uygulamanın her yerinden aynı veri kümesine
/// reaktif biçimde erişilmesini sağlar.
class CarController {
  // Özel kurucu: Filtre dinleyicilerini bağlar ve ilk filtrelemeyi uygular.
  CarController._() {
    _carsNotifier = ValueNotifier<List<Car>>(_initialCars);
    // Kullanıcı arama yaptığında, kategori değiştirdiğinde veya fiyat sınırını
    // ayarladığında filtreleri otomatik olarak yeniden hesapla.
    searchQueryNotifier.addListener(_applyFilters);
    selectedCategoryNotifier.addListener(_applyFilters);
    maxPriceNotifier.addListener(_applyFilters);
    _applyFilters();
  }

  /// Singleton örneği: Tüm ekranlar tek bir kaynak üzerinden güncellenir.
  static final CarController instance = CarController._();

  /// Sistemdeki tüm araçların ham listesini tutan reaktif bildirimci.
  late final ValueNotifier<List<Car>> _carsNotifier;

  /// Arama, kategori ve fiyat filtrelerinden geçerek arayüzde gösterilen araç listesi.
  final ValueNotifier<List<Car>> filteredCarsNotifier =
      ValueNotifier<List<Car>>(<Car>[]);

  /// Arama çubuğundaki metni saklar (Debounce ile beslenir).
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');

  /// Kullanıcının seçtiği araç kategorisi (varsayılan: Tüm Araçlar).
  final ValueNotifier<CarCategory> selectedCategoryNotifier =
      ValueNotifier<CarCategory>(CarCategory.tum);

  /// Filtrelemede baz alınan azami günlük kiralama ücreti (varsayılan: 10.000 ₺).
  final ValueNotifier<double> maxPriceNotifier =
      ValueNotifier<double>(10000.0);

  /// Ham araç listesini dışarıya salt-okunur (ValueListenable) olarak sunar.
  ValueListenable<List<Car>> get carsListenable => _carsNotifier;

  /// Arama sorgusu, seçili kategori ve bütçe kriterlerini uygulayarak
  /// `filteredCarsNotifier` değerini günceller.
  void _applyFilters() {
    final String query = searchQueryNotifier.value.toLowerCase().trim();
    final CarCategory cat = selectedCategoryNotifier.value;
    final double maxPrice = maxPriceNotifier.value;

    final List<Car> result = _carsNotifier.value.where((Car car) {
      // Marka veya model adı arama sorgusunu içeriyor mu?
      final bool matchesQuery = query.isEmpty ||
          car.brand.toLowerCase().contains(query) ||
          car.modelName.toLowerCase().contains(query);

      // Kategori 'Tümü' seçilmişse veya aracın kategorisi eşleşiyorsa kabul et.
      final bool matchesCategory =
          cat == CarCategory.tum || car.category == cat;

      // Günlük kiralama ücreti kullanıcının bütçe sınırının altında mı?
      final bool matchesPrice = car.dailyPrice <= maxPrice;

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();

    filteredCarsNotifier.value = result;
  }

  /// Yeni araç ilanı ekler ve listenin başına yerleştirir.
  void addCar(Car car) {
    _carsNotifier.value = <Car>[car, ..._carsNotifier.value];
    _applyFilters();
  }

  /// Var olan araç ilanının bilgilerini günceller.
  void updateCar(Car updatedCar) {
    final List<Car> list = _carsNotifier.value.map((Car c) {
      return c.id == updatedCar.id ? updatedCar : c;
    }).toList();
    _carsNotifier.value = list;
    _applyFilters();
  }

  /// Belirtilen kimliğe sahip araç ilanını sistemden siler.
  void deleteCar(String carId) {
    _carsNotifier.value =
        _carsNotifier.value.where((Car c) => c.id != carId).toList();
    _applyFilters();
  }

  /// Belirtilen araç kimliğine göre aracı bulur, yoksa null döner.
  Car? getCarById(String id) {
    try {
      return _carsNotifier.value.firstWhere((Car c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Belirtilen araç sahibine (ownerId) ait olan ilanları filtreleyip döner.
  List<Car> getCarsByOwner(String ownerId) {
    return _carsNotifier.value.where((Car c) => c.ownerId == ownerId).toList();
  }

  /// Uygulama ilk açıldığında gösterilen örnek araç verileri.
  static const List<Car> _initialCars = <Car>[
    Car(
      id: 'car_1',
      brand: 'BMW',
      modelName: '320i M Sport',
      year: 2024,
      dailyPrice: 2850.0,
      fuelType: FuelType.benzin,
      transmission: TransmissionType.otomatik,
      category: CarCategory.sedan,
      seats: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_owner_1',
      ownerName: 'Mert Aksoy',
      rating: 4.9,
      reviewCount: 32,
      isAvailable: true,
      minLicenseYears: 2,
    ),
    Car(
      id: 'car_2',
      brand: 'Mercedes-Benz',
      modelName: 'C200 4MATIC AMG',
      year: 2023,
      dailyPrice: 3100.0,
      fuelType: FuelType.hibrit,
      transmission: TransmissionType.otomatik,
      category: CarCategory.sedan,
      seats: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_1',
      ownerName: 'Ahmet Yılmaz',
      rating: 4.95,
      reviewCount: 45,
      isAvailable: true,
      minLicenseYears: 3,
    ),
    Car(
      id: 'car_3',
      brand: 'Tesla',
      modelName: 'Model Y Long Range',
      year: 2024,
      dailyPrice: 3400.0,
      fuelType: FuelType.elektrik,
      transmission: TransmissionType.otomatik,
      category: CarCategory.elektrikli,
      seats: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_owner_2',
      ownerName: 'Canan Kaya',
      rating: 5.0,
      reviewCount: 27,
      isAvailable: true,
      minLicenseYears: 2,
    ),
    Car(
      id: 'car_4',
      brand: 'Porsche',
      modelName: 'Taycan 4S',
      year: 2023,
      dailyPrice: 6500.0,
      fuelType: FuelType.elektrik,
      transmission: TransmissionType.otomatik,
      category: CarCategory.spor,
      seats: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_owner_3',
      ownerName: 'Burak Serbest',
      rating: 4.98,
      reviewCount: 19,
      isAvailable: true,
      minLicenseYears: 4,
    ),
    Car(
      id: 'car_5',
      brand: 'Volvo',
      modelName: 'XC60 B5 AWD',
      year: 2023,
      dailyPrice: 2950.0,
      fuelType: FuelType.hibrit,
      transmission: TransmissionType.otomatik,
      category: CarCategory.suv,
      seats: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_1',
      ownerName: 'Ahmet Yılmaz',
      rating: 4.88,
      reviewCount: 21,
      isAvailable: true,
      minLicenseYears: 2,
    ),
    Car(
      id: 'car_6',
      brand: 'Volkswagen',
      modelName: 'Golf R-Line 1.5 eTSI',
      year: 2024,
      dailyPrice: 1950.0,
      fuelType: FuelType.benzin,
      transmission: TransmissionType.otomatik,
      category: CarCategory.hatchback,
      seats: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
      ownerId: 'user_owner_4',
      ownerName: 'Ege Çetin',
      rating: 4.82,
      reviewCount: 38,
      isAvailable: true,
      minLicenseYears: 1,
    ),
  ];
}
