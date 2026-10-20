import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';

/// Ayarlar Ekranı: Kullanıcının tema tercihlerini (Aydınlık, Karanlık, Sistem)
/// değiştirmesini ve hesabından güvenli çıkış yapmasını sağlar.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        leading: BackButton(
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ThemeSelectionSection(),
              SizedBox(height: 16),
              _AppInfoSection(),
              SizedBox(height: 24),
              _SafeLogoutSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tema modu (Aydınlık, Karanlık, Sistem) seçim kartı.
class _ThemeSelectionSection extends StatelessWidget {
  const _ThemeSelectionSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Görünüm ve Tema',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Divider(height: 1),
            // ThemeController üzerindeki tema değişikliğini anlık olarak dinler ve yansıtır.
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.instance.themeModeNotifier,
              builder: (BuildContext context, ThemeMode mode, _) {
                return RadioGroup<ThemeMode>(
                  groupValue: mode,
                  onChanged: (ThemeMode? val) {
                    if (val != null) {
                      ThemeController.instance.setThemeMode(val);
                    }
                  },
                  child: const Column(
                    children: <Widget>[
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text('Aydınlık Tema'),
                        subtitle: Text('Ferah, beyaz ve mavi tonlar'),
                        secondary: Icon(Icons.light_mode_rounded),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text('Karanlık Tema'),
                        subtitle: Text('Göz yormayan siyah ve sarı vurgular'),
                        secondary: Icon(
                          Icons.dark_mode_rounded,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text('Sistem Temasını Takip Et'),
                        subtitle: Text('Cihazın varsayılan temasını uygula'),
                        secondary: Icon(Icons.settings_brightness_rounded),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Uygulama adı ve sürüm bilgilerini gösteren bilgi kartı.
class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.verified_user_outlined),
            title: Text('Uygulama Adı'),
            trailing: Text(
              'Araç Kiralama',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Sürüm'),
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

/// Güvenli çıkış onay diyaloğunu açan ve oturumu sonlandıran bölüm.
class _SafeLogoutSection extends StatelessWidget {
  const _SafeLogoutSection();

  /// Kullanıcıya çıkış yapmak istediğini soran güvenlik onay diyaloğu.
  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Güvenli Çıkış'),
        content: const Text(
          'Hesabınızdan güvenli olarak çıkış yapmak istediğinize emin misiniz? Oturumunuz kapatılacaktır.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Onay diyaloğunu kapat
              Navigator.maybePop(context); // Ayarlar sayfasını kapat
              AuthController.instance.logout(); // Kullanıcı oturumunu sonlandır
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
        label: const Text('Güvenli Çıkış Yap'),
      ),
    );
  }
}
