import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_provider.dart';
import '../theme/app_theme.dart';

class WrappedScreen extends StatefulWidget {
  const WrappedScreen({super.key});

  @override
  State<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends State<WrappedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final wrappedData = provider.getWrappedData();
    final bool hasData = wrappedData['hasData'] as bool;

    return Scaffold(
      backgroundColor: AppColors.forest,
      body: SafeArea(
        child: hasData
            ? Column(
                children: [
                  // Top progress bar / stories indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: index <= _currentPage
                                  ? AppColors.sand
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  // Swipeable Story Cards
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                      children: [
                        // Slide 1: Welcome & Overview
                        _buildStorySlide(
                          emoji: '✨',
                          title: '${wrappedData['monthName']} ${wrappedData['year']}',
                          subtitle: 'DO IT Aylık Özeti',
                          body: 'Bu ay disiplinini korumak ve kendini geliştirmek için harika adımlar attın.\n\nHazırsan yolculuğunu keşfedelim!',
                        ),

                        // Slide 2: Active Days & Total Logs
                        _buildStorySlide(
                          emoji: '📅',
                          title: '${wrappedData['activeDays']} Aktif Gün',
                          subtitle: 'Zamanını Verimli Kıldın',
                          body: 'Bu ay tam ${wrappedData['activeDays']} farklı günde en az bir alışkanlığını tamamladın.\n\nToplam ${wrappedData['totalLogs']} kez "DO IT" dedin!',
                        ),

                        // Slide 3: Top Habit
                        _buildStorySlide(
                          emoji: '🏆',
                          title: wrappedData['topHabitName'] ?? 'Düzenli Adımlar',
                          subtitle: 'En İstikrarlı Alışkanlığın',
                          body: wrappedData['topHabitName'] != null
                              ? '"${wrappedData['topHabitName']}" alışkanlığını tam ${wrappedData['topHabitCount']} kez tamamlayarak ayın yıldızı yaptın!'
                              : 'Tüm alışkanlıklarında dengeli bir ilerleme kaydettin.',
                        ),

                        // Slide 4: Points Earned
                        _buildStorySlide(
                          emoji: '⭐',
                          title: '+${wrappedData['earnedPoints']} Puan',
                          subtitle: 'Kazandığın Başarı',
                          body: 'Bu ay alışkanlıkların sayesinde tam ${wrappedData['earnedPoints']} DO IT puanı topladın ve odanı süslemeye devam ettin!',
                        ),

                        // Slide 5: Motivation & Wrap
                        _buildStorySlide(
                          emoji: '🌱',
                          title: 'İstikrar Büyümektir',
                          subtitle: 'Yolculuğa Devam!',
                          body: 'Her küçük çaba, uzun vadede büyük bir yaşam tarzına dönüşür.\n\nÖnümüzdeki ay daha da parlak olacak!',
                          actionButton: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.sand,
                              foregroundColor: AppColors.forest,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Rutinlerime Dön'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tap cues
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _currentPage > 0
                              ? () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          child: Text(
                            'Geri',
                            style: TextStyle(
                              color: _currentPage > 0 ? Colors.white70 : Colors.transparent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _currentPage < 4
                              ? () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : () => Navigator.of(context).pop(),
                          child: Text(
                            _currentPage < 4 ? 'İleri' : 'Bitir',
                            style: const TextStyle(color: AppColors.sand, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            // Empty State (No fake data!)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.insights_rounded,
                          size: 56,
                          color: AppColors.sand,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Henüz Yeterli Veri Yok',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aylık Wrapped hikâyen gerçek alışkanlık kayıtlarından oluşturulur. Birkaç gün boyunca alışkanlıklarını tamamladığında aylık özetin burada parlayacak!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sand,
                          foregroundColor: AppColors.forest,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Bugüne Dön'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStorySlide({
    required String emoji,
    required String title,
    required String subtitle,
    required String body,
    Widget? actionButton,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 24),
            Text(
              subtitle.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.sand.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.85),
                height: 1.5,
              ),
            ),
            if (actionButton != null) ...[
              const SizedBox(height: 36),
              actionButton,
            ],
          ],
        ),
      ),
    );
  }
}
