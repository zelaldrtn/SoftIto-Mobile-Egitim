import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  runApp(const SusadimApp());
}

class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Susadım',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: MainNavigationScaffold(
            themeController: _themeController,
            waterController: _waterController,
            workoutController: _workoutController,
          ),
        );
      },
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final ThemeController themeController;
  final WaterTrackerController waterController;
  final WorkoutController workoutController;

  const MainNavigationScaffold({
    super.key,
    required this.themeController,
    required this.waterController,
    required this.workoutController,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        final pages = [
          WaterTrackerView(controller: widget.waterController),
          WorkoutView(controller: widget.workoutController),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(index == 0 ? 'Susadım - Su Takibi' : 'Susadım - Egzersiz & Kalori'),
            actions: [
              _ThemeToggleButton(controller: widget.themeController),
            ],
          ),
          body: SafeArea(child: pages[index]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (val) => _currentIndex.value = val,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop),
                label: 'Su Takibi',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Egzersiz',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final ThemeController controller;

  const _ThemeToggleButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Açık Mod' : 'Karanlık Mod',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: controller.toggleTheme,
        );
      },
    );
  }
}
