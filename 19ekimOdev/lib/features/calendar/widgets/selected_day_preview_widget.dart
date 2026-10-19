import 'package:flutter/material.dart';
import '../../diary/controllers/diary_controller.dart';
import '../../diary/models/diary_entry.dart';
import '../controllers/calendar_controller.dart';

/// Takvimde seçili olan günün özetini ve hızlı işlem kartını gösteren bileşen.
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

  static String formatDate(DateTime date) {
    final dayName = _turkishDays[date.weekday - 1];
    final monthName = _turkishMonths[date.month - 1];
    return '${date.day} $monthName ${date.year}, $dayName';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return ValueListenableBuilder(
          valueListenable: diaryController.entriesListenable,
          builder: (context, entries, _) {
            final entry = diaryController.getEntry(selectedDate);
            final dateText = formatDate(selectedDate);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(dateText: dateText, entry: entry),
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
        Expanded(
          child: Text(
            dateText,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
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

class _CardBody extends StatelessWidget {
  final DiaryEntry? entry;

  const _CardBody({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

class _CardActionButton extends StatelessWidget {
  final DiaryEntry? entry;
  final VoidCallback onOpenDiary;

  const _CardActionButton({required this.entry, required this.onOpenDiary});

  @override
  Widget build(BuildContext context) {
    final hasEntry = entry != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onOpenDiary,
        icon: Icon(hasEntry ? Icons.edit : Icons.create, size: 18),
        label: Text(hasEntry ? 'Günlüğü Düzenle' : 'Günlük Yaz'),
      ),
    );
  }
}
