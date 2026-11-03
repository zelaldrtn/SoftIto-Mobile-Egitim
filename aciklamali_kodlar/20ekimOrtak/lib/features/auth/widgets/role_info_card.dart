import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_role.dart';

/// Seçili role ait bilgi ve avantajları özetleyen bilgi kartı.
// StatelessWidget: seçilen rolün (yatırımcı / girişimci) açıklamasını dinamik gösteren sabit kart
class RoleInfoCard extends StatelessWidget {
  const RoleInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: seçili rol değiştiğinde kartın açıklama ve simgesini anında günceller
    return ValueListenableBuilder<UserRole>(
      valueListenable: AuthController.instance.selectedRoleNotifier,
      builder: (BuildContext context, UserRole role, Widget? child) {
        final bool isInvestor = role.isInvestor;
        final Color primary = Theme.of(context).colorScheme.primary;

        return Container(
          // EdgeInsets.all: kutunun iç kenarlarından 14 birim boşluk bırakır
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary.withAlpha(60)),
          ),
          // Row: simge ve açıklama metnini yatayda yan yana dizer
          child: Row(
            children: <Widget>[
              Icon(
                isInvestor ? Icons.account_balance_rounded : Icons.lightbulb_rounded,
                color: primary,
                size: 28,
              ),
              // SizedBox: simge ile metin arasına 12 birim yatay boşluk bırakır
              const SizedBox(width: 12),
              // Expanded: açıklama metninin satırda kalan tüm genişliği kaplamasını sağlar
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

