import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_role.dart';

/// Giriş ekranında Yatırımcı ve Girişimci rolleri arasında geçiş sağlayan sekme bileşeni.
class RoleSelectorTab extends StatelessWidget {
  const RoleSelectorTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = AuthController.instance;

    return ValueListenableBuilder<UserRole>(
      valueListenable: controller.selectedRoleNotifier,
      builder: (BuildContext context, UserRole selectedRole, Widget? child) {
        return SegmentedButton<UserRole>(
          segments: const <ButtonSegment<UserRole>>[
            ButtonSegment<UserRole>(
              value: UserRole.investor,
              icon: Icon(Icons.trending_up_rounded),
              label: Text('Yatırımcı'),
            ),
            ButtonSegment<UserRole>(
              value: UserRole.entrepreneur,
              icon: Icon(Icons.rocket_launch_rounded),
              label: Text('Yatırım Alan'),
            ),
          ],
          selected: <UserRole>{selectedRole},
          onSelectionChanged: (Set<UserRole> newSelection) {
            controller.setSelectedRole(newSelection.first);
          },
        );
      },
    );
  }
}
