import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

/// Kimlik doğrulama, yatırımcı / girişimci giriş yönetimini sağlayan Controller.
/// Saf Flutter ValueNotifier mimarisini kullanır.
class AuthController {
  AuthController._();
  static final AuthController instance = AuthController._();

  /// Aktif giriş yapmış kullanıcı
  final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(null);

  /// Giriş ekranında seçili rol
  final ValueNotifier<UserRole> selectedRoleNotifier =
      ValueNotifier<UserRole>(UserRole.investor);

  /// Giriş işlemi yükleniyor durumu
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  /// Rol seçimini değiştir
  void setSelectedRole(UserRole role) {
    selectedRoleNotifier.value = role;
  }

  /// Yatırımcı veya Girişimci girişi yap
  void login({
    required String email,
    required String password,
    required UserRole role,
    String? name,
  }) {
    isLoadingNotifier.value = true;

    final String resolvedName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : (role.isInvestor ? 'Ahmet Yılmaz' : 'Selin Kaya');

    final UserModel user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: resolvedName,
      email: email.trim().isEmpty
          ? (role.isInvestor ? 'yatirimci@destekbul.com' : 'girisimci@destekbul.com')
          : email.trim(),
      role: role,
      title: role.isInvestor ? 'Melek Yatırımcı & Mentor' : 'Kurucu Ortak & CEO',
      avatarUrl: role.isInvestor
          ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'
          : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      investmentBudget: role.isInvestor ? 1500000.0 : null,
      activeProjectsCount: role.isEntrepreneur ? 2 : null,
    );

    currentUserNotifier.value = user;
    isLoadingNotifier.value = false;
  }

  /// Hızlı test için örnek role doğrudan giriş
  void loginDemo(UserRole role) {
    setSelectedRole(role);
    login(
      email: role.isInvestor ? 'yatirimci@destekbul.com' : 'girisimci@destekbul.com',
      password: 'password123',
      role: role,
      name: role.isInvestor ? 'Barış Eren' : 'Elif Demir',
    );
  }

  /// Oturumu kapat
  void logout() {
    currentUserNotifier.value = null;
  }
}
