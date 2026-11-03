import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/habit_provider.dart';
import '../theme/app_theme.dart';

// yeni alışkanlık oluşturma veya mevcut alışkanlığı düzenleme formu
class HabitFormScreen extends StatefulWidget {
  // düzenleme yapılacaksa mevcut alışkanlık buraya gönderilir, null ise yeni kayıt açılır
  final Habit? initialHabit;

  const HabitFormScreen({super.key, this.initialHabit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  // formun doğrulama (validation) işlemlerini kontrol eden anahtar
  final _formKey = GlobalKey<FormState>();

  // metin alanlarını dinleyen ve değerlerini tutan kontrolcüler
  late TextEditingController _nameController;
  late TextEditingController _goalController;

  late HabitCategory _selectedCategory;
  late int _selectedIconCode;
  late HabitFrequencyType _selectedFrequency;
  late List<int> _selectedDays;
  late HabitDifficulty _selectedDifficulty;
  // kullanıcının seçtiği hatırlatma saati (opsiyonel)
  TimeOfDay? _selectedReminderTime;

  // kullanıcıya sunulan hazır simge listesi
  final List<IconData> _availableIcons = [
    Icons.water_drop_rounded,
    Icons.menu_book_rounded,
    Icons.fitness_center_rounded,
    Icons.directions_walk_rounded,
    Icons.spa_rounded,
    Icons.bedtime_rounded,
    Icons.timer_rounded,
    Icons.palette_rounded,
    Icons.music_note_rounded,
    Icons.self_improvement_rounded,
    Icons.code_rounded,
    Icons.psychology_rounded,
    Icons.brush_rounded,
    Icons.local_cafe_rounded,
    Icons.apple_rounded,
    Icons.stars_rounded,
  ];

  @override
  void initState() {
    super.initState();
    final habit = widget.initialHabit;
    // eğer düzenleme modundaysak mevcut bilgileri dolduruyoruz, yoksa varsayılan boş değerler veriyoruz
    _nameController = TextEditingController(text: habit?.name ?? '');
    _goalController = TextEditingController(text: habit?.goal ?? '');
    _selectedCategory = habit?.category ?? HabitCategory.saglik;
    _selectedIconCode = habit?.iconCodePoint ?? Icons.star_rounded.codePoint;
    _selectedFrequency = habit?.frequencyType ?? HabitFrequencyType.everyDay;
    _selectedDays = habit != null ? List<int>.from(habit.selectedDays) : [1, 2, 3, 4, 5, 6, 7];
    _selectedDifficulty = habit?.difficulty ?? HabitDifficulty.easy;

    // kayıtlı hatırlatma saati metnini TimeOfDay nesnesine dönüştürüyoruz
    if (habit?.reminderTime != null && habit!.reminderTime!.contains(':')) {
      final parts = habit.reminderTime!.split(':');
      _selectedReminderTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 8,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
  }

  @override
  void dispose() {
    // bellek sızıntısını önlemek için controller'ları serbest bırakıyoruz
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // formu doğrulayıp yeni alışkanlığı kaydeden veya güncelleyen metod
  void _saveHabit() {
    // formdaki kurallara uyulmamışsa işlemi durdur
    if (!_formKey.currentState!.validate()) return;

    // ekranı yeniden çizdirmeye gerek olmadan provider metodunu çağırmak için read kullanıyoruz
    final provider = context.read<HabitProvider>();
    final reminderString = _selectedReminderTime != null
        ? '${_selectedReminderTime!.hour.toString().padLeft(2, '0')}:${_selectedReminderTime!.minute.toString().padLeft(2, '0')}'
        : null;

    if (widget.initialHabit == null) {
      // yeni alışkanlık kaydı
      final newHabit = Habit(
        id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        goal: _goalController.text.trim(),
        category: _selectedCategory,
        iconCodePoint: _selectedIconCode,
        frequencyType: _selectedFrequency,
        selectedDays: _selectedDays,
        difficulty: _selectedDifficulty,
        reminderTime: reminderString,
      );
      provider.addHabit(newHabit);
    } else {
      // mevcut alışkanlığı copyWith ile güncelliyoruz
      final updated = widget.initialHabit!.copyWith(
        name: _nameController.text.trim(),
        goal: _goalController.text.trim(),
        category: _selectedCategory,
        iconCodePoint: _selectedIconCode,
        frequencyType: _selectedFrequency,
        selectedDays: _selectedDays,
        difficulty: _selectedDifficulty,
        points: _selectedDifficulty.points,
        reminderTime: reminderString,
      );
      provider.updateHabit(updated);
    }

    // işlem bitince formu kapatıp önceki ekrana dönüyoruz
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.initialHabit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Alışkanlığı Düzenle' : 'Yeni Alışkanlık'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        // Form widget'ı altındaki alanların topluca doğrulanmasını sağlar
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Alışkanlık Adı
              Text(
                'Alışkanlık Adı',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              // TextFormField kullanıcıdan metin girdisi alır ve doğrulama kuralı tanımlanabilir
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Günde 2 Litre Su İç',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen bir alışkanlık adı giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Hedef / Detay (İsteğe bağlı)
              Text(
                'Günlük Hedef (İsteğe Bağlı)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  hintText: 'Örn: 2 Litre / 30 Dakika / 20 Sayfa',
                  prefixIcon: Icon(Icons.track_changes_rounded),
                ),
              ),
              const SizedBox(height: 20),

              // Kategori
              Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              // Wrap sığmayan elemanları otomatik olarak bir alt satıra kaydırır
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: HabitCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  // ChoiceChip etiket şeklindeki seçim düğmesidir
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat.icon,
                          size: 16,
                          color: isSelected ? Colors.white : cat.color,
                        ),
                        const SizedBox(width: 6),
                        Text(cat.label),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.sageGreen,
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.5),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // İkon Seçimi
              Text(
                'İkon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                // yatay kaydırılabilir ikon seçim listesi
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableIcons.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    final icon = _availableIcons[idx];
                    final isSelected = _selectedIconCode == icon.codePoint;
                    // InkWell tıklama dalgalanma efekti verir
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _selectedIconCode = icon.codePoint),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.sageGreen
                              : (isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.sageGreen : AppColors.borderLight,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Zorluk Seviyesi ve Otomatik Puan Kuralı
              // (Kullanıcı puan miktarını belirleyemez, sistem kuralına göre atanır)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
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
                          'Zorluk & Otomatik Puan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sand.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${_selectedDifficulty.points} Puan',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.forest,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Puan sistemi otomatik olarak zorluk seviyesine göre hesaplanır.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: HabitDifficulty.values.map((diff) {
                        final isSelected = _selectedDifficulty == diff;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() => _selectedDifficulty = diff),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.forest
                                      : (isDark ? AppColors.darkSurface : Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? AppColors.forest : AppColors.borderLight,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      diff.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+${diff.points} p',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? AppColors.sand : AppColors.sageGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tekrar Sıklığı
              Text(
                'Tekrar Sıklığı',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: HabitFrequencyType.values.map((freq) {
                  final isSelected = _selectedFrequency == freq;
                  return ChoiceChip(
                    label: Text(freq.label),
                    selected: isSelected,
                    selectedColor: AppColors.sageGreen,
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.cream.withOpacity(0.5),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFrequency = freq;
                          if (freq == HabitFrequencyType.weekdays) {
                            _selectedDays = [1, 2, 3, 4, 5];
                          } else if (freq == HabitFrequencyType.everyDay) {
                            _selectedDays = [1, 2, 3, 4, 5, 6, 7];
                          }
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              // Seçili Günler Checkbox'ları (Seçili Günler seçilmişse)
              if (_selectedFrequency == HabitFrequencyType.specificDays) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDayChip(1, 'Pzt'),
                    _buildDayChip(2, 'Sal'),
                    _buildDayChip(3, 'Çar'),
                    _buildDayChip(4, 'Per'),
                    _buildDayChip(5, 'Cum'),
                    _buildDayChip(6, 'Cmt'),
                    _buildDayChip(7, 'Paz'),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // Hatırlatma Saati (İsteğe bağlı)
              Text(
                'Hatırlatma Saati',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                color: isDark ? AppColors.darkCard : const Color(0x66F5F1E8),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.alarm_rounded, color: AppColors.sageGreen),
                  title: Text(
                    _selectedReminderTime != null
                        ? '${_selectedReminderTime!.hour.toString().padLeft(2, '0')}:${_selectedReminderTime!.minute.toString().padLeft(2, '0')}'
                        : 'Hatırlatma ayarlanmadı',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.forest,
                    ),
                  ),
                  trailing: _selectedReminderTime != null
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () => setState(() => _selectedReminderTime = null),
                        )
                      : const Icon(Icons.chevron_right_rounded),
                  // showTimePicker ile kullanıcıya saat seçim diyaloğu açılır
                  onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedReminderTime ?? const TimeOfDay(hour: 8, minute: 0),
                  );
                  if (picked != null) {
                    setState(() => _selectedReminderTime = picked);
                  }
                },
              ),
            ),
              const SizedBox(height: 36),

              // Kaydet Butonu
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text(isEdit ? 'Değişiklikleri Kaydet' : 'Alışkanlığı Başlat'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // haftanın belirli günlerini seçmek için küçük kutucuklar üreten yardımcı metod
  Widget _buildDayChip(int dayNumber, String label) {
    final isSelected = _selectedDays.contains(dayNumber);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          if (isSelected) {
            if (_selectedDays.length > 1) {
              _selectedDays.remove(dayNumber);
            }
          } else {
            _selectedDays.add(dayNumber);
            _selectedDays.sort();
          }
        });
      },
      child: Container(
        width: 42,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.sageGreen
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.sageGreen : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.forest),
          ),
        ),
      ),
    );
  }
}

