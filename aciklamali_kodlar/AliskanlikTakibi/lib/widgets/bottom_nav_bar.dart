import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// uygulamanın alt kısmındaki 5 sekmeli özel gezinme çubuğu
class DoItBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DoItBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // o anki temanın koyu modda olup olmadığını anlıyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        // üst kısma ince bir sınır çizgisi çekiyoruz
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      // NavigationBar modern Material 3 alt gezinme çubuğudur
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // seçili sekmenin arkasındaki hap şeklindeki vurgu rengi
        indicatorColor: isDark
            ? AppColors.sageGreen.withOpacity(0.3)
            : AppColors.sand.withOpacity(0.4),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded, color: AppColors.sageGreen),
            label: 'Bugün',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.sageGreen),
            label: 'Takvim',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.sageGreen),
            label: 'Odam',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded, color: AppColors.sageGreen),
            label: 'Analiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.sageGreen),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

