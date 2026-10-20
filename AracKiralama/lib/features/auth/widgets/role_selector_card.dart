import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/user_model.dart';

/// Kullanıcı rolü seçimi için kart bileşeni.
class RoleSelectorCard extends StatelessWidget {
  const RoleSelectorCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = theme.brightness == Brightness.dark
        ? AppColors.primaryYellow
        : AppColors.primaryBlue;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : theme.dividerColor,
              width: isSelected ? 2.0 : 1.0,
            ),
            color: isSelected
                ? activeColor.withValues(alpha: 0.12)
                : theme.cardColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                role.isOwner ? Icons.vpn_key_rounded : Icons.directions_car_filled_rounded,
                color: isSelected ? activeColor : theme.iconTheme.color,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                role.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                  color: isSelected ? activeColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
