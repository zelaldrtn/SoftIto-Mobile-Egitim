import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../views/login_view.dart';

/// Ana ekranda aktif kullanıcı profilini ve rol rozetini gösteren buton.
class UserProfileButton extends StatelessWidget {
  const UserProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AuthController.instance.currentUserNotifier,
      builder: (BuildContext context, UserModel? user, Widget? child) {
        if (user == null) {
          return TextButton.icon(
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Giriş'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LoginView()),
              );
            },
          );
        }

        final bool isInvestor = user.role.isInvestor;
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showProfileSheet(context, user),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isInvestor ? Colors.amber : Colors.green,
                  child: Text(
                    user.name.characters.first,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isInvestor ? Colors.amber : Colors.green).withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isInvestor ? 'Yatırımcı' : 'Girişimci',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isInvestor ? Colors.amber[800] : Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProfileSheet(BuildContext context, UserModel user) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => _ProfileSheetContent(user: user),
    );
  }
}

class _ProfileSheetContent extends StatelessWidget {
  final UserModel user;
  const _ProfileSheetContent({required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isInvestor = user.role.isInvestor;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor: isInvestor ? Colors.amber : Colors.green,
                child: Text(
                  user.name.characters.first,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(user.title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(isInvestor ? Icons.account_balance_wallet_rounded : Icons.rocket_launch_rounded),
            title: Text(isInvestor ? 'Yatırım Bütçesi' : 'Aktif Girişimler'),
            subtitle: Text(isInvestor ? '₺${user.investmentBudget?.toStringAsFixed(0) ?? "1.500.000"}' : '${user.activeProjectsCount ?? 1} Proje'),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                AuthController.instance.logout();
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
