import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class StatSummaryCards extends StatelessWidget {
  final double income;
  final double expense;
  final double saving;

  const StatSummaryCards({
    super.key,
    required this.income,
    required this.expense,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniCard(
            context,
            title: 'Gelir',
            amount: income,
            icon: Icons.arrow_downward_rounded,
            iconColor: AppColors.forestPrimary,
            bgColor: AppColors.forestSoftBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniCard(
            context,
            title: 'Gider',
            amount: expense,
            icon: Icons.arrow_upward_rounded,
            iconColor: AppColors.dreamyCoral,
            bgColor: AppColors.dreamyCoralLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniCard(
            context,
            title: 'Birikim',
            amount: saving,
            icon: Icons.savings_outlined,
            iconColor: AppColors.dreamyLilac,
            bgColor: AppColors.dreamyLilacLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardTheme.color : bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : iconColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(amount, showDecimals: false),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
