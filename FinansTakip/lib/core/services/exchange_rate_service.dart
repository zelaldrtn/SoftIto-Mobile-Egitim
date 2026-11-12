import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'supabase_service.dart';

class ExchangeRateService {
  ExchangeRateService._();
  static final ExchangeRateService instance = ExchangeRateService._();

  // Varsayılan kurlar (TRY bazlı: 1 Birim = X TRY)
  final Map<String, double> _ratesToTRY = {
    AppConstants.currencyTRY: 1.0,
    AppConstants.currencyUSD: 34.50,
    AppConstants.currencyEUR: 37.50,
  };

  DateTime _lastUpdated = DateTime.now();
  DateTime get lastUpdated => _lastUpdated;

  bool _isLoaded = false;

  /// Kurları SharedPreferences ve Supabase'den yükler
  Future<void> init() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(AppConstants.keyExchangeRates);
    if (cached != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(cached);
        if (data['rates'] != null) {
          final Map<String, dynamic> rates = data['rates'];
          rates.forEach((key, val) {
            _ratesToTRY[key] = (val as num).toDouble();
          });
        }
        if (data['updated_at'] != null) {
          _lastUpdated = DateTime.parse(data['updated_at']);
        }
      } catch (e) {
        debugPrint('Kur önbelleği okuma hatası: $e');
      }
    }

    _isLoaded = true;

    // Supabase'den güncel kur çekmeyi dene
    await fetchLiveRates();
  }

  /// Supabase `exchange_rates` tablosundan canlı kur çekmeyi dener
  Future<void> fetchLiveRates() async {
    final client = SupabaseService.instance.client;
    if (client == null) return;

    try {
      final response = await client
          .from('exchange_rates')
          .select('base_currency, target_currency, rate, updated_at');

      final List rows = response as List;
      for (var row in rows) {
        final target = row['target_currency']?.toString();
        final base = row['base_currency']?.toString();
        final rate = (row['rate'] as num?)?.toDouble();

        // TRY bazlı saklama
        if (base == AppConstants.currencyTRY && target != null && rate != null && rate > 0) {
          _ratesToTRY[target] = 1.0 / rate;
        } else if (target == AppConstants.currencyTRY && base != null && rate != null) {
          _ratesToTRY[base] = rate;
        }
      }

      _lastUpdated = DateTime.now();
      await _cacheRates();
    } catch (e) {
      debugPrint('Supabase kurları çekilemedi (önbellek kullanılıyor): $e');
    }
  }

  Future<void> _cacheRates() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'rates': _ratesToTRY,
      'updated_at': _lastUpdated.toIso8601String(),
    };
    await prefs.setString(AppConstants.keyExchangeRates, jsonEncode(data));
  }

  /// Bir dövizden diğerine anlık kur oranı
  double getRate({required String from, required String to}) {
    final fromCur = from.toUpperCase();
    final toCur = to.toUpperCase();
    if (fromCur == toCur) return 1.0;

    final fromToTry = _ratesToTRY[fromCur] ?? 1.0;
    final toToTry = _ratesToTRY[toCur] ?? 1.0;

    if (toToTry == 0) return 1.0;
    return fromToTry / toToTry;
  }

  /// Tutarı kaynak para biriminden hedef para birimine dönüştürür
  double convert(double amount, {required String from, required String to}) {
    if (amount == 0 || from.toUpperCase() == to.toUpperCase()) return amount;
    final rate = getRate(from: from, to: to);
    return amount * rate;
  }

  /// Kullanıcı arayüzü için kur bilgisi metni: "1 USD = 34.50 TRY"
  String formatRateInfo({required String from, required String to}) {
    final rate = getRate(from: from, to: to);
    return '1 $from = ${rate.toStringAsFixed(2)} $to';
  }
}

