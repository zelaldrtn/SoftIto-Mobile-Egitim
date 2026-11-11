import 'dart:io';
import 'package:flutter/material.dart';
import '../models/saving_goal_model.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Pinterest Tarzı Vision Board Hedef Kartı (Pinterest Pin Card)
class PinterestGoalCard extends StatelessWidget {
  final SavingGoalModel goal;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDepositTap;
  final VoidCallback onDeleteTap;

  const PinterestGoalCard({
    super.key,
    required this.goal,
    required this.index,
    required this.onTap,
    required this.onDepositTap,
    required this.onDeleteTap,
  });

  IconData _getIcon(String key) {
    switch (key.toLowerCase()) {
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'car':
        return Icons.directions_car_filled_rounded;
      case 'house':
        return Icons.home_rounded;
      case 'emergency':
        return Icons.shield_rounded;
      case 'wedding':
        return Icons.favorite_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  List<Color> _getGradient(int idx) {
    final gradients = [
      [const Color(0xFF5B347B), const Color(0xFF86529E)],
      [const Color(0xFF1B4332), const Color(0xFF2D6A4F)],
      [const Color(0xFF78290F), const Color(0xFFFF7D00)],
      [const Color(0xFF1D3557), const Color(0xFF457B9D)],
      [const Color(0xFF5A189A), const Color(0xFF9D4EDD)],
    ];
    return gradients[idx % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = (goal.progressRatio * 100).toStringAsFixed(0);
    final hasImage = goal.imagePath != null && goal.imagePath!.isNotEmpty;
    const double imageHeight = 150.0; // Tüm kartların eşit boyutta olması için sabit görsel yüksekliği

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Pinterest Görsel Bölümü (Galeriden seçilen fotoğraf veya estetik gradient)
            Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: hasImage
                      ? Image.file(
                          File(goal.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildFallbackMood(index),
                        )
                      : _buildFallbackMood(index),
                ),

                // Karartma Gradient (Yazı ve rozetlerin okunabilirliği için)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sol Üst: Öncelik Rozeti
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 11, color: AppColors.dreamyYellow),
                        const SizedBox(width: 3),
                        Text(
                          '★ ${goal.priority}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sağ Üst: Silme / Menü Butonu
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: onDeleteTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
                    ),
                  ),
                ),

                // Sol Alt: İlerleme Yüzdesi
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: goal.isCompleted
                          ? AppColors.forestPrimary.withOpacity(0.9)
                          : AppColors.dreamyLilac.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      goal.isCompleted ? '🎉 Tamam' : '%$percent',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Kart Gövdesi (Eşit yükseklikte başlık, alıntı ve tutarlar)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sabit yükseklikli başlık (1 veya 2 satırda kart boyunu bozmaz)
                  SizedBox(
                    height: 36,
                    child: Text(
                      goal.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -0.2,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Sabit yükseklikli alıntı / motivasyon notu
                  SizedBox(
                    height: 32,
                    child: Text(
                      (goal.quote != null && goal.quote!.isNotEmpty) ? goal.quote! : '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        height: 1.25,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Biriken / Hedef
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyFormatter.format(goal.savedAmount, showDecimals: false),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.forestMint : AppColors.forestPrimary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(goal.targetAmount, showDecimals: false),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progressRatio,
                      backgroundColor: isDark ? AppColors.darkCardAlt : AppColors.warmBorder.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goal.isCompleted ? AppColors.forestPrimary : AppColors.dreamyLilac,
                      ),
                      minHeight: 5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Hızlı Birikim Butonu
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: onDepositTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded, size: 14, color: AppColors.forestPrimary),
                            const SizedBox(width: 4),
                            Text(
                              '₺ Birikim Ekle',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackMood(int idx) {
    final colors = _getGradient(idx);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          _getIcon(goal.iconKey),
          size: 38,
          color: Colors.white.withOpacity(0.85),
        ),
      ),
    );
  }
}
