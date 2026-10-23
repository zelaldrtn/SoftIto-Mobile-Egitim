import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_provider.dart';
import '../models/badge_item.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = provider.profile;
    final badges = provider.badges;
    final unlockedBadges = badges.where((b) => b.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ayarlar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Profile Card (Avatar + Name)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  // Avatar with quick picker
                  GestureDetector(
                    onTap: () => _showAvatarPicker(context, provider),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.sageGreen, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        profile.avatarIcon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Name & Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.displayName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              onPressed: () => _editNameDialog(context, provider),
                            ),
                          ],
                        ),
                        Text(
                          'Yerel Kullanıcı • $unlockedBadges / ${badges.length} Rozet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Badge Showcase (Rozet Koleksiyonu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rozet Koleksiyonu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                  ),
                ),
                Text(
                  '$unlockedBadges Kazanıldı',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sageGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _showBadgeDetail(context, badge),
                    child: Container(
                      decoration: BoxDecoration(
                        color: badge.isUnlocked
                            ? const Color(0x1F63856B)
                            : (isDark ? AppColors.darkSurface : const Color(0x4DF5F1E8)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: badge.isUnlocked
                              ? AppColors.sageGreen
                              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(badge.iconCodePoint, fontFamily: 'MaterialIcons'),
                            size: 28,
                            color: badge.isUnlocked
                                ? (isDark ? AppColors.sand : AppColors.forest)
                                : Colors.grey,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: badge.isUnlocked ? FontWeight.w700 : FontWeight.w500,
                              color: badge.isUnlocked
                                  ? (isDark ? AppColors.darkTextPrimary : AppColors.forest)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // App Settings
            Text(
              'Ayarlar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
              ),
            ),
            const SizedBox(height: 12),

            Material(
              color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  // Theme Selector
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppColors.sageGreen),
                    title: const Text('Tema Tercihi', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(_getThemeLabel(profile.themeMode)),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: profile.themeMode,
                        items: const [
                          DropdownMenuItem(value: 'system', child: Text('Sistem')),
                          DropdownMenuItem(value: 'light', child: Text('Açık')),
                          DropdownMenuItem(value: 'dark', child: Text('Koyu')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            provider.updateProfile(profile.copyWith(themeMode: val));
                          }
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),

                  // Notification Toggle
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_none_rounded, color: AppColors.sageGreen),
                    title: const Text('Günlük Hatırlatıcı', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      profile.notificationsEnabled
                          ? 'Her gün ${profile.reminderHour.toString().padLeft(2, '0')}:${profile.reminderMinute.toString().padLeft(2, '0')} saatinde'
                          : 'Kapalı',
                    ),
                    value: profile.notificationsEnabled,
                    activeThumbColor: AppColors.sageGreen,
                    onChanged: (val) {
                      provider.updateProfile(profile.copyWith(notificationsEnabled: val));
                    },
                  ),
                  if (profile.notificationsEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.access_time_rounded, color: AppColors.sageGreen),
                      title: const Text('Hatırlatıcı Saati', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Text(
                        '${profile.reminderHour.toString().padLeft(2, '0')}:${profile.reminderMinute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.sand : AppColors.forest,
                        ),
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: profile.reminderHour,
                            minute: profile.reminderMinute,
                          ),
                        );
                        if (picked != null) {
                          provider.updateProfile(
                            profile.copyWith(
                              reminderHour: picked.hour,
                              reminderMinute: picked.minute,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About DO IT Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.spa_rounded, color: AppColors.sageGreen, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'DO IT • Sürüm 1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'DO IT, kullanıcıların küçük ve pozitif alışkanlıklar kazanmasını sağlayan, devamlılığı streak sistemiyle destekleyen ve ilerlemeyi oda dekorasyonu ile ödüllendiren sade bir uygulamadır.\n\nTüm verileriniz yalnızca cihazınızda güvenle saklanır.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Açık Tema';
      case 'dark':
        return 'Koyu Tema';
      default:
        return 'Sistem Varsayılanı';
    }
  }

  void _showAvatarPicker(BuildContext context, HabitProvider provider) {
    const avatars = ['🌱', '🌿', '⚡', '🦉', '🦊', '🚀', '☕', '🎯', '✨', '🌊', '🎨', '🏔️'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profil Avatarı Seç', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: avatars.map((a) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        provider.updateProfile(provider.profile.copyWith(avatarIcon: a));
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        alignment: Alignment.center,
                        child: Text(a, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editNameDialog(BuildContext context, HabitProvider provider) {
    final controller = TextEditingController(text: provider.profile.displayName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profil Adını Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Adınız'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.updateProfile(
                  provider.profile.copyWith(displayName: controller.text.trim()),
                );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, BadgeItem badge) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              IconData(badge.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: badge.isUnlocked ? AppColors.sageGreen : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(badge.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? AppColors.sageGreen.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge.isUnlocked ? 'Kazanıldı ✓' : 'Henüz Açılmadı 🔒',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: badge.isUnlocked
                      ? (isDark ? AppColors.sand : AppColors.forest)
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
