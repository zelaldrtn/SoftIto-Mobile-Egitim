import 'package:flutter/material.dart';
import '../models/calendar_day.dart';

/// Takvimdeki tek bir gün hücresini görselleştiren widget.
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
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

  BoxDecoration _buildCellDecoration(ThemeData theme) {
    if (day.isSelected) {
      return BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
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

class _DayEntryIndicator extends StatelessWidget {
  final CalendarDay day;
  final bool isSelected;

  const _DayEntryIndicator({required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (day.moodEmoji != null && day.moodEmoji!.isNotEmpty) {
      return Text(
        day.moodEmoji!,
        style: const TextStyle(fontSize: 13),
      );
    }

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
