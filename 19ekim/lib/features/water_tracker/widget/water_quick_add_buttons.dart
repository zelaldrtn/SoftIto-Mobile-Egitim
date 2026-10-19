import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'custom_water_input_sheet.dart';

/// Hızlı su ekleme ve özel miktar giriş butonları grubu.
class WaterQuickAddButtons extends StatelessWidget {
  const WaterQuickAddButtons({
    super.key,
    required this.onAddWater,
  });

  final void Function(int amount, String label) onAddWater;

  static const List<_QuickOption> _options = [
    _QuickOption(amount: 200, label: 'Bardak', icon: Icons.local_cafe_outlined),
    _QuickOption(amount: 250, label: 'Kupa', icon: Icons.local_drink_outlined),
    _QuickOption(amount: 500, label: 'Şişe', icon: Icons.sports_bar_outlined),
    _QuickOption(amount: 750, label: 'Shaker', icon: Icons.fitness_center_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: _options.map((opt) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickAddCard(
                  option: opt,
                  onTap: () => onAddWater(opt.amount, opt.label),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        _buildCustomAddButton(context),
      ],
    );
  }

  Widget _buildCustomAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.obsidianBorder),
          backgroundColor: AppColors.obsidianCard,
          foregroundColor: AppColors.neonCyan,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        onPressed: () => CustomWaterInputSheet.show(
          context,
          onAddWater: (amount, label) {
            onAddWater(amount, label);
            _showFeedback(context, '+$amount ml ($label) eklendi 💧');
          },
        ),
        icon: const Icon(Icons.tune_rounded, size: 18),
        label: const Text(
          '+ Özel Miktar / İçecek Ekle (örn. 300 ml)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  static void _showFeedback(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.obsidianSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.neonCyan, width: 0.8),
        ),
      ),
    );
  }
}

class _QuickOption {
  const _QuickOption({
    required this.amount,
    required this.label,
    required this.icon,
  });

  final int amount;
  final String label;
  final IconData icon;
}

class _QuickAddCard extends StatelessWidget {
  const _QuickAddCard({
    required this.option,
    required this.onTap,
  });

  final _QuickOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: InkWell(
        onTap: () {
          onTap();
          WaterQuickAddButtons._showFeedback(
            context,
            '+${option.amount} ml (${option.label}) eklendi 💧',
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        splashColor: AppColors.neonCyan.withValues(alpha: 0.25),
        highlightColor: AppColors.neonCyan.withValues(alpha: 0.15),
        hoverColor: AppColors.neonCyan.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(option.icon, color: AppColors.neonCyan, size: 22),
              const SizedBox(height: 6),
              Text(
                '+${option.amount}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                option.label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
