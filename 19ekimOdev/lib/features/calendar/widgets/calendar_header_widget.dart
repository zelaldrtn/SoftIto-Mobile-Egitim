import 'package:flutter/material.dart';
import '../controllers/calendar_controller.dart';

/// Takvim ay/yıl başlığı ve ay değiştirme butonları widget'ı.
class CalendarHeaderWidget extends StatelessWidget {
  final CalendarController controller;

  const CalendarHeaderWidget({
    super.key,
    required this.controller,
  });

  static const List<String> _turkishMonths = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: controller.focusedMonthNotifier,
      builder: (context, focusedMonth, _) {
        final monthName = _turkishMonths[focusedMonth.month - 1];
        final yearString = focusedMonth.year.toString();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MonthYearLabel(monthName: monthName, year: yearString),
              _MonthNavButtons(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _MonthYearLabel extends StatelessWidget {
  final String monthName;
  final String year;

  const _MonthYearLabel({required this.monthName, required this.year});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          monthName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            year,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthNavButtons extends StatelessWidget {
  final CalendarController controller;

  const _MonthNavButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_left, size: 20),
          onPressed: controller.previousMonth,
          tooltip: 'Önceki Ay',
        ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          icon: const Icon(Icons.today, size: 18),
          onPressed: controller.goToToday,
          tooltip: 'Bugün',
        ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_right, size: 20),
          onPressed: controller.nextMonth,
          tooltip: 'Sonraki Ay',
        ),
      ],
    );
  }
}
