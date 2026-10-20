import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../widgets/profile_stat_card.dart';
import 'settings_view.dart';

/// Profil ve Hesap Yönetim Ekranı.
/// Kullanıcı bilgileri, istatistikler, aktif rol değiştirici (Kiralayan <-> Araç Sahibi),
/// ayarlar navigasyonu ve çıkış işlemlerini sunar.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilim')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _UserInfoCard(),
              SizedBox(height: 16),
              _StatsRow(),
              SizedBox(height: 16),
              _RoleSwitchCard(),
              SizedBox(height: 16),
              _SettingsCard(),
              SizedBox(height: 20),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kullanıcının adı, e-posta adresi ve aktif rol rozetini gösteren kart.
class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 32,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.person, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user?.name ?? 'Kullanıcı',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Chip(
                        avatar: Icon(
                          (user?.role.isOwner ?? false)
                              ? Icons.vpn_key_rounded
                              : Icons.directions_car_filled_rounded,
                          size: 14,
                        ),
                        label: Text(
                          user?.role.title ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tamamlanan işlem sayısı, kullanıcı puanı ve ehliyet bilgilerini gösteren istatistik satırı.
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        return Row(
          children: <Widget>[
            ProfileStatCard(
              title: 'İşlemler',
              value: '${user?.completedCount ?? 0}',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            ProfileStatCard(
              title: 'Kullanıcı Puanı',
              value: '${user?.rating ?? 5.0}',
              icon: Icons.star_rounded,
              color: AppColors.primaryYellow,
            ),
            const SizedBox(width: 8),
            ProfileStatCard(
              title: 'Ehliyet Sınıfı',
              value: '${user?.licenseClass ?? "B"} (${user?.licenseYear ?? 2020})',
              icon: Icons.badge_outlined,
              color: AppColors.primaryBlue,
            ),
          ],
        );
      },
    );
  }
}

/// Kullanıcının Kiralayan ve Araç Sahibi rolleri arasında anında geçiş yapmasını sağlayan SegmentedButton kartı.
class _RoleSwitchCard extends StatelessWidget {
  const _RoleSwitchCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: ValueListenableBuilder<UserProfile?>(
          valueListenable: AuthController.instance.currentUserListenable,
          builder: (BuildContext context, UserProfile? user, _) {
            final bool isOwner = user?.role.isOwner ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Aktif Rol Değiştirici',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Uygulamayı hem Kiralayan hem de Araç Sahibi olarak anında deneyimleyebilirsiniz.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 10),
                SegmentedButton<UserRole>(
                  segments: const <ButtonSegment<UserRole>>[
                    ButtonSegment<UserRole>(
                      value: UserRole.kiralayan,
                      label: Text('Kiralayan'),
                      icon: Icon(Icons.directions_car_rounded),
                    ),
                    ButtonSegment<UserRole>(
                      value: UserRole.aracSahibi,
                      label: Text('Araç Sahibi'),
                      icon: Icon(Icons.vpn_key_rounded),
                    ),
                  ],
                  selected: <UserRole>{
                    isOwner ? UserRole.aracSahibi : UserRole.kiralayan
                  },
                  onSelectionChanged: (Set<UserRole> newSelection) {
                    AuthController.instance.switchRole(newSelection.first);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Rol değiştirildi: ${newSelection.first.title}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Ayarlar sayfasına yönlendirme ve sürüm bilgisi kartı.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Ayarlar'),
            subtitle: const Text('Açık/Koyu tema ve sistem tercihleri'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsView(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Uygulama Sürümü'),
            trailing: Text(
              'v1.0.0 (Material 3)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// Güvenli çıkış butonu ve onay diyaloğu.
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AuthController.instance.logout();
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorRed,
          side: const BorderSide(color: AppColors.errorRed),
        ),
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Çıkış Yap'),
      ),
    );
  }
}
