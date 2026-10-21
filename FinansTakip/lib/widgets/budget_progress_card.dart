import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class BudgetProgressCard extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  final VoidCallback? onEditLimit;

  const BudgetProgressCard({
    super.key,
    required this.category,
    required this.spent,
    required this.limit,
    this.onEditLimit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio = limit > 0 ? (spent / limit) : 0.0;
    final isOverBudget = ratio > 1.0;
    final isWarning = ratio >= 0.8 && !isOverBudget;

    Color statusColor;
    String statusText;
    if (isOverBudget) {
      statusColor = AppColors.dreamyCoral;
      statusText = 'Limit Aşıldı!';
    } else if (isWarning) {
      statusColor = const Color(0xFFD97706); // Amber
      statusText = 'Limite Yaklaştın';
    } else {
      statusColor = AppColors.forestPrimary;
      statusText = 'Kontrol Altında';
    }

    final percent = (ratio * 100).toStringAsFixed(0);
    final clampedRatio = ratio.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isOverBudget
              ? AppColors.dreamyCoral.withOpacity(0.4)
              : (isDark ? AppColors.darkBorder : AppColors.warmBorder),
          width: isOverBudget ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık, Durum Rozeti ve Düzenle Butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (onEditLimit != null)
                InkWell(
                  onTap: onEditLimit,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Harcanan / Limit Tutarı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    CurrencyFormatter.format(spent, showDecimals: false),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    ' / ${CurrencyFormatter.format(limit, showDecimals: false)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '%$percent',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // İlerleme Barı
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardAlt
                      : AppColors.warmBorder.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: clampedRatio,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Kalan / Aşılan Bilgisi
          Text(
            isOverBudget
                ? 'Limit ${CurrencyFormatter.format(spent - limit, showDecimals: false)} aşıldı!'
                : 'Kalan harcama payı: ${CurrencyFormatter.format(limit - spent, showDecimals: false)}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isOverBudget
                  ? AppColors.dreamyCoral
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
