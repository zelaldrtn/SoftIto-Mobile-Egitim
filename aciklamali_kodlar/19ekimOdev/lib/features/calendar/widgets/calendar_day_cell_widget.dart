import 'package:flutter/material.dart';
import '../models/calendar_day.dart';

/// Takvimdeki tek bir gün hücresini görselleştiren widget.
// StatelessWidget: takvimdeki tek bir gün kutucuğunu çizen sabit widget
class CalendarDayCellWidget extends StatelessWidget {
  final CalendarDay day;
  final VoidCallback onTap;

  const CalendarDayCellWidget({
    super.key,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = day.isSelected;
    final isCurrentMonth = day.isCurrentMonth;

    return Padding(
      padding: const EdgeInsets.all(3),
      // Material: InkWell tıklama dalgasının görünmesi için şeffaf zemin sağlar
      child: Material(
        color: Colors.transparent,
        // InkWell: güne dokunmayı algılar ve köşe yuvarlaklığına uygun dalgalanma efekti verir
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          // AnimatedContainer: gün seçildiğinde arka plan rengi ve kenarlık geçişini yumuşak bir animasyonla yapar
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: _buildCellDecoration(theme),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DayNumberText(day: day, isSelected: isSelected, isCurrentMonth: isCurrentMonth),
                const SizedBox(height: 2),
                _DayEntryIndicator(day: day, isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // günün seçili, bugün veya günlük yazılmış olmasına göre arka plan kutu stilini belirler
  BoxDecoration _buildCellDecoration(ThemeData theme) {
    if (day.isSelected) {
      return BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: seçili olan güne derinlik katan parlama gölgesi verir
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
    }

    if (day.isToday) {
      return BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 1.5),
      );
    }

    if (day.hasEntry) {
      return BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      );
    }

    return const BoxDecoration();
  }
}

// gün numarasını (örn: 14) çizen metin widget'ı
class _DayNumberText extends StatelessWidget {
  final CalendarDay day;
  final bool isSelected;
  final bool isCurrentMonth;

  const _DayNumberText({
    required this.day,
    required this.isSelected,
    required this.isCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor;

    // durumuna göre gün numarası rengini seçer
    if (isSelected) {
      textColor = theme.colorScheme.onPrimary;
    } else if (!isCurrentMonth) {
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.28);
    } else if (day.isToday) {
      textColor = theme.colorScheme.primary;
    } else {
      textColor = theme.colorScheme.onSurface;
    }

    return Text(
      '${day.dayNumber}',
      style: TextStyle(
        fontSize: 14,
        fontWeight: (isSelected || day.isToday) ? FontWeight.bold : FontWeight.w500,
        color: textColor,
      ),
    );
  }
}

// güne ait ruh hâli emojisini veya küçük günlük gösterge noktasını çizen widget
class _DayEntryIndicator extends StatelessWidget {
  final CalendarDay day;
  final bool isSelected;

  const _DayEntryIndicator({required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    // emoji seçilmişse doğrudan emojiyi gösterir
    if (day.moodEmoji != null && day.moodEmoji!.isNotEmpty) {
      return Text(
        day.moodEmoji!,
        style: const TextStyle(fontSize: 13),
      );
    }

    // sadece metin yazılmışsa küçük renkli yuvarlak nokta gösterir
    if (day.hasEntry) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    return const SizedBox(height: 6);
  }
}

