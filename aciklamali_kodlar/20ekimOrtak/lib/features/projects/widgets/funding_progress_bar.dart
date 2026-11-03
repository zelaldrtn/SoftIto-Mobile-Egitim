import 'package:flutter/material.dart';

// fonlama ilerlemesini görselleştiren ve yüzdeyi gösteren çubuk widget'ı
class FundingProgressBar extends StatelessWidget {
  final double current;
  final double target;
  final double ratio;
  final int percentage;

  const FundingProgressBar({
    super.key,
    required this.current,
    required this.target,
    required this.ratio,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    // mevcut tema ayarlarına ve renk şemasına erişiyoruz
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;

    return Column(
      // alt elemanları sola yaslıyoruz
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // köşeleri yuvarlatılmış ilerleme çubuğu için ClipRRect kullanıyoruz
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            // 0.0 ile 1.0 arasında doluluk oranı alır
            value: ratio,
            // çubuğun dikey kalınlığı
            minHeight: 8,
            backgroundColor: theme.colorScheme.outline.withAlpha(70),
            // dolan kısmın rengini belirler
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        const SizedBox(height: 6),
        // toplanan para ile yüzde bilgisini yan yana iki uca yaslıyoruz
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '₺${current.toStringAsFixed(0)} toplandı',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              '%$percentage',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

