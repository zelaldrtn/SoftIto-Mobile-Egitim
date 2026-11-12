import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/exchange_rate_service.dart';
import '../models/account_model.dart';

class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  static const String _keyCards = 'moneyplan_cards';
  static const String _keyCash = 'moneyplan_cash_accounts';
  static const String _keyDebts = 'moneyplan_credit_card_debts';

  List<FinancialCard> _cachedCards = [];
  List<CashAccount> _cachedCashAccounts = [];
  List<CreditCardDebt> _cachedDebts = [];

  List<FinancialCard> get cards => List.unmodifiable(_cachedCards.where((c) => !c.isDeleted));
  List<CashAccount> get cashAccounts => List.unmodifiable(_cachedCashAccounts.where((a) => !a.isDeleted));
  List<CreditCardDebt> get debts => List.unmodifiable(_cachedDebts.where((d) => !d.isSettled));

  Future<void> init() async {
    await _loadFromLocal();
    await fetchFromSupabase();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsStr = prefs.getString(_keyCards);
    if (cardsStr != null) {
      final List list = jsonDecode(cardsStr);
      _cachedCards = list.map((e) => FinancialCard.fromMap(e)).toList();
    } else {
      // Varsayılan başlangıç kartları
      _cachedCards = [
        FinancialCard(
          id: 'card_debit_1',
          cardName: 'Maaş Kartı',
          bankName: 'Garanti BBVA',
          cardType: CardType.debit,
          currency: AppConstants.currencyTRY,
          openingBalance: 15000.0,
          currentBalance: 15000.0,
        ),
        FinancialCard(
          id: 'card_credit_1',
          cardName: 'Bonus Kredi Kartı',
          bankName: 'Garanti BBVA',
          cardType: CardType.credit,
          currency: AppConstants.currencyTRY,
          creditLimit: 30000.0,
          currentDebt: 4500.0,
        ),
      ];
      await _saveCardsToLocal();
    }

    final cashStr = prefs.getString(_keyCash);
    if (cashStr != null) {
      final List list = jsonDecode(cashStr);
      _cachedCashAccounts = list.map((e) => CashAccount.fromMap(e)).toList();
    } else {
      _cachedCashAccounts = [
        CashAccount(
          id: 'cash_try_1',
          accountName: 'TL Cüzdan',
          currency: AppConstants.currencyTRY,
          balance: 3500.0,
        ),
        CashAccount(
          id: 'cash_usd_1',
          accountName: 'Dolar Nakit',
          currency: AppConstants.currencyUSD,
          balance: 200.0,
        ),
      ];
      await _saveCashToLocal();
    }

    final debtsStr = prefs.getString(_keyDebts);
    if (debtsStr != null) {
      final List list = jsonDecode(debtsStr);
      _cachedDebts = list.map((e) => CreditCardDebt.fromMap(e)).toList();
    }
  }

  Future<void> _saveCardsToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCards, jsonEncode(_cachedCards.map((e) => e.toMap()).toList()));
  }

  Future<void> _saveCashToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCash, jsonEncode(_cachedCashAccounts.map((e) => e.toMap()).toList()));
  }

  Future<void> _saveDebtsToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDebts, jsonEncode(_cachedDebts.map((e) => e.toMap()).toList()));
  }

  /// Supabase ile senkronize et
  Future<void> fetchFromSupabase() async {
    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client == null || userId == null) return;

    try {
      final cardsRes = await client.from('cards').select().eq('user_id', userId).eq('is_deleted', false);
      if (cardsRes.isNotEmpty) {
        _cachedCards = cardsRes.map((e) => FinancialCard.fromMap(e)).toList();
        await _saveCardsToLocal();
      }

      final cashRes = await client.from('cash_accounts').select().eq('user_id', userId).eq('is_deleted', false);
      if (cashRes.isNotEmpty) {
        _cachedCashAccounts = cashRes.map((e) => CashAccount.fromMap(e)).toList();
        await _saveCashToLocal();
      }

      final debtsRes = await client.from('credit_card_debts').select().eq('user_id', userId).eq('is_settled', false);
      if (debtsRes.isNotEmpty) {
        _cachedDebts = debtsRes.map((e) => CreditCardDebt.fromMap(e)).toList();
        await _saveDebtsToLocal();
      }
    } catch (e) {
      debugPrint('Supabase hesap yükleme hatası: $e');
    }
  }

  // ==================== KART İŞLEMLERİ ====================

  Future<void> addCard(FinancialCard card) async {
    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;

    FinancialCard newCard = card;
    if (userId != null) {
      newCard = card.copyWith(userId: userId);
    }

    _cachedCards.add(newCard);
    await _saveCardsToLocal();

    if (client != null && userId != null) {
      try {
        await client.from('cards').insert(newCard.toMap());
      } catch (e) {
        debugPrint('Kart Supabase ekleme hatası: $e');
      }
    }
  }

  Future<void> updateCard(FinancialCard card) async {
    final index = _cachedCards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _cachedCards[index] = card;
      await _saveCardsToLocal();

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('cards').update(card.toMap()).eq('id', card.id);
        } catch (e) {
          debugPrint('Kart Supabase güncelleme hatası: $e');
        }
      }
    }
  }

  /// Kart Silme: delete_financial_card() fonksiyonunu kullanır, geçmişi korur
  Future<void> deleteCard(String cardId) async {
    final index = _cachedCards.indexWhere((c) => c.id == cardId);
    if (index == -1) return;

    final targetCard = _cachedCards[index];

    // Eğer kredi kartı ise ve kalan borcu varsa credit_card_debts listesine ekle
    if (targetCard.cardType == CardType.credit && targetCard.currentDebt > 0) {
      final debt = CreditCardDebt(
        id: 'debt_${DateTime.now().millisecondsSinceEpoch}',
        userId: targetCard.userId,
        cardId: targetCard.id,
        cardName: targetCard.cardName,
        remainingDebt: targetCard.currentDebt,
        currency: targetCard.currency,
        isSettled: false,
        createdAt: DateTime.now(),
      );
      _cachedDebts.add(debt);
      await _saveDebtsToLocal();
    }

    // Kartı soft delete yap
    _cachedCards[index] = targetCard.copyWith(isDeleted: true);
    await _saveCardsToLocal();

    final client = SupabaseService.instance.client;
    if (client != null) {
      try {
        // SQL Fonksiyonu çağır
        await client.rpc('delete_financial_card', params: {'p_card_id': cardId});
      } catch (e) {
        debugPrint('delete_financial_card RPC hatası, soft-delete uygulanıyor: $e');
        try {
          await client.from('cards').update({'is_deleted': true}).eq('id', cardId);
        } catch (_) {}
      }
    }
  }

  // ==================== NAKİT HESAP İŞLEMLERİ ====================

  Future<void> addCashAccount(CashAccount account) async {
    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;

    CashAccount newAcc = account;
    if (userId != null) {
      newAcc = account.copyWith(userId: userId);
    }

    _cachedCashAccounts.add(newAcc);
    await _saveCashToLocal();

    if (client != null && userId != null) {
      try {
        await client.from('cash_accounts').insert(newAcc.toMap());
      } catch (e) {
        debugPrint('Nakit hesap Supabase ekleme hatası: $e');
      }
    }
  }

  Future<void> updateCashAccount(CashAccount account) async {
    final index = _cachedCashAccounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _cachedCashAccounts[index] = account;
      await _saveCashToLocal();

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('cash_accounts').update(account.toMap()).eq('id', account.id);
        } catch (e) {
          debugPrint('Nakit hesap Supabase güncelleme hatası: $e');
        }
      }
    }
  }

  Future<void> deleteCashAccount(String accountId) async {
    final index = _cachedCashAccounts.indexWhere((a) => a.id == accountId);
    if (index != -1) {
      _cachedCashAccounts[index] = _cachedCashAccounts[index].copyWith(isDeleted: true);
      await _saveCashToLocal();

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('cash_accounts').update({'is_deleted': true}).eq('id', accountId);
        } catch (e) {
          debugPrint('Nakit hesap silme hatası: $e');
        }
      }
    }
  }

  // ==================== KREDİ KARTI BORÇ ÖDEME (Bölüm 9) ====================
  /// Kaynak: Banka Kartı veya Nakit Hesabı
  /// Hedef: Kredi Kartı
  Future<void> payCreditCardDebt({
    required String creditCardId,
    required double paidAmount, // Kredi kartının kendi para birimindeki düşecek borç tutarı
    String? sourceCardId,
    String? sourceCashAccountId,
  }) async {
    final cardIndex = _cachedCards.indexWhere((c) => c.id == creditCardId);
    if (cardIndex == -1) throw Exception('Kredi kartı bulunamadı.');

    final creditCard = _cachedCards[cardIndex];
    if (creditCard.cardType != CardType.credit) {
      throw Exception('Seçilen kart bir kredi kartı değildir.');
    }

    if (paidAmount <= 0) {
      throw Exception('Ödenecek tutar sıfırdan büyük olmalıdır.');
    }

    // 1. Kaynaktan düşülecek tutarı hesapla
    if (sourceCardId != null) {
      final srcIndex = _cachedCards.indexWhere((c) => c.id == sourceCardId);
      if (srcIndex == -1) throw Exception('Kaynak kart bulunamadı.');
      final srcCard = _cachedCards[srcIndex];

      final convertedAmount = ExchangeRateService.instance.convert(
        paidAmount,
        from: creditCard.currency,
        to: srcCard.currency,
      );

      final newSrcBalance = srcCard.currentBalance - convertedAmount;
      _cachedCards[srcIndex] = srcCard.copyWith(currentBalance: newSrcBalance);
      await updateCard(_cachedCards[srcIndex]);
    } else if (sourceCashAccountId != null) {
      final cashIndex = _cachedCashAccounts.indexWhere((a) => a.id == sourceCashAccountId);
      if (cashIndex == -1) throw Exception('Kaynak nakit hesabı bulunamadı.');
      final cashAcc = _cachedCashAccounts[cashIndex];

      final convertedAmount = ExchangeRateService.instance.convert(
        paidAmount,
        from: creditCard.currency,
        to: cashAcc.currency,
      );

      final newBalance = cashAcc.balance - convertedAmount;
      _cachedCashAccounts[cashIndex] = cashAcc.copyWith(balance: newBalance);
      await updateCashAccount(_cachedCashAccounts[cashIndex]);
    } else {
      throw Exception('Borç ödemesi için geçerli bir kaynak hesap seçilmelidir.');
    }

    // 2. Kredi kartının borcunu azalt
    final newDebt = (creditCard.currentDebt - paidAmount).clamp(0.0, double.infinity);
    _cachedCards[cardIndex] = creditCard.copyWith(currentDebt: newDebt);
    await updateCard(_cachedCards[cardIndex]);

    await _saveCardsToLocal();
    await _saveCashToLocal();
  }
}
