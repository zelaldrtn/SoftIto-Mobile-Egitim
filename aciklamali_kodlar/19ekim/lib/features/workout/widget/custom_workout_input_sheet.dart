import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_session.dart';

/// Kullanıcının özel antrenman (süre, kalori, başlık) ekleyebileceği alt sayfa.
// StatefulWidget: kullanıcının girdiği egzersiz adı, süre ve kalori değerlerine göre güncellenen form
class CustomWorkoutInputSheet extends StatefulWidget {
  const CustomWorkoutInputSheet({
    super.key,
    required this.onAddWorkout,
  });

  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    WorkoutIntensity intensity,
  }) onAddWorkout;

  // modal alt pencereyi açmayı sağlayan statik yardımcı fonksiyon
  static Future<void> show(
    BuildContext context, {
    required void Function({
      required String title,
      required int durationMinutes,
      required int caloriesBurned,
      WorkoutIntensity intensity,
    }) onAddWorkout,
  }) {
    // showModalBottomSheet: ekranın altından yukarı doğru açılan modal pencere açar
    return showModalBottomSheet<void>(
      context: context,
      // isScrollControlled: klavye açıldığında formun yukarı kayabilmesini sağlar
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.obsidianBorder),
      ),
      builder: (ctx) => CustomWorkoutInputSheet(onAddWorkout: onAddWorkout),
    );
  }

  @override
  State<CustomWorkoutInputSheet> createState() => _CustomWorkoutInputSheetState();
}

class _CustomWorkoutInputSheetState extends State<CustomWorkoutInputSheet> {
  // late: controller nesnelerinin initState içinde başlatılacağını belirtir
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _caloriesController;

  @override
  // initState: form ilk açıldığında varsayılan başlangıç değerlerini atar
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Özel Antrenman');
    _durationController = TextEditingController(text: '30');
    _caloriesController = TextEditingController(text: '250');
  }

  @override
  // dispose: sayfa kapandığında controller'ları hafızadan temizler (bellek sızıntısını önler)
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  // form onaylandığında çalışan metot
  void _submit() {
    final title = _titleController.text.trim();
    // int.tryParse: girilen metni sayıya çevirir, geçersizse 0 kabul eder
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;

    if (title.isNotEmpty && duration > 0 && calories > 0) {
      widget.onAddWorkout(
        title: title,
        durationMinutes: duration,
        caloriesBurned: calories,
      );
      // Navigator.of(context).pop(): modal pencereyi kapatıp geri döner
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // viewInsetsOf: klavye açıldığında ekranın altından kapladığı piksel yüksekliği
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // EdgeInsets.fromLTRB: sol, üst, sağ ve alt kenarlardan boşluk bırakır (klavye yüksekliği eklenerek)
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      // Column: altındaki widget'ları dikey sırada dizer
      child: Column(
        // MainAxisSize.min: Column'un dikeyde tüm ekranı kaplamak yerine sadece içeriği kadar yer tutmasını sağlar
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          // SizedBox: araya dikeyde 12 birim boşluk bırakır
          const SizedBox(height: 12),
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _titleController,
            label: 'Egzersiz Adı (örn: Boks, Yüzme, Pilates)',
            icon: Icons.fitness_center_rounded,
          ),
          const SizedBox(height: 12),
          // Row: süre ve kalori alanlarını yatayda yan yana dizer
          Row(
            children: [
              // Expanded: süre kutusunun satırın sol yarısını kaplamasını sağlar
              Expanded(
                child: _buildNumberField(
                  controller: _durationController,
                  label: 'Süre',
                  suffix: 'dk',
                ),
              ),
              const SizedBox(width: 12),
              // Expanded: kalori kutusunun satırın sağ yarısını kaplamasını sağlar
              Expanded(
                child: _buildNumberField(
                  controller: _caloriesController,
                  label: 'Kalori',
                  suffix: 'kcal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // pencerenin üstündeki küçük çizgi tutamaç
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.obsidianBorder,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Özel Egzersiz Ekle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Antrenman türünü, süresini ve harcanan kaloriyi girin.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // antrenman başlığı metin kutusu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.neonLime, size: 20),
        filled: true,
        fillColor: AppColors.obsidianSurface,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.obsidianBorder),
        ),
      ),
    );
  }

  // sadece rakam kabul eden süre ve kalori giriş kutusu
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      // FilteringTextInputFormatter.digitsOnly: sadece rakam girişine izin verir
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        suffixText: suffix,
        suffixStyle: const TextStyle(
          color: AppColors.neonLime,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: AppColors.obsidianSurface,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.obsidianBorder),
        ),
      ),
    );
  }

  // formu kaydeden buton
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      // FilledButton.icon: yeşil dolgulu antrenman kaydetme butonu
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.neonLime,
          foregroundColor: AppColors.obsidianBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        onPressed: _submit,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Antrenmanı Kaydet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

