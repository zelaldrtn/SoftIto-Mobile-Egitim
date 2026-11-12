import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  User? get currentUser => client?.auth.currentUser;
  String? get currentUserId => currentUser?.id;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState>? get authStateChanges => client?.auth.onAuthStateChange;

  Future<bool> initialize({String? url, String? anonKey}) async {
    final effectiveUrl = url ?? AppConstants.supabaseUrl;
    final effectiveAnonKey = anonKey ?? AppConstants.supabaseAnonKey;

    if (effectiveUrl.isEmpty || effectiveAnonKey.isEmpty) {
      debugPrint(
        '⚠️ [SupabaseService] SUPABASE_URL veya SUPABASE_ANON_KEY tanımlanmamış.\n'
        'Uygulama yerel güvenli modda çalışıyor. (Demo & Offline desteği devrede)',
      );
      _isInitialized = false;
      return false;
    }

    try {
      await Supabase.initialize(
        url: effectiveUrl,
        anonKey: effectiveAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      _isInitialized = true;
      debugPrint('✅ [SupabaseService] Supabase bağlantısı kuruldu: $effectiveUrl');
      return true;
    } catch (e) {
      debugPrint('⚠️ [SupabaseService] Bağlantı başlatma hatası: $e');
      _isInitialized = false;
      return false;
    }
  }

  // ==================== AUTH METOTLARI ====================

  /// E-posta ve şifre ile giriş
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized || client == null) {
      throw const AuthException('Supabase bağlantısı henüz yapılandırılmadı.');
    }
    return await client!.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// E-posta ile kayıt
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (!_isInitialized || client == null) {
      throw const AuthException('Supabase bağlantısı henüz yapılandırılmadı.');
    }
    return await client!.auth.signUp(
      email: email.trim(),
      password: password,
      data: fullName != null ? {'full_name': fullName.trim()} : null,
    );
  }

  /// Şifre sıfırlama e-postası gönderme
  Future<void> resetPasswordForEmail(String email) async {
    if (!_isInitialized || client == null) {
      throw const AuthException('Supabase bağlantısı henüz yapılandırılmadı.');
    }
    await client!.auth.resetPasswordForEmail(email.trim());
  }

  /// Şifre güncelleme
  Future<void> updatePassword(String newPassword) async {
    if (!_isInitialized || client == null) {
      throw const AuthException('Supabase bağlantısı henüz yapılandırılmadı.');
    }
    await client!.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Oturum kapatma
  Future<void> signOut() async {
    if (_isInitialized && client != null && isAuthenticated) {
      await client!.auth.signOut();
    }
  }

  /// Hesap silme
  Future<void> deleteAccount() async {
    if (!_isInitialized || client == null || !isAuthenticated) return;
    try {
      // Supabase RPC veya delete çağrısı
      await client!.rpc('delete_user_account');
    } catch (_) {
      // RPC yoksa oturumu kapat ve profil kaydını temizle
      final userId = currentUserId;
      if (userId != null) {
        await client!.from('profiles').delete().eq('id', userId);
      }
      await signOut();
    }
  }
}

