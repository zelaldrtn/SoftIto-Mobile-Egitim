import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../water_tracker/controller/water_tracker_controller.dart';
import '../water_tracker/view/water_tracker_view.dart';
import '../workout/controller/workout_controller.dart';
import '../workout/view/workout_view.dart';

/// Ana ekran ve sekme (tab) yönlendirme kabuğu.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController(dailyTargetMl: 3000);
    _workoutController = WorkoutController(
      dailyCalorieTarget: 600,
      dailyDurationTargetMinutes: 45,
    );
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _currentIndex == 0
          ? WaterTrackerView(controller: _waterController)
          : WorkoutView(controller: _workoutController),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SUSADIM',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: _currentIndex == 0
                      ? AppColors.neonCyan
                      : AppColors.neonLime,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.obsidianSurface,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔥 3 Gün', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          Text(
            _currentIndex == 0
                ? 'Akıllı Su Takibi'
                : 'Egzersiz & Kalori',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
          tooltip: 'Günü Sıfırla',
          onPressed: _showResetDialog,
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onTabSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop_rounded),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center_rounded),
          label: 'Egzersiz',
        ),
      ],
    );
  }

  void _showResetDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.obsidianCard,
        title: const Text('Günlük Verileri Sıfırla'),
        content: const Text(
          'Bugüne ait tüm su ve egzersiz kayıtları sıfırlanacak. Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              _waterController.resetDaily();
              _workoutController.resetDaily();
              Navigator.of(ctx).pop();
            },
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }
}
