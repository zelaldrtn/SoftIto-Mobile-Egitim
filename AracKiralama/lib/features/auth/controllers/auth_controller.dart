import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Kimlik doğrulama, kullanıcı oturumu ve aktif kullanıcı rolü yönetim sınıfı.
/// `ValueNotifier` mimarisi kullanarak tüm uygulama genelinde anlık oturum ve rol senkronizasyonu sağlar.
class AuthController {
  // Özel kurucu: Başlangıçta demo kiralayan profili yüklenir.
  AuthController._() {
    _currentUserNotifier = ValueNotifier<UserProfile?>(
      const UserProfile(
        id: 'user_1',
        name: 'Ahmet Yılmaz',
        email: 'ahmet.yilmaz@example.com',
        phone: '+90 532 555 0123',
        role: UserRole.kiralayan,
        licenseClass: 'B',
        licenseYear: 2019,
        rating: 4.95,
        completedCount: 14,
      ),
    );
  }

  /// Singleton örneği: Uygulama genelinde tek bir oturum durumu yönetilir.
  static final AuthController instance = AuthController._();

  /// Oturum açmış olan kullanıcının profil verisini tutan reaktif bildirimci.
  late final ValueNotifier<UserProfile?> _currentUserNotifier;

  /// Giriş ekranında veya profil menüsünde seçili rolü takip eden bildirimci.
  final ValueNotifier<UserRole> selectedRoleNotifier =
      ValueNotifier<UserRole>(UserRole.kiralayan);

  /// Kullanıcı oturumundaki değişiklikleri dinlemek için dışa açılan ValueListenable.
  ValueListenable<UserProfile?> get currentUserListenable =>
      _currentUserNotifier;

  /// Şu anki oturum açmış kullanıcı (oturum kapalıysa null).
  UserProfile? get currentUser => _currentUserNotifier.value;

  /// Kullanıcının oturum açıp açmadığını sorgular.
  bool get isLoggedIn => _currentUserNotifier.value != null;

  /// Aktif kullanıcının 'Araç Sahibi' rolünde olup olmadığını döner.
  bool get isOwner => _currentUserNotifier.value?.role.isOwner ?? false;

  /// Aktif kullanıcının 'Kiralayan' rolünde olup olmadığını döner.
  bool get isRenter => _currentUserNotifier.value?.role.isRenter ?? true;

  /// Kullanıcı rolünü anında değiştirir (Araç Sahibi <-> Kiralayan).
  /// Bu metot tetiklendiğinde alt gezinme çubuğu (BottomNavigationBar) ve ilgili ekranlar
  /// yeni role göre anında yeniden oluşturulur.
  void switchRole(UserRole newRole) {
    selectedRoleNotifier.value = newRole;
    final UserProfile? user = _currentUserNotifier.value;
    if (user != null) {
      _currentUserNotifier.value = user.copyWith(role: newRole);
    }
  }

  /// Demo giriş simülasyonu: Seçilen rol ve e-posta ile yeni oturum oluşturur.
  void login({
    required String email,
    required String password,
    required UserRole role,
  }) {
    selectedRoleNotifier.value = role;
    _currentUserNotifier.value = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: role.isOwner ? 'Mehmet Demir (Araç Sahibi)' : 'Ahmet Yılmaz',
      email: email,
      phone: '+90 532 555 4321',
      role: role,
      licenseClass: 'B',
      licenseYear: 2018,
      rating: 4.9,
      completedCount: role.isOwner ? 28 : 14,
    );
  }

  /// Yeni kullanıcı kayıt simülasyonu: Ehliyet ve iletişim bilgileriyle profil oluşturur.
  void register({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required String licenseClass,
    required int licenseYear,
  }) {
    selectedRoleNotifier.value = role;
    _currentUserNotifier.value = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      licenseClass: licenseClass,
      licenseYear: licenseYear,
      rating: 5.0,
      completedCount: 0,
    );
  }

  /// Mevcut oturumu kapatır ve kullanıcıyı oturum açma ekranına yönlendirilmeye hazır hale getirir.
  void logout() {
    _currentUserNotifier.value = null;
  }
}
