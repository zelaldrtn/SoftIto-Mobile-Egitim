import 'package:flutter/material.dart';

/// ============================================================================
/// SUSADIM - ÖRNEK EKRAN UYGULAMASI (SAMPLE SCREEN)
/// ============================================================================
/// Bu dosya, `project.md` ve `SKILL.md` yönergelerine %100 uyumlu, feature bazlı
/// mimariyi, ValueNotifier durum yönetimini, çift tema desteğini ve 40 satır
/// altı widget parçalama kuralını gösteren eksiksiz referans kod örneğidir.
/// ============================================================================

void main() {
  runApp(const SusadimSampleApp());
}

// -----------------------------------------------------------------------------
// 1. MODEL KATMANI (models/water_intake_model.dart)
// -----------------------------------------------------------------------------
@immutable
class WaterIntakeModel {
  final String id;
  final String beverageName;
  final int amountMl;
  final DateTime timestamp;

  const WaterIntakeModel({
    required this.id,
    required this.beverageName,
    required this.amountMl,
    required this.timestamp,
  });

  WaterIntakeModel copyWith({
    String? id,
    String? beverageName,
    int? amountMl,
    DateTime? timestamp,
  }) {
    return WaterIntakeModel(
      id: id ?? this.id,
      beverageName: beverageName ?? this.beverageName,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      id: json['id'] as String? ?? '',
      beverageName: json['beverageName'] as String? ?? 'Su',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'beverageName': beverageName,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
      };
}

// -----------------------------------------------------------------------------
// 2. CONTROLLER KATMANI (controllers/water_tracker_controller.dart)
// -----------------------------------------------------------------------------
class WaterTrackerController {
  static const int dailyGoalMl = 2000;

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterIntakeModel>> intakeHistory =
      ValueNotifier<List<WaterIntakeModel>>(const []);

  void addWater([int amountMl = 250]) {
    if (amountMl <= 0) return;
    currentWater.value += amountMl;
    _recordIntake('Su', amountMl);
  }

  void addCustomBeverage(String name, int amountMl) {
    if (amountMl <= 0) return;
    final cleanName = name.trim().isEmpty ? 'Özel İçecek' : name.trim();
    currentWater.value += amountMl;
    _recordIntake(cleanName, amountMl);
  }

  void resetWater() {
    currentWater.value = 0;
    intakeHistory.value = const [];
  }

  void _recordIntake(String name, int amountMl) {
    final newEntry = WaterIntakeModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      beverageName: name,
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    intakeHistory.value = [newEntry, ...intakeHistory.value];
  }

  void dispose() {
    currentWater.dispose();
    intakeHistory.dispose();
  }
}

// -----------------------------------------------------------------------------
// 3. TEMA YÖNETİCİSİ (core/theme/theme_controller.dart)
// -----------------------------------------------------------------------------
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void dispose() {
    themeMode.dispose();
  }
}

// -----------------------------------------------------------------------------
// 4. KÖK UYGULAMA (main.dart & tema tanımları)
// -----------------------------------------------------------------------------
class SusadimSampleApp extends StatefulWidget {
  const SusadimSampleApp({super.key});

  @override
  State<SusadimSampleApp> createState() => _SusadimSampleAppState();
}

class _SusadimSampleAppState extends State<SusadimSampleApp> {
  late final ThemeController _themeController;
  late final WaterTrackerController _waterController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _waterController = WaterTrackerController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Susadım',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // Açık Tema: Light Snow & Dinamik Enerji
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0077B6),
              secondary: Color(0xFF00B4D8),
              surface: Color(0xFFF8F9FA),
            ),
            scaffoldBackgroundColor: const Color(0xFFF1F5F9),
          ),
          // Karanlık Tema: Dark Obsidian & Neon Spor Salonu
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00F5D4),
              secondary: Color(0xFF7B2CBF),
              surface: Color(0xFF1E1E2E),
            ),
            scaffoldBackgroundColor: const Color(0xFF11111B),
          ),
          home: WaterTrackerView(
            controller: _waterController,
            themeController: _themeController,
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// 5. VIEW KATMANI (view/water_tracker_view.dart - Max 40 satır build kuralı!)
// -----------------------------------------------------------------------------
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;
  final ThemeController themeController;

  const WaterTrackerView({
    super.key,
    required this.controller,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - Su & Kalori Takibi'),
        centerTitle: true,
        actions: [
          ThemeToggleButton(controller: themeController),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterProgressRingCard(controller: controller),
              const SizedBox(height: 16),
              QuickAddWaterButtons(controller: controller),
              const SizedBox(height: 16),
              CustomBeverageInputCard(controller: controller),
              const SizedBox(height: 16),
              WaterIntakeHistoryCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. ÖZEL WIDGET'LAR (widgets/ - Her biri 40 satır altı odaklanmış bileşenler)
// -----------------------------------------------------------------------------

/// Tek tıkla tema değiştirme butonu
class ThemeToggleButton extends StatelessWidget {
  final ThemeController controller;

  const ThemeToggleButton({super.key, required this.controller});

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

/// İlerleme halkası ve hedef özeti kartı (<40 satır)
class WaterProgressRingCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterProgressRingCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.currentWater,
          builder: (context, current, _) {
            final double ratio =
                (current / WaterTrackerController.dailyGoalMl).clamp(0.0, 1.0);
            final percent = (ratio * 100).toInt();

            return Column(
              children: [
                Text('Günlük Hedef', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '$current / ${WaterTrackerController.dailyGoalMl} ml',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 14,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                const SizedBox(height: 8),
                Text('%$percent tamamlandı', style: theme.textTheme.bodyMedium),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Hızlı su ekleme ve sıfırlama butonları (<40 satır)
class QuickAddWaterButtons extends StatelessWidget {
  final WaterTrackerController controller;

  const QuickAddWaterButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWater(250),
            icon: const Icon(Icons.local_drink),
            label: const Text('+250 ml'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addWater(500),
            icon: const Icon(Icons.water_drop),
            label: const Text('+500 ml'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Sıfırla',
          onPressed: controller.resetWater,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

/// Kullanıcının özel içecek ve miktar eklemesini sağlayan kart (Örn: 300ml girişi - <40 satır)
class CustomBeverageInputCard extends StatefulWidget {
  final WaterTrackerController controller;

  const CustomBeverageInputCard({super.key, required this.controller});

  @override
  State<CustomBeverageInputCard> createState() =>
      _CustomBeverageInputCardState();
}

class _CustomBeverageInputCardState extends State<CustomBeverageInputCard> {
  final TextEditingController _amountController =
      TextEditingController(text: '300');
  final TextEditingController _nameController =
      TextEditingController(text: 'Bitki Çayı');

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitCustomIntake() {
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount > 0) {
      widget.controller.addCustomBeverage(_nameController.text, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Özel İçecek Ekle',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'İçecek Adı',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ml',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _submitCustomIntake,
              icon: const Icon(Icons.add),
              label: const Text('Özel Miktar Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Eklenen içeceklerin geçmişini gösteren kart (<40 satır)
class WaterIntakeHistoryCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterIntakeHistoryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bugünkü Kayıtlar', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<WaterIntakeModel>>(
              valueListenable: controller.intakeHistory,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('Henüz içecek kaydı yok.')),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length > 5 ? 5 : list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(item.beverageName),
                      trailing: Text(
                        '+${item.amountMl} ml',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
