import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_role.dart';
import '../widgets/role_info_card.dart';
import '../widgets/role_selector_tab.dart';

/// Yatırımcı ve Yatırım Alan Girişimci giriş ekranı.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const _LoginHeader(),
                  const SizedBox(height: 20),
                  const RoleSelectorTab(),
                  const SizedBox(height: 14),
                  const RoleInfoCard(),
                  const SizedBox(height: 16),
                  _LoginFormFields(
                    emailCtrl: _emailCtrl,
                    passwordCtrl: _passwordCtrl,
                    nameCtrl: _nameCtrl,
                  ),
                  const SizedBox(height: 20),
                  _LoginActions(
                    onLogin: _handleLogin,
                    onDemoLogin: _handleDemoLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final UserRole role = AuthController.instance.selectedRoleNotifier.value;
    AuthController.instance.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      role: role,
      name: _nameCtrl.text.trim(),
    );
    _navigateToHome();
  }

  void _handleDemoLogin(UserRole role) {
    AuthController.instance.loginDemo(role);
    _navigateToHome();
  }

  void _navigateToHome() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/logo.png',
            width: 72,
            height: 72,
            errorBuilder: (_, _, _) => const Icon(Icons.rocket_launch_rounded, size: 64),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Destek Bul',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Girişimci ve Yatırımcı Buluşma Platformu',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ],
    );
  }
}

class _LoginFormFields extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController nameCtrl;

  const _LoginFormFields({
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.nameCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Ad Soyad (Opsiyonel)',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-posta Adresi *',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen e-posta girin' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: passwordCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Şifre *',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
          validator: (String? v) =>
              (v == null || v.length < 6) ? 'En az 6 karakter girin' : null,
        ),
      ],
    );
  }
}

class _LoginActions extends StatelessWidget {
  final VoidCallback onLogin;
  final ValueChanged<UserRole> onDemoLogin;

  const _LoginActions({
    required this.onLogin,
    required this.onDemoLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login_rounded),
            label: const Text('Giriş Yap / Devam Et'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onDemoLogin(UserRole.investor),
                icon: const Icon(Icons.trending_up_rounded, size: 16),
                label: const Text('Demo Yatırımcı'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onDemoLogin(UserRole.entrepreneur),
                icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                label: const Text('Demo Girişimci'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
