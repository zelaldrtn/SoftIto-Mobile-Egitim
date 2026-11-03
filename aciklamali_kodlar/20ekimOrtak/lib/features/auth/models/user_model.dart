import 'user_role.dart';

/// Destek Bul kullanıcı profili modeli.
// kullanıcı kimlik, rol ve profil bilgilerini tutan model sınıfı
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String title;
  final String avatarUrl;
  final double? investmentBudget;
  final int? activeProjectsCount;

  // const constructor: sabit kullanıcı nesneleri üretebilmeyi sağlar
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.title,
    required this.avatarUrl,
    this.investmentBudget,
    this.activeProjectsCount,
  });

  // copyWith: mevcut kullanıcının alanlarını koruyarak sadece istenen değerleri güncellenmiş yeni kopya üretir
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? title,
    String? avatarUrl,
    double? investmentBudget,
    int? activeProjectsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      title: title ?? this.title,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      investmentBudget: investmentBudget ?? this.investmentBudget,
      activeProjectsCount: activeProjectsCount ?? this.activeProjectsCount,
    );
  }
}

