import 'package:flutter/material.dart';

class AppCategory {
  final String name;
  final IconData icon;
  final Color color;
  final bool isExpense;

  const AppCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.isExpense = true,
  });
}

class AppCategories {
  static const List<String> defaultIncomeCategories = [
    'Maaş',
    'Ek Gelir',
    'Freelance',
    'Yatırım Geliri',
    'Diğer',
  ];

  static const List<String> defaultExpenseCategories = [
    'Market',
    'Ulaşım',
    'Faturalar',
    'Kira',
    'Sağlık',
    'Eğitim',
    'Alışveriş',
    'Eğlence',
    'Yeme-İçme',
    'Abonelik',
    'Diğer',
  ];

  static IconData getCategoryIcon(String category) {
    switch (category) {
      // Gelir
      case 'Maaş':
        return Icons.payments_outlined;
      case 'Ek Gelir':
        return Icons.add_card_outlined;
      case 'Freelance':
        return Icons.laptop_chromebook_outlined;
      case 'Yatırım Geliri':
        return Icons.trending_up_outlined;

      // Gider
      case 'Market':
        return Icons.shopping_cart_outlined;
      case 'Ulaşım':
        return Icons.directions_bus_outlined;
      case 'Faturalar':
        return Icons.receipt_long_outlined;
      case 'Kira':
        return Icons.home_outlined;
      case 'Sağlık':
        return Icons.medical_services_outlined;
      case 'Eğitim':
        return Icons.school_outlined;
      case 'Alışveriş':
        return Icons.local_mall_outlined;
      case 'Eğlence':
        return Icons.celebration_outlined;
      case 'Yeme-İçme':
        return Icons.restaurant_outlined;
      case 'Abonelik':
        return Icons.subscriptions_outlined;
      case 'Birikim':
        return Icons.savings_outlined;
      case 'Borç Ödemesi':
      case 'Kredi Kartı Borç Ödemesi':
        return Icons.credit_score_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Maaş':
      case 'Ek Gelir':
      case 'Freelance':
      case 'Yatırım Geliri':
        return const Color(0xFF1E5638);
      case 'Market':
        return const Color(0xFFE27396);
      case 'Ulaşım':
        return const Color(0xFF4EA8DE);
      case 'Faturalar':
        return const Color(0xFFF4A261);
      case 'Kira':
        return const Color(0xFF9D84B7);
      case 'Sağlık':
        return const Color(0xFFE26D5C);
      case 'Eğitim':
        return const Color(0xFF2A9D8F);
      case 'Alışveriş':
        return const Color(0xFFD67AB1);
      case 'Eğlence':
        return const Color(0xFFF7D965);
      case 'Yeme-İçme':
        return const Color(0xFFE76F51);
      case 'Abonelik':
        return const Color(0xFF8A5EC2);
      case 'Birikim':
        return const Color(0xFF4E9B71);
      case 'Borç Ödemesi':
      case 'Kredi Kartı Borç Ödemesi':
        return const Color(0xFF3A86FF);
      default:
        return const Color(0xFF8FA397);
    }
  }
}

