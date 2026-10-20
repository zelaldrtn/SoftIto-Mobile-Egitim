import 'package:flutter/material.dart';

/// Fonlama ilerlemesini görselleştiren ve yüzdeyi gösteren çubuk widget'ı.
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
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: theme.colorScheme.outline.withAlpha(70),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        const SizedBox(height: 6),
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
