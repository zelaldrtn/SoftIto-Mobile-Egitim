import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/habit_provider.dart';
import '../models/habit.dart';
import '../widgets/circular_progress.dart';
import '../widgets/habit_card.dart';
import '../theme/app_theme.dart';
import 'habit_form_screen.dart';

// bugünün alışkanlıklarını, tamamlama durumlarını ve ilerleme özetini gösteren ana ekran
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch ile HabitProvider'daki her değişikliği dinliyoruz, veri güncellenince ekran yeniden çizilir
    final provider = context.watch<HabitProvider>();
    // uygulamanın karanlık modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // bugünün tarihini alıyoruz
    final now = DateTime.now();

    // bugüne ait planlanmış alışkanlıklar ve tamamlanma sayıları
    final scheduledHabits = provider.getScheduledHabitsForDate(now);
    final completedCount = scheduledHabits
        .where((h) => provider.isHabitCompletedOnDate(h.id, now))
        .length;
    final progress = provider.getProgressForDate(now);
    final todayPoints = provider.getTodayEarnedPoints();
    final streakDays = provider.currentGlobalStreak;

    // tarihi Türkçe biçimlendiriyoruz (örn: "23 Ekim, Cuma")
    final dateFormatted = DateFormat('d MMMM, EEEE', 'tr_TR').format(now);

    return Scaffold(
      // SafeArea çentik ve alt navigasyon çubuğu gibi sistem alanlarına taşmayı engeller
      body: SafeArea(
        // CustomScrollView farklı sliver bileşenlerini tek bir akıcı kaydırma listesinde birleştirir
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter standart widget'ları sliver listesine eklemek için kullanılır
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded satırdaki boş alanın tamamını kaplar
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateFormatted,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Merhaba, ${provider.profile.displayName} ${provider.profile.avatarIcon}',
                                maxLines: 1,
                                // metin satıra sığmazsa sonuna üç nokta koyar
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // App Logo or Point Pill
                        // puan rozetini gösteren kutu
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.cream,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                size: 18,
                                color: isDark ? AppColors.sand : AppColors.forest,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${provider.pointsBalance} P',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.sand : AppColors.forest,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Daily Progress Card
                    // günün ilerleme durumunu gösteren özel kart bileşeni
                    DailyProgressCard(
                      progress: progress,
                      completedCount: completedCount,
                      totalCount: scheduledHabits.length,
                      todayPoints: todayPoints,
                      streakDays: streakDays,
                    ),
                    const SizedBox(height: 24),

                    // Section Header: Alışkanlıklarım & Ekle Butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Bugünün Rutinleri',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            // yeni alışkanlık ekleme sayfasına yönlendirir
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HabitFormScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Yeni Ekle'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.sageGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            textStyle: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Habit List or Empty State
            // eğer bugüne kayıtlı hiçbir alışkanlık yoksa boş durum ekranı gösterilir
            if (scheduledHabits.isEmpty)
              // SliverFillRemaining ekranda geriye kalan tüm boşluğu kaplar
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.cream.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wb_sunny_rounded,
                            size: 40,
                            color: AppColors.sageGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bugün için planlanan alışkanlık yok',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Küçük ve düzenli adımlar büyük dönüşümler yaratır. Hemen yeni bir alışkanlık başlat!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HabitFormScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Yeni Alışkanlık Ekle'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // alışkanlık kartlarını listeleyen sliver yapısı
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  // SliverChildBuilderDelegate elemanları ekranda göründükçe dinamik olarak oluşturur
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = scheduledHabits[index];
                      final isCompleted = provider.isHabitCompletedOnDate(habit.id, now);
                      final streak = provider.calculateHabitStreak(habit);

                      return HabitCard(
                        habit: habit,
                        isCompleted: isCompleted,
                        streakDays: streak,
                        // tıklandığında alışkanlığı tamamlandı veya tamamlanmadı olarak işaretler
                        onToggle: () async {
                          final wasMarked = await provider.toggleCompletion(habit.id, now);
                          // widget hâlâ ekranda mı kontrolü, yoksa context üzerinden bildirim göstermek hata verir
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasMarked
                                      ? 'Harika! +${habit.points} puan kazandın 🎉'
                                      : 'İşlem geri alındı.',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        // düzenleme sayfasına mevcut alışkanlık bilgisiyle gider
                        onEdit: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HabitFormScreen(initialHabit: habit),
                            ),
                          );
                        },
                        onTogglePause: () => provider.togglePauseHabit(habit.id),
                        onDelete: () => _confirmDelete(context, provider, habit),
                      );
                    },
                    childCount: scheduledHabits.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // silme öncesi kullanıcıdan onay isteyen diyalog kutusu
  void _confirmDelete(BuildContext context, HabitProvider provider, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alışkanlığı Sil'),
        content: Text(
          '"${habit.name}" alışkanlığını silmek istediğine emin misin? Geçmiş kayıtların ve kazandığın puanlar korunacaktır.',
        ),
        actions: [
          TextButton(
            // pop açık olan diyalog penceresini kapatır
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              provider.deleteHabit(habit.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

