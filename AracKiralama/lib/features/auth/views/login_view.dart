import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/role_selector_card.dart';

/// Giriş ve Rol Seçim Ekranı.
/// Kullanıcının Kiralayan veya Araç Sahibi rolüyle sisteme demo giriş yapmasını sağlar.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Form doğrulama anahtarı
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Metin alanları kontrolcüleri
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'demo@arackiralama.com');
  final TextEditingController _passCtrl =
      TextEditingController(text: '123456');

  // Klavye odaklanma yönetimi ve sıradaki alana geçiş için FocusNode'lar
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  // Seçilen kullanıcı rolünü saklayan reaktif bildirimci
  final ValueNotifier<UserRole> _selectedRole =
      ValueNotifier<UserRole>(UserRole.kiralayan);

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için kontrolcü ve odak düğümleri temizlenir
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _selectedRole.dispose();
    super.dispose();
  }

  /// Giriş butonuna basıldığında form doğrulaması yapar ve oturum açar.
  void _onLoginPressed() {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // Kimlik doğrulama kontrolcüsüne giriş talebini iletir
    AuthController.instance.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      role: _selectedRole.value,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedRole.value.title} olarak giriş yapıldı.',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Klavyenin ekran dışına dokunulduğunda kapanmasını sağlar
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight - 32),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const _LoginHeader(),
                          const SizedBox(height: 24),
                          _RoleSection(selectedRoleNotifier: _selectedRole),
                          const SizedBox(height: 20),
                          _EmailField(
                            controller: _emailCtrl,
                            focusNode: _emailFocus,
                            nextFocusNode: _passFocus,
                          ),
                          const SizedBox(height: 14),
                          _PasswordField(
                            controller: _passCtrl,
                            focusNode: _passFocus,
                            onSubmitted: _onLoginPressed,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _onLoginPressed,
                            child: const Text('Giriş Yap ve Başla'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Giriş sayfası logo ve başlık bölümü.
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/logo.png',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Araç Kiralama',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Hayalindeki aracı keşfet veya aracını kiraya ver',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
      ],
    );
  }
}

/// Rol seçim kartları bölümü (Kiralayan / Araç Sahibi).
class _RoleSection extends StatelessWidget {
  const _RoleSection({required this.selectedRoleNotifier});

  final ValueNotifier<UserRole> selectedRoleNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: selectedRoleNotifier,
      builder: (BuildContext context, UserRole current, _) {
        return Row(
          children: <Widget>[
            RoleSelectorCard(
              role: UserRole.kiralayan,
              isSelected: current == UserRole.kiralayan,
              onTap: () => selectedRoleNotifier.value = UserRole.kiralayan,
            ),
            const SizedBox(width: 12),
            RoleSelectorCard(
              role: UserRole.aracSahibi,
              isSelected: current == UserRole.aracSahibi,
              onTap: () => selectedRoleNotifier.value = UserRole.aracSahibi,
            ),
          ],
        );
      },
    );
  }
}

/// E-posta metin giriş alanı.
class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => nextFocusNode.requestFocus(),
      autocorrect: false,
      enableSuggestions: false,
      decoration: const InputDecoration(
        labelText: 'E-posta Adresi',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (String? val) {
        if (val == null || val.trim().isEmpty) return 'E-posta zorunludur.';
        if (!val.contains('@')) return 'Geçerli bir e-posta giriniz.';
        return null;
      },
    );
  }
}

/// Şifre metin giriş alanı.
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onSubmitted(),
      decoration: const InputDecoration(
        labelText: 'Şifre',
        prefixIcon: Icon(Icons.lock_outline_rounded),
      ),
      validator: (String? val) {
        if (val == null || val.length < 6) {
          return 'Şifre en az 6 karakter olmalıdır.';
        }
        return null;
      },
    );
  }
}
