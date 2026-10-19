import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../water_tracker/controllers/water_tracker_controller.dart';
import '../../water_tracker/view/water_tracker_view.dart';
import '../../workout/controllers/workout_controller.dart';
import '../../workout/view/workout_view.dart';

/// Ana ekran ve sekmeler arası geçişi sağlayan ana arayüz.
class HomeView extends StatefulWidget {
  final ThemeController themeController;

  const HomeView({
    super.key,
    required this.themeController,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          WaterTrackerView(controller: _waterController),
          WorkoutView(controller: _workoutController),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final isDark = widget.themeController.isDark;
    return AppBar(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Susadım v1'),
        ],
      ),
      actions: [
        IconButton(
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? AppColors.neonOrange : AppColors.lightCyan,
          ),
          onPressed: widget.themeController.toggleTheme,
        ),
        IconButton(
          tooltip: 'Günlük Veriyi Sıfırla',
          icon: Icon(
            Icons.refresh_rounded,
            color: AppColors.textSecondaryFor(isDark),
          ),
          onPressed: _showResetConfirmDialog,
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final isDark = widget.themeController.isDark;
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      indicatorColor: _currentIndex == 0
          ? AppColors.waterGlassFor(isDark)
          : AppColors.workoutGlassFor(isDark),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(
            Icons.water_drop_rounded,
            color: AppColors.primaryFor(isDark),
          ),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: const Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(
            Icons.fitness_center_rounded,
            color: AppColors.secondaryFor(isDark),
          ),
          label: 'Egzersiz',
        ),
      ],
    );
  }

  void _showResetConfirmDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bugünü Sıfırla'),
        content: const Text(
          'Bugünkü su ve antrenman kayıtlarını sıfırlamak istiyor musunuz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonCoral,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _waterController.resetWater();
              _workoutController.resetWorkout();
              Navigator.of(ctx).pop();
            },
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }
}
