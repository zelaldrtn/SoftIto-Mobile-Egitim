import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_role.dart';

/// Seçili role ait bilgi ve avantajları özetleyen bilgi kartı.
class RoleInfoCard extends StatelessWidget {
  const RoleInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: AuthController.instance.selectedRoleNotifier,
      builder: (BuildContext context, UserRole role, Widget? child) {
        final bool isInvestor = role.isInvestor;
        final Color primary = Theme.of(context).colorScheme.primary;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary.withAlpha(60)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                isInvestor ? Icons.account_balance_rounded : Icons.lightbulb_rounded,
                color: primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  role.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
