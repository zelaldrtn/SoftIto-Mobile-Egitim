import 'package:flutter/material.dart';

/// Haftanın günleri başlık satırı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz).
class CalendarWeekdayHeadersWidget extends StatelessWidget {
  const CalendarWeekdayHeadersWidget({super.key});

  static const List<String> _weekdays = [
    'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekdays.map((day) {
          final isWeekend = day == 'Cmt' || day == 'Paz';
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: textStyle?.copyWith(
                  color: isWeekend
                      ? theme.colorScheme.primary.withValues(alpha: 0.8)
                      : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
