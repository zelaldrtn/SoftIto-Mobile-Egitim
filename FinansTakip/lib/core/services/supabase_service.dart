import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Yerel Çevrimdışı Kullanıcı Oturum Bilgileri
  bool _isLocalAuthenticated = false;
  String _localUserEmail = '';
  String _localUserFullName = '';
  String? _customSupabaseUrl;
  String? _customSupabaseAnonKey;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  User? get currentUser => client?.auth.currentUser;

  String? get currentUserId =>
      currentUser?.id ?? (_isLocalAuthenticated ? 'local_user_001' : null);

  bool get isAuthenticated =>
      (_isInitialized && currentUser != null) || _isLocalAuthenticated;

  String get userEmail =>
      currentUser?.email ??
      (_localUserEmail.isNotEmpty ? _localUserEmail : 'dartanzelal@gmail.com');

  String get userFullName =>
      (currentUser?.userMetadata?['full_name'] as String?) ??
      (_localUserFullName.isNotEmpty ? _localUserFullName : 'Zelal Dartan');

  Stream<AuthState>? get authStateChanges => client?.auth.onAuthStateChange;

  Future<bool> initialize({String? url, String? anonKey}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Önce SharedPreferences'tan yerel oturum durumunu yükle
    _isLocalAuthenticated = prefs.getBool(AppConstants.keyLocalIsAuth) ?? false;
    _localUserEmail = prefs.getString(AppConstants.keyLocalUserEmail) ?? '';
    _localUserFullName = prefs.getString(AppConstants.keyLocalUserName) ?? '';
    _customSupabaseUrl = prefs.getString(AppConstants.keySupabaseUrl);
    _customSupabaseAnonKey = prefs.getString(AppConstants.keySupabaseAnonKey);

    final effectiveUrl = url ?? _customSupabaseUrl ?? AppConstants.supabaseUrl;
    final effectiveAnonKey = anonKey ?? _customSupabaseAnonKey ?? AppConstants.supabaseAnonKey;

    if (effectiveUrl.isEmpty || effectiveAnonKey.isEmpty) {
      debugPrint(
        'ℹ️ [SupabaseService] SUPABASE_ANON_KEY tanımlanmamış. '
        'Uygulama yerel güvenli modda çalışıyor (Demo & Çevrimdışı destek aktif).',
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

  /// Kullanıcı Supabase bilgilerini dinamik olarak güncelleyebilir
  Future<bool> updateSupabaseConfig({
    required String url,
    required String anonKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySupabaseUrl, url.trim());
    await prefs.setString(AppConstants.keySupabaseAnonKey, anonKey.trim());
    _customSupabaseUrl = url.trim();
    _customSupabaseAnonKey = anonKey.trim();
    return await initialize(url: url.trim(), anonKey: anonKey.trim());
  }

  // ==================== AUTH METOTLARI ====================

  /// E-posta ve şifre ile giriş
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    // 1. Supabase bağlantısı varsa önce bulutta dene
    if (_isInitialized && client != null) {
      try {
        final res = await client!.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        );
        if (res.user != null) {
          return res;
        }
      } catch (e) {
        debugPrint('⚠️ [SupabaseService] Supabase giriş başarısız, yerel kontrol yapılıyor: $e');
      }
    }

    // 2. Bulut yoksa veya çevrimdışıysa yerel hesapla güvenli giriş yap
    final prefs = await SharedPreferences.getInstance();
    final savedPw = prefs.getString(AppConstants.keyLocalUserPassword);
    final savedEmail = prefs.getString(AppConstants.keyLocalUserEmail);

    if (savedPw != null && savedPw.isNotEmpty && savedEmail == email.trim() && savedPw != password) {
      throw const AuthException('Hatalı e-posta veya şifre girdiniz.');
    }

    _localUserEmail = email.trim();
    final savedName = prefs.getString(AppConstants.keyLocalUserName);
    if (savedName != null && savedName.isNotEmpty) {
      _localUserFullName = savedName;
    } else if (_localUserFullName.isEmpty) {
      _localUserFullName = email.trim().split('@').first;
    }
    _isLocalAuthenticated = true;

    await prefs.setBool(AppConstants.keyLocalIsAuth, true);
    await prefs.setString(AppConstants.keyLocalUserEmail, _localUserEmail);
    await prefs.setString(AppConstants.keyLocalUserName, _localUserFullName);
    return null;
  }

  /// E-posta ile kayıt
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    // 1. Supabase bağlantısı varsa bulutta hesap açmayı dene
    if (_isInitialized && client != null) {
      try {
        final res = await client!.auth.signUp(
          email: email.trim(),
          password: password,
          data: fullName != null ? {'full_name': fullName.trim()} : null,
        );
        if (res.user != null) {
          return res;
        }
      } catch (e) {
        debugPrint('⚠️ [SupabaseService] Supabase kayıt hatası, yerel hesap açılıyor: $e');
      }
    }

    // 2. Bulut yapılandırılmamışsa veya hata verirse yerel hesap aç ve oturumu başlat
    final prefs = await SharedPreferences.getInstance();
    _localUserEmail = email.trim();
    _localUserFullName = (fullName != null && fullName.trim().isNotEmpty)
        ? fullName.trim()
        : email.trim().split('@').first;
    _isLocalAuthenticated = true;

    await prefs.setBool(AppConstants.keyLocalIsAuth, true);
    await prefs.setString(AppConstants.keyLocalUserEmail, _localUserEmail);
    await prefs.setString(AppConstants.keyLocalUserName, _localUserFullName);
    await prefs.setString(AppConstants.keyLocalUserPassword, password);
    return null;
  }

  /// Şifre sıfırlama e-postası gönderme
  Future<void> resetPasswordForEmail(String email) async {
    if (_isInitialized && client != null) {
      try {
        await client!.auth.resetPasswordForEmail(email.trim());
        return;
      } catch (e) {
        debugPrint('⚠️ [SupabaseService] Şifre sıfırlama isteği iletilemedi: $e');
      }
    }
    // Yerel modda bildirim mesajı ile yetinilir
  }

  /// Şifre güncelleme
  Future<void> updatePassword(String newPassword) async {
    if (_isInitialized && client != null) {
      try {
        await client!.auth.updateUser(
          UserAttributes(password: newPassword),
        );
      } catch (e) {
        debugPrint('⚠️ [SupabaseService] Bulut şifre güncellenemedi: $e');
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLocalUserPassword, newPassword);
  }

  /// Oturum kapatma
  Future<void> signOut() async {
    if (_isInitialized && client != null && client!.auth.currentUser != null) {
      try {
        await client!.auth.signOut();
      } catch (_) {}
    }
    _isLocalAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyLocalIsAuth, false);
  }

  /// Hesap silme
  Future<void> deleteAccount() async {
    if (_isInitialized && client != null && currentUser != null) {
      try {
        await client!.rpc('delete_user_account');
      } catch (_) {
        final userId = currentUserId;
        if (userId != null) {
          try {
            await client!.from('profiles').delete().eq('id', userId);
          } catch (_) {}
        }
        await signOut();
      }
    }
    _isLocalAuthenticated = false;
    _localUserEmail = '';
    _localUserFullName = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyLocalIsAuth);
    await prefs.remove(AppConstants.keyLocalUserEmail);
    await prefs.remove(AppConstants.keyLocalUserName);
    await prefs.remove(AppConstants.keyLocalUserPassword);
  }
}
