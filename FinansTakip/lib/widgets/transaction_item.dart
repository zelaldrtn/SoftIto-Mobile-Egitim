import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'maaş':
      case 'ek gelir':
        return Icons.work_outline_rounded;
      case 'market':
        return Icons.shopping_cart_outlined;
      case 'yemek':
        return Icons.restaurant_rounded;
      case 'kira':
        return Icons.home_outlined;
      case 'faturalar':
        return Icons.receipt_long_rounded;
      case 'giyim':
        return Icons.checkroom_rounded;
      case 'ulaşım':
        return Icons.directions_bus_rounded;
      case 'eğlence':
        return Icons.movie_outlined;
      case 'sağlık':
        return Icons.medical_services_outlined;
      case 'birikim':
        return Icons.savings_outlined;
      default:
        return Icons.monetization_on_outlined;
    }
  }

  Color _getTypeColor() {
    switch (transaction.type) {
      case TransactionType.income:
        return AppColors.forestPrimary;
      case TransactionType.expense:
        return AppColors.dreamyCoral;
      case TransactionType.saving:
        return AppColors.dreamyLilac;
    }
  }

  String _getPrefix() {
    switch (transaction.type) {
      case TransactionType.income:
        return '+';
      case TransactionType.expense:
        return '-';
      case TransactionType.saving:
        return '✦';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor();

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (onDelete != null) {
          onDelete!();
          return false; // Silme onay diyaloğu yönetecek
        }
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.dreamyCoral.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              // Kategori İkonu
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _getCategoryIcon(transaction.category),
                  color: typeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Başlık & Kategori & İhtiyaç/İstek Etiketi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white38 : Colors.black26,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormatter.formatShort(transaction.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted,
                          ),
                        ),
                        if (transaction.type == TransactionType.expense) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: transaction.isNeed
                                  ? AppColors.forestSoftBg
                                  : AppColors.dreamyYellowLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              transaction.isNeed ? 'İhtiyaç' : 'İstek',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: transaction.isNeed
                                    ? AppColors.forestPrimary
                                    : const Color(0xFF946200),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Tutar
              Text(
                '${_getPrefix()}${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: typeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
