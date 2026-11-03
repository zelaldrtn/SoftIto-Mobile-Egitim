import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_role.dart';

/// Giriş ekranında Yatırımcı ve Girişimci rolleri arasında geçiş sağlayan sekme bileşeni.
// StatelessWidget: Material 3 SegmentedButton ile rol seçimi yaptıran sabit widget
class RoleSelectorTab extends StatelessWidget {
  const RoleSelectorTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = AuthController.instance;

    // ValueListenableBuilder: seçili rol değiştiğinde butonun aktif sekmesini günceller
    return ValueListenableBuilder<UserRole>(
      valueListenable: controller.selectedRoleNotifier,
      builder: (BuildContext context, UserRole selectedRole, Widget? child) {
        // SegmentedButton: birden fazla seçenek arasında tekli seçim yaptıran modern Material 3 buton grubu
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
          // kullanıcı sekmeye bastığında seçilen yeni rolü controller'a aktarır
          onSelectionChanged: (Set<UserRole> newSelection) {
            controller.setSelectedRole(newSelection.first);
          },
        );
      },
    );
  }
}

