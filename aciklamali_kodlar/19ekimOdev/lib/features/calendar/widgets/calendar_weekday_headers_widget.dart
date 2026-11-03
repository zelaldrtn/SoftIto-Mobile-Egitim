import 'package:flutter/material.dart';

/// Haftanın günleri başlık satırı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz).
// StatelessWidget: takvim ızgarasının üstündeki gün kısaltmalarını çizen sabit widget
class CalendarWeekdayHeadersWidget extends StatelessWidget {
  const CalendarWeekdayHeadersWidget({super.key});

  // haftanın 7 gününün sabit kısaltma listesi
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
      // EdgeInsets: satırın sağına ve soluna 12, üstüne ve altına 8 birim boşluk bırakır
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Row: 7 gün kısaltmasını yatayda sıralar
      child: Row(
        // MainAxisAlignment.spaceAround: gün isimleri arasına eşit boşluk dağıtır
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekdays.map((day) {
          final isWeekend = day == 'Cmt' || day == 'Paz';
          // Expanded: her gün başlığının 1 sütun genişliğini eşit doldurmasını sağlar
          return Expanded(
            child: Center(
              child: Text(
                day,
                // hafta sonu günlerine hafif mor vurgu rengi uygular
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

