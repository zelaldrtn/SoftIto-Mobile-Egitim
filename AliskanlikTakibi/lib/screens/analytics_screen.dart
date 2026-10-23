import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/habit_provider.dart';
import '../theme/app_theme.dart';
import 'wrapped_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weeklyStats = provider.getWeeklyStats();
    final List<Map<String, dynamic>> dailyBars = weeklyStats['daily'] as List<Map<String, dynamic>>;
    final double weeklyRate = (weeklyStats['overallRate'] as double);
    final int weeklyDone = (weeklyStats['totalDone'] as int);

    final mostConsistent = provider.getMostConsistentHabit();
    final totalCompletions = provider.logs.length;
    final totalPoints = provider.pointsBalance;
    final bestStreak = provider.currentGlobalStreak;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistik & Analiz'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // DO IT Wrapped Teaser Card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.forest, Color(0xFF385549)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forest.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WrappedScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.sand.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.sand,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'DO IT Wrapped',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Aylık başarı ve istikrar hikâyene göz at',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD6DFD9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.sand,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4 Summary Metric Cards (2x2 Grid)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'Tamamlanan',
                    value: '$totalCompletions Adet',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.sageGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'En İstikrarlı',
                    value: mostConsistent?.name ?? 'Henüz Yok',
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.sand,
                    isTextSmall: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'Mevcut Bakiye',
                    value: '$totalPoints Puan',
                    icon: Icons.stars_rounded,
                    color: isDark ? AppColors.sand : AppColors.forest,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'En Yüksek Streak',
                    value: '$bestStreak Gün',
                    icon: Icons.local_fire_department_outlined,
                    color: AppColors.sageGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly Completion Rate & Bar Chart
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Son 7 Gün İlerlemesi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Toplam $weeklyDone tamamlanma (%${(weeklyRate * 100).toInt()})',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '%${(weeklyRate * 100).toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF88CCA0) : AppColors.forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Weekly Bars
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dailyBars.map((bar) {
                        final date = bar['date'] as DateTime;
                        final double rate = (bar['rate'] as double);
                        final int done = (bar['done'] as int);
                        final dayShort = DateFormat('E', 'tr_TR').format(date);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (done > 0)
                              Text(
                                '$done',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                                ),
                              ),
                            const SizedBox(height: 4),
                            // Bar container
                            Container(
                              width: 22,
                              height: 60 * (rate == 0 ? 0.08 : rate),
                              decoration: BoxDecoration(
                                color: rate >= 1.0
                                    ? AppColors.sageGreen
                                    : (rate > 0
                                        ? AppColors.sand
                                        : (isDark ? AppColors.darkSurface : AppColors.cream)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dayShort,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Habit-Based Consistency Breakdown
            Text(
              'Alışkanlık Bazlı Başarı',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
              ),
            ),
            const SizedBox(height: 12),

            if (provider.habits.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Henüz eklenmiş bir alışkanlık yok.'),
                ),
              )
            else
              ...provider.habits.map((habit) {
                final completedCount = provider.logs.where((l) => l.habitId == habit.id).length;
                final streak = provider.calculateHabitStreak(habit);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: habit.category.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                          size: 20,
                          color: habit.category.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Toplam $completedCount kez tamamlandı',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (streak > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sageGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$streak gün 🔥',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forest,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isTextSmall = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isTextSmall ? 15 : 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
            ),
          ),
        ],
      ),
    );
  }
}
