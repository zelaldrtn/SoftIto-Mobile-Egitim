import 'package:flutter/material.dart';
import '../models/recurring_model.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class RecurringItem extends StatelessWidget {
  final RecurringPaymentModel payment;
  final VoidCallback? onTogglePaid;
  final VoidCallback? onDelete;

  const RecurringItem({
    super.key,
    required this.payment,
    this.onTogglePaid,
    this.onDelete,
  });

  IconData _getIconData(String iconKey) {
    switch (iconKey.toLowerCase()) {
      case 'netflix':
      case 'spotify':
        return Icons.play_circle_outline_rounded;
      case 'rent':
        return Icons.home_work_outlined;
      case 'wifi':
        return Icons.wifi_rounded;
      case 'gym':
        return Icons.fitness_center_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remainingDays = payment.daysRemaining(DateTime.now());

    String dueText;
    Color badgeColor;
    if (payment.isPaid) {
      dueText = 'Bu ay ödendi ✓';
      badgeColor = AppColors.forestPrimary;
    } else if (remainingDays == 0) {
      dueText = 'Bugün son gün!';
      badgeColor = AppColors.dreamyCoral;
    } else if (remainingDays <= 3) {
      dueText = '$remainingDays gün kaldı ⚠️';
      badgeColor = const Color(0xFFD97706);
    } else {
      dueText = '$remainingDays gün kaldı';
      badgeColor = AppColors.forestMedium;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // İkon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.dreamyLilac.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getIconData(payment.iconKey),
              color: AppColors.dreamyLilac,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Başlık ve Tarih Bilgisi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Her ayın ${payment.dueDay}. günü',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dueText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tutar ve Ödendi Butonu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(payment.amount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: onTogglePaid,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: payment.isPaid
                        ? AppColors.forestSoftBg
                        : AppColors.forestPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: payment.isPaid
                          ? AppColors.forestPrimary
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    payment.isPaid ? 'Ödendi' : 'Öde',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: payment.isPaid
                          ? AppColors.forestPrimary
                          : (isDark ? AppColors.forestMint : AppColors.forestPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
