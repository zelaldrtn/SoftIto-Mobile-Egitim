import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Haftalık su tüketimini gösteren neon çubuk grafik widget'ı.
// StatelessWidget: haftalık tüketim verilerini sütun grafik halinde sergileyen sabit widget
class WaterWeeklyChart extends StatelessWidget {
  const WaterWeeklyChart({
    super.key,
    required this.todayMl,
    required this.dailyTargetMl,
  });

  final int todayMl;
  final int dailyTargetMl;

  static const List<String> _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  // Haftanın geçmiş günleri için örnek gerçekçi veriler (son gün = bugün)
  List<int> get _weeklyData {
    return [2400, 2800, 3100, 2600, 3200, 2900, todayMl];
  }

  @override
  Widget build(BuildContext context) {
    // hedef 0'dan büyükse onu, değilse varsayılan 3000 ml'yi tavan değer alır
    final maxVal = dailyTargetMl > 0 ? dailyTargetMl.toDouble() : 3000.0;
    final weekly = _weeklyData;

    return Container(
      // EdgeInsets: kutunun iç kenarlarından 16 birim boşluk bırakır
      padding: const EdgeInsets.all(16),
      // BoxDecoration: kartın yuvarlak köşeli koyu arka planını belirler
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      // Column: başlık ve grafiği dikeyde sıralar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          // SizedBox: araya dikeyde 18 birim boşluk bırakır
          const SizedBox(height: 18),
          _buildChartBars(weekly, maxVal),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.bar_chart_rounded, color: AppColors.neonCyan, size: 20),
        const SizedBox(width: 8),
        // Expanded: başlık metninin sağdaki hedef etiketine kadar olan tüm genişliği kaplamasını sağlar
        const Expanded(
          child: Text(
            'Haftalık Su Grafiği',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonCyan.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: const Text(
            'Hedef: 3.0L',
            style: TextStyle(
              color: AppColors.neonCyan,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // haftalık sütunları yan yana oluşturan metot
  Widget _buildChartBars(List<int> weekly, double maxVal) {
    return SizedBox(
      height: 130,
      child: Row(
        // MainAxisAlignment.spaceEvenly: sütunlar arasına ve kenarlara eşit boşluk dağıtır
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // CrossAxisAlignment.end: tüm sütunları grafiğin taban çizgisine hizalar
        crossAxisAlignment: CrossAxisAlignment.end,
        // List.generate: gün sayısı kadar dinamik sütun üretir
        children: List.generate(weekly.length, (index) {
          final isToday = index == weekly.length - 1;
          final value = weekly[index];
          // clamp: sütun oranını en az 0.08, en çok 1.0 olacak şekilde sınırlar
          final ratio = (value / maxVal).clamp(0.08, 1.0);

          return _ChartColumn(
            dayName: _days[index],
            valueMl: value,
            heightRatio: ratio,
            isToday: isToday,
          );
        }),
      ),
    );
  }
}

// tek bir günün sütun çubuğunu ve metinlerini çizen yardımcı widget
class _ChartColumn extends StatelessWidget {
  const _ChartColumn({
    required this.dayName,
    required this.valueMl,
    required this.heightRatio,
    required this.isToday,
  });

  final String dayName;
  final int valueMl;
  final double heightRatio;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    // üçlü koşul: bugün ise neon vurgulu renk, geçmiş gün ise soluk kenarlık rengi seçilir
    final barColor = isToday ? AppColors.neonCyan : AppColors.obsidianBorder;
    final textColor = isToday ? AppColors.neonCyan : AppColors.textSecondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          // toStringAsFixed(1): litreyi virgülden sonra 1 basamakla yazar (örn: 2.5L)
          '${(valueMl / 1000).toStringAsFixed(1)}L',
          style: TextStyle(
            color: textColor,
            fontSize: 9,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 22,
          // oran ile taban yüksekliği (80) çarparak dinamik çubuk boyu elde eder
          height: 80 * heightRatio,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            // BoxShadow: sadece bugünün sütununa neon ışıma gölgesi ekler
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dayName,
          style: TextStyle(
            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

