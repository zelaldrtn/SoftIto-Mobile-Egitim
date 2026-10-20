/// Kullanıcı rollerini (Araç Sahibi ve Kiralayan) tanımlayan enum.
/// Her rolün başlığı ve sistemdeki işlevini anlatan açıklaması bulunur.
enum UserRole {
  aracSahibi('Araç Sahibi', 'Araç ekle, ilanları yönet ve talepleri onayla'),
  kiralayan('Kiralayan', 'Araçları incele, filtrele ve rezervasyon yap');

  const UserRole(this.title, this.description);

  /// Arayüzde buton ve sekmelerde gösterilen rol başlığı.
  final String title;

  /// Rol seçim ekranında kullanıcıyı bilgilendiren açıklama metni.
  final String description;

  /// Rolün 'Araç Sahibi' olup olmadığını sorgular.
  bool get isOwner => this == UserRole.aracSahibi;

  /// Rolün 'Kiralayan' olup olmadığını sorgular.
  bool get isRenter => this == UserRole.kiralayan;
}

/// Platformdaki kullanıcının profil ve ehliyet bilgilerini saklayan değişmez veri modeli.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.licenseClass = 'B',
    this.licenseYear = 2020,
    this.rating = 4.9,
    this.completedCount = 12,
  });

  /// Kullanıcının benzersiz kimlik numarası.
  final String id;

  /// Kullanıcının adı ve soyadı.
  final String name;

  /// Kullanıcının sisteme kayıtlı e-posta adresi.
  final String email;

  /// İletişim telefon numarası.
  final String phone;

  /// Kullanıcının aktif çalışma rolü (Araç Sahibi veya Kiralayan).
  final UserRole role;

  /// Kullanıcının sahip olduğu sürücü belgesi sınıfı (örn. 'B').
  final String licenseClass;

  /// Sürücü belgesinin ilk alındığı yıl (tecrübe yılı hesabında kullanılır).
  final int licenseYear;

  /// Kullanıcının sistemdeki puanı (1.0 - 5.0).
  final double rating;

  /// Tamamlanan toplam kiralama veya kiraya verme sayısı.
  final int completedCount;

  /// Belirli alanları güncelleyerek yeni bir UserProfile kopyası oluşturur.
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? licenseClass,
    int? licenseYear,
    double? rating,
    int? completedCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      licenseClass: licenseClass ?? this.licenseClass,
      licenseYear: licenseYear ?? this.licenseYear,
      rating: rating ?? this.rating,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}
