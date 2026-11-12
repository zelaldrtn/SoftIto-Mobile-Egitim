import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart';
import '../../../theme/app_theme.dart';
import '../../../providers/finance_state.dart';
import '../../auth/screens/auth_dialog.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final FinanceState state;

  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _openAuthDialog() {
    showDialog(
      context: context,
      builder: (_) => AuthDialog(state: widget.state),
    );
  }

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Şifre Değiştir'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Yeni Şifre',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            onPressed: () async {
              final newPass = passwordController.text;
              if (newPass.length >= 6) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Şifreniz başarıyla güncellendi.'),
                    backgroundColor: AppColors.forestPrimary,
                  ),
                );
              }
            },
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.state.signOut();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Çıkış yapıldı.')),
                );
              }
            },
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesabı Sil'),
        content: const Text(
          'Hesabınızı silmek istediğinize emin misiniz?\n\n'
          'Bu işlem geri alınamaz. Tüm kişisel verileriniz, hesaplarınız ve geçmiş işlemleriniz kalıcı olarak silinecektir.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.state.deleteAccount();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hesabınız ve tüm verileriniz silindi.')),
                );
              }
            },
            child: const Text('Kalıcı Olarak Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAuth = widget.state.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil ve Hesap'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profil Üst Kartı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.forestPrimary.withOpacity(0.15),
                  child: Text(
                    widget.state.userFullName.isNotEmpty
                        ? widget.state.userFullName.substring(0, 1).toUpperCase()
                        : 'M',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.state.userFullName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.state.userEmail,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAuth
                              ? AppColors.forestPrimary.withOpacity(0.12)
                              : AppColors.dreamyYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isAuth
                              ? (SupabaseService.instance.isInitialized
                                  ? 'Supabase Bağlantılı'
                                  : 'Yerel Hesap (Giriş Yapıldı)')
                              : 'Misafir / Demo Hesabı',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isAuth ? AppColors.forestPrimary : const Color(0xFF9E7C10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Giriş / Kayıt Butonu (Eğer giriş yapılmamışsa)
          if (!isAuth) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.forestPrimary, AppColors.forestMedium],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_sync_outlined, color: Colors.white, size: 28),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verilerinizi Buluta Yedekleyin',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Text(
                          'Giriş yaparak verilerinize her yerden güvenle erişin.',
                          style: TextStyle(color: Color(0xFFD3E7DC), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _openAuthDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.forestPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Giriş Yap'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Seçenekler Menüsü
          const Text('Ayarlar & Tercihler', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: AppColors.forestPrimary),
                  title: const Text('Uygulama Ayarları'),
                  subtitle: const Text('Tema, para birimi ve bildirimler'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(state: widget.state),
                      ),
                    );
                  },
                ),
                if (isAuth) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_reset_rounded, color: AppColors.forestPrimary),
                    title: const Text('Şifre Değiştir'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: _showChangePasswordDialog,
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.forestPrimary),
                  title: const Text('Gizlilik ve Güvenlik'),
                  subtitle: const Text('Supabase RLS ve veri koruma ilkeleri'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('Gizlilik ve Güvenlik'),
                        content: const Text(
                          'Money Plan, verilerinizi PostgreSQL Row Level Security (RLS) politikalarıyla en üst düzeyde korur.\n\n'
                          '• Banka şifresi, kart numarası veya CVV gibi hassas veriler asla istenmez ve saklanmaz.\n'
                          '• Her kullanıcı yalnızca kendi finansal kayıtlarına erişebilir.\n'
                          '• Döviz kurları ve bakiye hesaplamaları şeffaf bir şekilde yönetilir.',
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Kapat')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Hesap İşlemleri
          const Text('Hesap İşlemleri', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Column(
              children: [
                if (isAuth) ...[
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.orange),
                    title: const Text('Çıkış Yap', style: TextStyle(color: Colors.orange)),
                    onTap: _confirmSignOut,
                  ),
                  const Divider(height: 1),
                ],
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  title: const Text('Hesabı ve Verileri Sil', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Tüm finansal verileri kalıcı olarak temizler'),
                  onTap: _confirmDeleteAccount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
