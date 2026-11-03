import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Neon efektli dairesel su ilerleme göstergesi.
// StatelessWidget: su tüketim yüzdesini dairesel göstergeyle sunan sabit widget
class WaterProgressIndicator extends StatelessWidget {
  const WaterProgressIndicator({
    super.key,
    required this.currentMl,
    required this.targetMl,
    required this.progress,
    required this.percentage,
  });

  final int currentMl;
  final int targetMl;
  final double progress;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Stack: parlama arka planını, ilerleme halkasını ve ortadaki metinleri üst üste bindirir
      child: Stack(
        // alignment: tüm çocukları merkeze hizalar
        alignment: Alignment.center,
        children: [
          _buildGlowBackground(),
          _buildProgressRing(),
          _buildCenterText(context),
        ],
      ),
    );
  }

  // neon ışıma efektini oluşturan gölgeli yuvarlak zemin
  Widget _buildGlowBackground() {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // BoxShadow: halkanın arkasına neon cyan renginde parlama/derinlik efekti yayar
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }

  // dairesel ilerleme çubuğu (progress ring)
  Widget _buildProgressRing() {
    return SizedBox(
      width: 190,
      height: 190,
      // CircularProgressIndicator: 0.0 ile 1.0 arasındaki orana göre dairesel dolan çubuk
      child: CircularProgressIndicator(
        value: progress,
        // strokeWidth: halkanın çizgi kalınlığı
        strokeWidth: 14,
        backgroundColor: AppColors.obsidianBorder,
        // AlwaysStoppedAnimation: ilerleme çubuğunun rengini sabit neon cyan yapar
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
        // strokeCap.round: halkanın uç kısımlarını yuvarlatır
        strokeCap: StrokeCap.round,
      ),
    );
  }

  // halkanın tam ortasında duran metin ve damla ikonu
  Widget _buildCenterText(BuildContext context) {
    return Column(
      // MainAxisSize.min: dikeyde sadece içerik kadar yer kaplar
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop_rounded, color: AppColors.neonCyan, size: 32),
        const SizedBox(height: 6),
        Text(
          '$currentMl ml',
          // copyWith: temadaki mevcut yazı tipini bozmadan sadece renk ve kalınlık üzerine yazar
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hedef: $targetMl ml (%$percentage)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

