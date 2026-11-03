import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../water_tracker/controller/water_tracker_controller.dart';
import '../water_tracker/view/water_tracker_view.dart';
import '../workout/controller/workout_controller.dart';
import '../workout/view/workout_view.dart';

/// Ana ekran ve sekme (tab) yönlendirme kabuğu.
// StatefulWidget: seçili sekme ve controller durumlarına göre güncellenen ana kabuk
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // o an seçili sekmenin sıra numarasını tutar (0: Su Takibi, 1: Egzersiz)
  int _currentIndex = 0;
  // late: controller nesnelerinin hemen değil initState içinde başlatılacağını belirtir
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  // initState: ekran ilk açıldığında bir kez çalışır, controller'lar burada ayağa kaldırılır
  void initState() {
    super.initState();
    _waterController = WaterTrackerController(dailyTargetMl: 3000);
    _workoutController = WorkoutController(
      dailyCalorieTarget: 600,
      dailyDurationTargetMinutes: 45,
    );
  }

  @override
  // dispose: ekran bellekten atılırken controller'ları kapatır ve bellek sızıntısını önler
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  // kullanıcı alt bardan sekmeye bastığında çalışan metot
  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      // setState: seçilen yeni sekme index'ini işleyip ekranın ilgili sayfasını çizer
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel iskeletini oluşturur
    return Scaffold(
      appBar: _buildAppBar(),
      // üçlü koşul: seçili sekmeye göre su takibi veya egzersiz sayfasını ekranda gösterir
      body: _currentIndex == 0
          ? WaterTrackerView(controller: _waterController)
          : WorkoutView(controller: _workoutController),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // üst başlık alanını (AppBar) oluşturan metot
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
              // SizedBox: araya yatayda 8 birim sabit boşluk bırakır
              const SizedBox(width: 8),
              Container(
                // EdgeInsets: kutunun içine yatay ve dikey boşluk verir
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // BoxDecoration: rozet kutusuna arka plan rengi ve yuvarlak köşe sağlar
                decoration: const BoxDecoration(
                  color: AppColors.obsidianSurface,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Row(
                  // MainAxisSize.min: içeriği kadar yer kaplamasını sağlar
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

  // alt gezinme çubuğunu oluşturan metot
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

  // sıfırlama onay diyalog kutusu
  void _showResetDialog() {
    // showDialog: ekranda açılır onay penceresi (AlertDialog) gösterir
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
            // Navigator.of(ctx).pop(): açılan diyaloğu kapatır
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              // controller metotlarını çağırarak verileri sıfırlar
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

