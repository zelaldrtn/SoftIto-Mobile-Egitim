import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

/// Hızlı su ekleme butonlarını ve özel içecek ekleme tetikleyicisini barındırır.
class WaterQuickActions extends StatelessWidget {
  final ValueChanged<int> onQuickAdd;
  final VoidCallback onOpenCustomDialog;

  const WaterQuickActions({
    super.key,
    required this.onQuickAdd,
    required this.onOpenCustomDialog,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildActionButton('+150 ml', Icons.local_cafe_rounded, () => onQuickAdd(150), isDark),
          const SizedBox(width: 8),
          _buildActionButton('+250 ml', Icons.local_drink_rounded, () => onQuickAdd(250), isDark),
          const SizedBox(width: 8),
          _buildActionButton('+500 ml', Icons.water_drop_rounded, () => onQuickAdd(500), isDark),
          const SizedBox(width: 8),
          _buildCustomButton(isDark),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, bool isDark) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorderFor(isDark)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primaryFor(isDark), size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimaryFor(isDark),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(bool isDark) {
    final primary = AppColors.primaryFor(isDark);
    return Expanded(
      child: InkWell(
        onTap: onOpenCustomDialog,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.waterGlassFor(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: primary, size: 20),
              const SizedBox(height: 4),
              Text(
                'Özel',
                style: TextStyle(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
