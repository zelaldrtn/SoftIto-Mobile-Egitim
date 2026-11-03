import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Kalan miktar ve hedef durumunu gösteren ikili metrik kartı.
// StatelessWidget: hedefin kalan ve durum bilgisini yan yana iki kartta sunan sabit widget
class WaterMetricsRow extends StatelessWidget {
  const WaterMetricsRow({
    super.key,
    required this.remainingMl,
    required this.isGoalReached,
  });

  final int remainingMl;
  final bool isGoalReached;

  @override
  Widget build(BuildContext context) {
    // Row: iki metrik kartını yatayda yan yana yerleştirir
    return Row(
      children: [
        // Expanded: ilk kartın satırın sol yarısını eşit kaplamasını sağlar
        Expanded(
          child: _MetricCard(
            title: 'Kalan Miktar',
            // üçlü koşul: hedefe ulaşıldıysa tebrik mesajı, değilse kalan ml miktarını gösterir
            value: isGoalReached ? 'Hedef Tamam!' : '$remainingMl ml',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: isGoalReached ? AppColors.neonLime : AppColors.neonCyan,
          ),
        ),
        // SizedBox: iki kart arasına 12 birim yatay boşluk bırakır
        const SizedBox(width: 12),
        // Expanded: ikinci kartın satırın sağ yarısını eşit kaplamasını sağlar
        Expanded(
          child: _MetricCard(
            title: 'Durum',
            value: isGoalReached ? 'Harika İş! 🚀' : 'Devam Et 💪',
            icon: Icons.bolt_rounded,
            accentColor: isGoalReached ? AppColors.neonLime : AppColors.neonAmber,
          ),
        ),
      ],
    );
  }
}

// tek bir metrik bilgi kartını çizen yardımcı widget
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    // Container: karta koyu arka plan, kenarlık ve yuvarlak köşe stili verir
    return Container(
      // EdgeInsets.all: kutunun tüm iç kenarlarından 14 birim boşluk bırakır
      padding: const EdgeInsets.all(14),
      // BoxDecoration: kartın görsel tasarımını (arka plan rengi, köşe yarıçapı, sınır çizgisi) belirler
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      // Column: ikon, başlık ve değeri dikeyde sıralar
      child: Column(
        // CrossAxisAlignment.start: çocukları sola yaslar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

