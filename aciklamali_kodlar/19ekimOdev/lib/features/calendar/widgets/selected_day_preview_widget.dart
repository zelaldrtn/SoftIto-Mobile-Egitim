import 'package:flutter/material.dart';
import '../../diary/controllers/diary_controller.dart';
import '../../diary/models/diary_entry.dart';
import '../controllers/calendar_controller.dart';

/// Takvimde seçili olan günün özetini ve hızlı işlem kartını gösteren bileşen.
// StatelessWidget: takvimde tıklanan günün özetini ve hızlı işlem kartını sunan sabit widget
class SelectedDayPreviewWidget extends StatelessWidget {
  final CalendarController calendarController;
  final DiaryController diaryController;
  final VoidCallback onOpenDiary;

  const SelectedDayPreviewWidget({
    super.key,
    required this.calendarController,
    required this.diaryController,
    required this.onOpenDiary,
  });

  static const List<String> _turkishDays = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
  ];

  static const List<String> _turkishMonths = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  // seçilen tarihi Türkçe okunaklı metne (örn: 14 Ekim 2026, Çarşamba) dönüştürür
  static String formatDate(DateTime date) {
    final dayName = _turkishDays[date.weekday - 1];
    final monthName = _turkishMonths[date.month - 1];
    return '${date.day} $monthName ${date.year}, $dayName';
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: seçili gün veya günlük içeriği değiştikçe kartı yeniler
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return ValueListenableBuilder(
          valueListenable: diaryController.entriesListenable,
          builder: (context, entries, _) {
            final entry = diaryController.getEntry(selectedDate);
            final dateText = formatDate(selectedDate);

            // Card: gölgeli ve yuvarlatılmış özet kutusu
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(dateText: dateText, entry: entry),
                    // SizedBox: araya dikeyde 12 birim boşluk bırakır
                    const SizedBox(height: 12),
                    _CardBody(entry: entry),
                    const SizedBox(height: 14),
                    _CardActionButton(entry: entry, onOpenDiary: onOpenDiary),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// kartın üst başlığını ve ruh hâli rozetini çizen yardımcı widget
class _CardHeader extends StatelessWidget {
  final String dateText;
  final DiaryEntry? entry;

  const _CardHeader({required this.dateText, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Expanded: tarih başlığının satırdaki boşluğu kaplamasını sağlar
        Expanded(
          child: Text(
            dateText,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // seçilen ruh hâli emojisi varsa sağ üstte rozet olarak gösterir
        if (entry?.moodEmoji != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entry!.moodEmoji!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}

// günlüğün kısa önizleme metnini veya boş durum yazısını çizen yardımcı widget
class _CardBody extends StatelessWidget {
  final DiaryEntry? entry;

  const _CardBody({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // günlük yazılmışsa ilk 3 satırını önizleme olarak gösterir
    if (entry != null) {
      return Text(
        entry!.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          height: 1.4,
        ),
      );
    }

    // günlük yazılmamışsa teşvik edici bilgilendirme mesajı gösterir
    return Row(
      children: [
        Icon(Icons.edit_note, size: 20, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Bu gün için henüz bir günlük yazmadın. Düşüncelerini kaydetmek için tıkla.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

// günlüğü yazma veya düzenleme ekranını açan alt buton
class _CardActionButton extends StatelessWidget {
  final DiaryEntry? entry;
  final VoidCallback onOpenDiary;

  const _CardActionButton({required this.entry, required this.onOpenDiary});

  @override
  Widget build(BuildContext context) {
    final hasEntry = entry != null;
    return SizedBox(
      width: double.infinity,
      // ElevatedButton.icon: simgeli işlem butonu
      child: ElevatedButton.icon(
        onPressed: onOpenDiary,
        icon: Icon(hasEntry ? Icons.edit : Icons.create, size: 18),
        label: Text(hasEntry ? 'Günlüğü Düzenle' : 'Günlük Yaz'),
      ),
    );
  }
}

