import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

// gelir, gider ve birikim tutarlarını yan yana 3 mini kutucuk olarak gösteren bileşen
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
    // Row çocuklarını yatayda yan yana dizer
    return Row(
      children: [
        // Expanded mevcut boşluğu eşit şekilde paylaştırır
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
        // SizedBox araya sabit 10 birimlik boşluk bırakır
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

  // tek bir özet kartının görselini oluşturan yardımcı fonksiyon
  Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    // uygulamanın o an karanlık modda olup olmadığını kontrol eder
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Container kutu modeli oluşturur
    return Container(
      // padding kutunun iç boşluklarını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      // decoration arka plan rengi, köşe yuvarlaklığı ve çerçeve gibi stilleri tanımlar
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardTheme.color : bgColor.withOpacity(0.5),
        // BorderRadius köşeleri 20 birim yuvarlar
        borderRadius: BorderRadius.circular(20),
        // Border.all her tarafa eşit kenarlık çizer
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : iconColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      // Column elemanları dikeyde alt alta sıralar
      child: Column(
        // crossAxisAlignment elemanları sola yaslar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment iki uca yayarak başlığı sola ikonu sağa iter
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
            // maxLines yazının en fazla kaç satır olacağını belirtir
            maxLines: 1,
            // overflow yazı kutuya sığmazsa sonuna üç nokta koyar
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

