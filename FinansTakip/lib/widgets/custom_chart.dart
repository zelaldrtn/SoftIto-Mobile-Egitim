import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Editorial Finance & Dreamy Money Pasta / Donut Grafiği
class EditorialDonutChart extends StatelessWidget {
  final Map<String, double> data; // Kategori: Tutar
  final double totalAmount;

  const EditorialDonutChart({
    super.key,
    required this.data,
    required this.totalAmount,
  });

  // Estetik Renk Paleti (Editorial + Dreamy)
  static const List<Color> chartColors = [
    AppColors.forestPrimary,
    AppColors.dreamyLilac,
    AppColors.dreamyYellow,
    AppColors.forestLight,
    Color(0xFFE27396),
    Color(0xFF4EA8DE),
    Color(0xFFF4A261),
    Color(0xFF2A9D8F),
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || totalAmount <= 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey.withOpacity(0.4)),
            const SizedBox(height: 8),
            Text(
              'Bu ay için henüz harcama kaydı yok',
              style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 13),
            ),
          ],
        ),
      );
    }

    final entries = data.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 180),
                painter: _DonutChartPainter(
                  entries: entries,
                  total: totalAmount,
                  colors: chartColors,
                  strokeWidth: 26,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Toplam Harcama',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(totalAmount, showDecimals: false),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Legend (Kategori Açıklamaları)
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(entries.length, (index) {
            final entry = entries[index];
            final color = chartColors[index % chartColors.length];
            final percent = (entry.value / totalAmount * 100).toStringAsFixed(0);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.key} (%$percent)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final double total;
  final List<Color> colors;
  final double strokeWidth;

  _DonutChartPainter({
    required this.entries,
    required this.total,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < entries.length; i++) {
      final sweepAngle = (entries[i].value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      // Dilim arasına ufak boşluk eklemek için hafif kısaltma
      final gap = entries.length > 1 ? 0.04 : 0.0;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (gap / 2),
        sweepAngle - gap,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.entries != entries || oldDelegate.total != total;
  }
}

/// Haftalık Harcama Çubuk Grafiği (Weekly Bar Chart)
class WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> dailyData; // [{'day': 'Pzt', 'amount': 450.0}, ...]

  const WeeklyBarChart({super.key, required this.dailyData});

  @override
  Widget build(BuildContext context) {
    if (dailyData.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text('Veri bulunamadı')));
    }

    double maxAmount = 0.0;
    for (var d in dailyData) {
      final amt = (d['amount'] as num).toDouble();
      if (amt > maxAmount) maxAmount = amt;
    }
    if (maxAmount == 0) maxAmount = 1.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dailyData.map((item) {
        final day = item['day'] as String;
        final amount = (item['amount'] as num).toDouble();
        final ratio = (amount / maxAmount).clamp(0.05, 1.0);
        final isHighest = amount == maxAmount && amount > 0;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (amount > 0)
                  Text(
                    '₺${amount > 999 ? '${(amount / 1000).toStringAsFixed(1)}k' : amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isHighest ? AppColors.forestPrimary : Colors.grey,
                    ),
                  )
                else
                  const SizedBox(height: 12),
                const SizedBox(height: 4),
                // Çubuk
                Container(
                  height: 110 * ratio,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isHighest
                          ? [AppColors.forestPrimary, AppColors.forestLight]
                          : [
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              AppColors.dreamyLilac.withOpacity(0.5),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isHighest
                        ? [
                            BoxShadow(
                              color: AppColors.forestPrimary.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isHighest ? FontWeight.w800 : FontWeight.w500,
                    color: isHighest
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
