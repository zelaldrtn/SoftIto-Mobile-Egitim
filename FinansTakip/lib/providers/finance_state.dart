import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/supabase_service.dart';
import '../core/services/exchange_rate_service.dart';
import '../core/services/notification_service.dart';
import '../features/accounts/models/account_model.dart';
import '../features/accounts/services/account_service.dart';
import '../models/transaction_model.dart';
import '../models/saving_goal_model.dart';
import '../models/budget_model.dart';
import '../models/recurring_model.dart';
import '../data/local_storage.dart';
import '../data/demo_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceState extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _primaryCurrency = AppConstants.currencyTRY;
  String get primaryCurrency => _primaryCurrency;

  List<TransactionModel> _transactions = [];
  List<SavingGoalModel> _goals = [];
  List<BudgetLimitModel> _budgets = [];
  List<RecurringPaymentModel> _recurring = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<SavingGoalModel> get goals => List.unmodifiable(_goals);
  List<BudgetLimitModel> get budgets => List.unmodifiable(_budgets);
  List<RecurringPaymentModel> get recurring => List.unmodifiable(_recurring);

  // Kartlar ve Nakit Hesaplar
  List<FinancialCard> get cards => AccountService.instance.cards;
  List<CashAccount> get cashAccounts => AccountService.instance.cashAccounts;
  List<CreditCardDebt> get debts => AccountService.instance.debts;

  // Kimlik Doğrulama Bilgileri
  bool get isAuthenticated => SupabaseService.instance.isAuthenticated;
  String get userEmail => SupabaseService.instance.userEmail;
  String get userFullName => SupabaseService.instance.userFullName;

  FinanceState() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Döviz kurlarını başlat
      await ExchangeRateService.instance.init();

      // 2. Bildirim servisini başlat
      await NotificationService.instance.init();

      // 3. Hesap ve kart servisini başlat
      await AccountService.instance.init();

      // 4. Yerel tercihleri ve verileri oku
      final prefs = await SharedPreferences.getInstance();
      _primaryCurrency = prefs.getString(AppConstants.keyPrimaryCurrency) ?? AppConstants.currencyTRY;
      NotificationService.instance.notifyBudgetEnabled = prefs.getBool(AppConstants.keyNotifyBudget) ?? true;
      NotificationService.instance.notifyRecurringEnabled = prefs.getBool(AppConstants.keyNotifyRecurring) ?? true;
      NotificationService.instance.notifySavingsEnabled = prefs.getBool(AppConstants.keyNotifySavings) ?? true;

      final data = await LocalStorageService.loadAllData();
      _transactions = (data['transactions'] as List<TransactionModel>);
      _goals = (data['goals'] as List<SavingGoalModel>);
      _budgets = (data['budgets'] as List<BudgetLimitModel>);
      _recurring = (data['recurring'] as List<RecurringPaymentModel>);
      _isDarkMode = data['isDarkMode'] as bool? ?? false;

      // 5. Supabase oturumu varsa oradan da veri çekmeyi dene
      await _fetchSupabaseDataIfAvailable();

      // 6. Düzenli ödeme ve bütçe bildirim kontrollerini yap
      _checkReminders();
    } catch (e) {
      debugPrint('FinanceState init hatası: $e');
      _transactions = DemoData.initialTransactions;
      _goals = DemoData.initialSavingGoals;
      _budgets = DemoData.initialBudgets;
      _recurring = DemoData.initialRecurringPayments;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchSupabaseDataIfAvailable() async {
    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client == null || userId == null) return;

    try {
      // Supabase'den işlemleri çek
      final dynamic txRes = await client.from('transactions').select().eq('user_id', userId).order('date', ascending: false);
      if (txRes != null && txRes is List && txRes.isNotEmpty) {
        _transactions = txRes.map((e) => TransactionModel.fromMap(e as Map<String, dynamic>)).toList();
        await LocalStorageService.saveTransactions(_transactions);
      }

      // Supabase'den hedefleri çek
      final dynamic goalsRes = await client.from('saving_goals').select().eq('user_id', userId);
      if (goalsRes != null && goalsRes is List && goalsRes.isNotEmpty) {
        _goals = goalsRes.map((e) => SavingGoalModel.fromMap(e as Map<String, dynamic>)).toList();
        await LocalStorageService.saveGoals(_goals);
      }

      // Supabase'den bütçeleri çek
      final dynamic budgetsRes = await client.from('budgets').select().eq('user_id', userId);
      if (budgetsRes != null && budgetsRes is List && budgetsRes.isNotEmpty) {
        _budgets = budgetsRes.map((e) => BudgetLimitModel.fromMap(e as Map<String, dynamic>)).toList();
        await LocalStorageService.saveBudgets(_budgets);
      }

      // Supabase'den abonelikleri çek
      final dynamic recRes = await client.from('recurring_payments').select().eq('user_id', userId);
      if (recRes != null && recRes is List && recRes.isNotEmpty) {
        _recurring = recRes.map((e) => RecurringPaymentModel.fromMap(e as Map<String, dynamic>)).toList();
        await LocalStorageService.saveRecurring(_recurring);
      }
    } catch (e) {
      debugPrint('Supabase veri senkronizasyon hatası: $e');
    }
  }

  // ==================== TEMA & AYARLAR ====================
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    LocalStorageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setPrimaryCurrency(String currency) async {
    if (_primaryCurrency != currency) {
      _primaryCurrency = currency;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyPrimaryCurrency, currency);
      notifyListeners();
    }
  }

  Future<void> setNotificationPreference({
    bool? budget,
    bool? recurring,
    bool? savings,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (budget != null) {
      NotificationService.instance.notifyBudgetEnabled = budget;
      await prefs.setBool(AppConstants.keyNotifyBudget, budget);
    }
    if (recurring != null) {
      NotificationService.instance.notifyRecurringEnabled = recurring;
      await prefs.setBool(AppConstants.keyNotifyRecurring, recurring);
    }
    if (savings != null) {
      NotificationService.instance.notifySavingsEnabled = savings;
      await prefs.setBool(AppConstants.keyNotifySavings, savings);
    }
    notifyListeners();
  }

  // ==================== HESAPLANAN FİNANSAL DEĞERLER (Çoklu Para Birimi Uyumlu) ====================

  /// Toplam Varlıklar (Banka Kartları Açık Bakiyeleri + Nakit Hesaplar) -> Ana Para Birimine Dönüştürülür
  double get totalAssets {
    double sum = 0.0;
    // Banka kartı bakiyeleri
    for (var card in cards) {
      if (card.cardType == CardType.debit) {
        sum += ExchangeRateService.instance.convert(
          card.currentBalance,
          from: card.currency,
          to: _primaryCurrency,
        );
      }
    }
    // Nakit hesap bakiyeleri
    for (var cash in cashAccounts) {
      sum += ExchangeRateService.instance.convert(
        cash.balance,
        from: cash.currency,
        to: _primaryCurrency,
      );
    }
    return sum;
  }

  /// Toplam Borçlar (Kredi Kartı Borçları + Kapatılmamış Eski Borçlar) -> Ana Para Birimine Dönüştürülür
  double get totalDebt {
    double sum = 0.0;
    // Aktif kredi kartı borçları
    for (var card in cards) {
      if (card.cardType == CardType.credit) {
        sum += ExchangeRateService.instance.convert(
          card.currentDebt,
          from: card.currency,
          to: _primaryCurrency,
        );
      }
    }
    // Silinmiş kartlardan kalan borçlar
    for (var debt in debts) {
      sum += ExchangeRateService.instance.convert(
        debt.remainingDebt,
        from: debt.currency,
        to: _primaryCurrency,
      );
    }
    return sum;
  }

  /// Net Bakiye = Toplam Varlıklar - Toplam Borçlar
  double get netBalance {
    return totalAssets - totalDebt;
  }

  /// Mevcut Net Bakiye (Geleneksel bakiye gösterimi için varlıklar toplamı)
  double get currentBalance => totalAssets;

  /// Bu ayki toplam gelir (İşlemlerden dönüştürülerek hesaplanır)
  double get thisMonthIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) {
          final amt = ExchangeRateService.instance.convert(
            t.amount,
            from: t.currency,
            to: _primaryCurrency,
          );
          return sum + amt;
        });
  }

  /// Bu ayki toplam gider (Borç ödemesi normal gider sayılmaz, çift hesaplanmaz!)
  double get thisMonthExpense {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) {
          final amt = ExchangeRateService.instance.convert(
            t.amount,
            from: t.currency,
            to: _primaryCurrency,
          );
          return sum + amt;
        });
  }

  /// Bu ayki toplam birikim
  double get thisMonthSaving {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.saving &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) {
          final amt = ExchangeRateService.instance.convert(
            t.amount,
            from: t.currency,
            to: _primaryCurrency,
          );
          return sum + amt;
        });
  }

  /// Yaklaşan zorunlu ödemeler toplamı (Bu ay henüz ödenmemiş olanlar)
  double get upcomingUnpaidRecurringAmount {
    return _recurring
        .where((r) => !r.isPaid)
        .fold(0.0, (sum, r) {
          final amt = ExchangeRateService.instance.convert(
            r.amount,
            from: r.currency,
            to: _primaryCurrency,
          );
          return sum + amt;
        });
  }

  /// Aylık genel bütçe limiti
  double get monthlyGeneralBudgetLimit {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final budget = _budgets.firstWhere(
      (b) => b.month == monthKey && b.category == 'Genel Bütçe',
      orElse: () => BudgetLimitModel(
        id: 'default',
        month: monthKey,
        category: 'Genel Bütçe',
        limitAmount: 35000.0,
        currency: _primaryCurrency,
      ),
    );
    return ExchangeRateService.instance.convert(
      budget.limitAmount,
      from: budget.currency,
      to: _primaryCurrency,
    );
  }

  /// Korunacak Bütçe Payı (Aylık bütçenin %10'u veya minimum tampon)
  double get protectedBufferAmount {
    return (monthlyGeneralBudgetLimit * 0.10).clamp(500.0, 5000.0);
  }

  /// FORMÜL: Kullanılabilir Para (Usable Money)
  /// kullanılabilir para = mevcut bakiye - yaklaşan zorunlu ödemeler - ayrılmış birikim - korunacak bütçe
  double get usableMoney {
    final usable = totalAssets -
        upcomingUnpaidRecurringAmount -
        thisMonthSaving -
        protectedBufferAmount;
    return usable > 0 ? usable : 0.0;
  }

  /// Günlük önerilen harcama tutarı
  double get dailyRecommendedSpend {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    final remainingDays = (lastDayOfMonth - now.day + 1).clamp(1, 31);
    final rec = usableMoney / remainingDays;
    return rec > 0 ? rec : 0.0;
  }

  /// Haftalık önerilen harcama tutarı
  double get weeklyRecommendedSpend {
    return dailyRecommendedSpend * 7;
  }

  /// Bütçe doluluk oranı (0.0 - 1.0+)
  double get budgetUsageRatio {
    if (monthlyGeneralBudgetLimit <= 0) return 0.0;
    return thisMonthExpense / monthlyGeneralBudgetLimit;
  }

  /// Kalan Aylık Genel Bütçe Tutarı
  double get remainingMonthlyBudget {
    final rem = monthlyGeneralBudgetLimit - thisMonthExpense;
    return rem > 0 ? rem : 0.0;
  }

  /// Öne çıkan birikim hedefi
  SavingGoalModel? get primaryGoal {
    if (_goals.isEmpty) return null;
    final incompleted = _goals.where((g) => !g.isCompleted).toList();
    if (incompleted.isEmpty) return _goals.first;
    incompleted.sort((a, b) => a.priority.compareTo(b.priority));
    return incompleted.first;
  }

  /// Kategori bazlı harcama toplamları (Pasta Grafik için)
  Map<String, double> get categoryExpensesThisMonth {
    final now = DateTime.now();
    final map = <String, double>{};
    for (var t in _transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month) {
        final amt = ExchangeRateService.instance.convert(
          t.amount,
          from: t.currency,
          to: _primaryCurrency,
        );
        map[t.category] = (map[t.category] ?? 0.0) + amt;
      }
    }
    return map;
  }

  /// İstek vs İhtiyaç harcama toplamları
  Map<String, double> get needVsWantExpensesThisMonth {
    final now = DateTime.now();
    double needTotal = 0;
    double wantTotal = 0;
    for (var t in _transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month) {
        final amt = ExchangeRateService.instance.convert(
          t.amount,
          from: t.currency,
          to: _primaryCurrency,
        );
        if (t.isNeed) {
          needTotal += amt;
        } else {
          wantTotal += amt;
        }
      }
    }
    return {'İhtiyaç': needTotal, 'İstek': wantTotal};
  }

  /// Son 7 günün günlük harcamaları
  List<Map<String, dynamic>> get last7DaysExpenses {
    final now = DateTime.now();
    final List<Map<String, dynamic>> result = [];
    final daysOfWeek = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    for (int i = 6; i >= 0; i--) {
      final dayDate = now.subtract(Duration(days: i));
      final dayTotal = _transactions
          .where((t) =>
              t.type == TransactionType.expense &&
              t.date.year == dayDate.year &&
              t.date.month == dayDate.month &&
              t.date.day == dayDate.day)
          .fold(0.0, (sum, t) {
            final amt = ExchangeRateService.instance.convert(
              t.amount,
              from: t.currency,
              to: _primaryCurrency,
            );
            return sum + amt;
          });

      final dayLabel = daysOfWeek[dayDate.weekday - 1];
      result.add({
        'day': dayLabel,
        'date': dayDate,
        'amount': dayTotal,
      });
    }
    return result;
  }

  // ==================== İŞLEM AKSİYONLARI (Gerçek Hesap Bakiyelerine Yansıtma) ====================

  Future<void> addTransaction(TransactionModel tx) async {
    // 1. Hesap bakiye güncellemesi
    await _applyTransactionBalanceImpact(tx, isReversal: false);

    // 2. İşlemi listeye ekle
    _transactions.insert(0, tx);
    notifyListeners();
    await LocalStorageService.saveTransactions(_transactions);

    // 3. Supabase'e ekle
    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client != null && userId != null) {
      try {
        await client.from('transactions').insert(tx.copyWith(userId: userId).toMap());
      } catch (e) {
        debugPrint('Supabase işlem ekleme hatası: $e');
      }
    }

    // 4. Bütçe aşım kontrolü
    _checkBudgetAlerts(tx.category);
  }

  Future<void> updateTransaction(TransactionModel updatedTx) async {
    final index = _transactions.indexWhere((item) => item.id == updatedTx.id);
    if (index != -1) {
      final oldTx = _transactions[index];
      // Eski işlemin bakiye etkisini geri al
      await _applyTransactionBalanceImpact(oldTx, isReversal: true);
      // Yeni işlemin bakiye etkisini uygula
      await _applyTransactionBalanceImpact(updatedTx, isReversal: false);

      _transactions[index] = updatedTx;
      notifyListeners();
      await LocalStorageService.saveTransactions(_transactions);

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('transactions').update(updatedTx.toMap()).eq('id', updatedTx.id);
        } catch (e) {
          debugPrint('Supabase işlem güncelleme hatası: $e');
        }
      }

      _checkBudgetAlerts(updatedTx.category);
    }
  }

  Future<void> deleteTransaction(String id) async {
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index != -1) {
      final oldTx = _transactions[index];
      // Bakiye etkisini geri al
      await _applyTransactionBalanceImpact(oldTx, isReversal: true);

      _transactions.removeAt(index);
      notifyListeners();
      await LocalStorageService.saveTransactions(_transactions);

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('transactions').delete().eq('id', id);
        } catch (e) {
          debugPrint('Supabase işlem silme hatası: $e');
        }
      }
    }
  }

  /// İşlemin hesap bakiyelerine (Banka Kartı, Kredi Kartı, Nakit Hesabı) gerçek etkisi
  Future<void> _applyTransactionBalanceImpact(TransactionModel tx, {required bool isReversal}) async {
    final multiplier = isReversal ? -1.0 : 1.0;

    if (tx.cardId != null) {
      final card = cards.firstWhere((c) => c.id == tx.cardId, orElse: () => FinancialCard(
        id: '',
        cardName: '',
        bankName: '',
        cardType: CardType.debit,
      ));
      if (card.id.isNotEmpty) {
        if (card.cardType == CardType.debit) {
          if (tx.type == TransactionType.income) {
            // Gelir: Banka kartı bakiyesini artırır
            final newBal = card.currentBalance + (tx.amount * multiplier);
            await AccountService.instance.updateCard(card.copyWith(currentBalance: newBal));
          } else if (tx.type == TransactionType.expense || tx.type == TransactionType.saving) {
            // Gider / Birikim: Banka kartı bakiyesini azaltır
            final newBal = card.currentBalance - (tx.amount * multiplier);
            await AccountService.instance.updateCard(card.copyWith(currentBalance: newBal));
          }
        } else if (card.cardType == CardType.credit) {
          if (tx.type == TransactionType.expense) {
            // Kredi kartı harcaması borcu artırır
            final newDebt = card.currentDebt + (tx.amount * multiplier);
            await AccountService.instance.updateCard(card.copyWith(currentDebt: newDebt));
          }
        }
      }
    } else if (tx.cashAccountId != null) {
      final cash = cashAccounts.firstWhere((a) => a.id == tx.cashAccountId, orElse: () => CashAccount(
        id: '',
        accountName: '',
      ));
      if (cash.id.isNotEmpty) {
        if (tx.type == TransactionType.income) {
          final newBal = cash.balance + (tx.amount * multiplier);
          await AccountService.instance.updateCashAccount(cash.copyWith(balance: newBal));
        } else if (tx.type == TransactionType.expense || tx.type == TransactionType.saving) {
          final newBal = cash.balance - (tx.amount * multiplier);
          await AccountService.instance.updateCashAccount(cash.copyWith(balance: newBal));
        }
      }
    }
  }

  // ==================== KART & HESAP AKSİYONLARI ====================

  Future<void> addCard(FinancialCard card) async {
    await AccountService.instance.addCard(card);
    notifyListeners();
  }

  Future<void> updateCard(FinancialCard card) async {
    await AccountService.instance.updateCard(card);
    notifyListeners();
  }

  Future<void> deleteCard(String cardId) async {
    await AccountService.instance.deleteCard(cardId);
    notifyListeners();
  }

  Future<void> addCashAccount(CashAccount account) async {
    await AccountService.instance.addCashAccount(account);
    notifyListeners();
  }

  Future<void> updateCashAccount(CashAccount account) async {
    await AccountService.instance.updateCashAccount(account);
    notifyListeners();
  }

  Future<void> deleteCashAccount(String accountId) async {
    await AccountService.instance.deleteCashAccount(accountId);
    notifyListeners();
  }

  /// Kredi Kartı Borç Ödeme (Bölüm 9)
  /// - Nakit hesabı veya banka kartından ödenir.
  /// - Normal gider olarak kaydedilmez.
  /// - İşlem geçmişine TransactionType.debtPayment olarak kaydedilir.
  Future<void> payCreditCardDebt({
    required String creditCardId,
    required double paidAmount,
    String? sourceCardId,
    String? sourceCashAccountId,
    String? note,
  }) async {
    final creditCard = cards.firstWhere((c) => c.id == creditCardId);

    // 1. Hesap bakiyelerini ve kredi kartı borcunu güncelle
    await AccountService.instance.payCreditCardDebt(
      creditCardId: creditCardId,
      paidAmount: paidAmount,
      sourceCardId: sourceCardId,
      sourceCashAccountId: sourceCashAccountId,
    );

    // 2. İşlem geçmişine "Kredi Kartı Borç Ödemesi" olarak ekle (Aylık gider raporuna katılmaz!)
    String sourceName = 'Hesap';
    if (sourceCardId != null) {
      final src = cards.firstWhere((c) => c.id == sourceCardId, orElse: () => creditCard);
      sourceName = src.cardName;
    } else if (sourceCashAccountId != null) {
      final src = cashAccounts.firstWhere((a) => a.id == sourceCashAccountId, orElse: () => cashAccounts.first);
      sourceName = src.accountName;
    }

    final tx = TransactionModel(
      id: 'tx_debt_${DateTime.now().millisecondsSinceEpoch}',
      title: '${creditCard.cardName} Borç Ödemesi ($sourceName)',
      amount: paidAmount,
      category: 'Borç Ödemesi',
      date: DateTime.now(),
      type: TransactionType.debtPayment,
      currency: creditCard.currency,
      exchangeRate: ExchangeRateService.instance.getRate(
        from: creditCard.currency,
        to: _primaryCurrency,
      ),
      amountInPrimary: ExchangeRateService.instance.convert(
        paidAmount,
        from: creditCard.currency,
        to: _primaryCurrency,
      ),
      primaryCurrency: _primaryCurrency,
      note: note ?? 'Kredi kartı borç kapatma ödemesi',
    );

    _transactions.insert(0, tx);
    await LocalStorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  // ==================== BİRİKİM AKSİYONLARI ====================

  Future<void> addSavingGoal(SavingGoalModel goal) async {
    _goals.add(goal);
    notifyListeners();
    await LocalStorageService.saveGoals(_goals);

    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client != null && userId != null) {
      try {
        await client.from('saving_goals').insert(goal.copyWith(userId: userId).toMap());
      } catch (e) {
        debugPrint('Supabase hedef ekleme hatası: $e');
      }
    }
  }

  Future<void> updateSavingGoal(SavingGoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
      await LocalStorageService.saveGoals(_goals);

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('saving_goals').update(goal.toMap()).eq('id', goal.id);
        } catch (e) {
          debugPrint('Supabase hedef güncelleme hatası: $e');
        }
      }
    }
  }

  Future<void> deleteSavingGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
    await LocalStorageService.saveGoals(_goals);

    final client = SupabaseService.instance.client;
    if (client != null) {
      try {
        await client.from('saving_goals').delete().eq('id', id);
      } catch (e) {
        debugPrint('Supabase hedef silme hatası: $e');
      }
    }
  }

  /// Hedefe para ekleme:
  /// Seçenek 1: Yalnızca birikim hedefine ekle.
  /// Seçenek 2: Seçilen banka kartı veya nakit hesabından düşerek ekle.
  Future<void> depositToGoal(
    String goalId,
    double amount, {
    String? note,
    String? sourceCardId,
    String? sourceCashAccountId,
  }) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1 || amount <= 0) return;

    final goal = _goals[index];
    final newSaved = goal.savedAmount + amount;
    final updatedGoal = goal.copyWith(savedAmount: newSaved);
    _goals[index] = updatedGoal;

    // Eğer kaynak hesap seçilmişse bakiyeden düş ve işlem oluştur
    if (sourceCardId != null || sourceCashAccountId != null) {
      final tx = TransactionModel(
        id: 'tx_goal_${DateTime.now().millisecondsSinceEpoch}',
        title: '${goal.title} Birikimi',
        amount: amount,
        category: 'Birikim',
        date: DateTime.now(),
        type: TransactionType.saving,
        currency: goal.currency,
        cardId: sourceCardId,
        cashAccountId: sourceCashAccountId,
        note: note ?? 'Hedefe aktarılan tutar',
      );
      await addTransaction(tx);
    } else {
      // Yalnızca hedef kaydını güncelle
      await LocalStorageService.saveGoals(_goals);
    }

    // Hedef tamamlandıysa bildirim gönder
    if (updatedGoal.isCompleted) {
      NotificationService.instance.notifyGoalCompleted(updatedGoal.title);
    }

    notifyListeners();
  }

  // ==================== BÜTÇE AKSİYONLARI ====================

  Future<void> setBudgetLimit(String category, double amount) async {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final index = _budgets.indexWhere((b) => b.month == monthKey && b.category == category);

    if (index != -1) {
      _budgets[index] = _budgets[index].copyWith(limitAmount: amount);
    } else {
      _budgets.add(BudgetLimitModel(
        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
        month: monthKey,
        category: category,
        limitAmount: amount,
        currency: _primaryCurrency,
      ));
    }
    notifyListeners();
    await LocalStorageService.saveBudgets(_budgets);

    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client != null && userId != null) {
      try {
        final b = _budgets.firstWhere((item) => item.month == monthKey && item.category == category);
        await client.from('budgets').upsert(b.copyWith(userId: userId).toMap());
      } catch (e) {
        debugPrint('Supabase bütçe kaydetme hatası: $e');
      }
    }
  }

  void _checkBudgetAlerts(String category) {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final budget = _budgets.firstWhere(
      (b) => b.month == monthKey && (b.category == category || b.category == 'Genel Bütçe'),
      orElse: () => BudgetLimitModel(id: '', month: '', category: '', limitAmount: 0),
    );

    if (budget.limitAmount > 0) {
      final spent = (category == 'Genel Bütçe')
          ? thisMonthExpense
          : (categoryExpensesThisMonth[category] ?? 0.0);
      NotificationService.instance.checkBudgetLimit(
        category: budget.category,
        spent: spent,
        limit: budget.limitAmount,
      );
    }
  }

  // ==================== DÜZENLİ ÖDEME AKSİYONLARI ====================

  Future<void> addRecurringPayment(RecurringPaymentModel rec) async {
    _recurring.add(rec);
    notifyListeners();
    await LocalStorageService.saveRecurring(_recurring);

    final client = SupabaseService.instance.client;
    final userId = SupabaseService.instance.currentUserId;
    if (client != null && userId != null) {
      try {
        await client.from('recurring_payments').insert(rec.copyWith(userId: userId).toMap());
      } catch (e) {
        debugPrint('Supabase abonelik ekleme hatası: $e');
      }
    }
  }

  Future<void> updateRecurringPayment(RecurringPaymentModel rec) async {
    final index = _recurring.indexWhere((r) => r.id == rec.id);
    if (index != -1) {
      _recurring[index] = rec;
      notifyListeners();
      await LocalStorageService.saveRecurring(_recurring);

      final client = SupabaseService.instance.client;
      if (client != null) {
        try {
          await client.from('recurring_payments').update(rec.toMap()).eq('id', rec.id);
        } catch (e) {
          debugPrint('Supabase abonelik güncelleme hatası: $e');
        }
      }
    }
  }

  Future<void> deleteRecurringPayment(String id) async {
    _recurring.removeWhere((r) => r.id == id);
    notifyListeners();
    await LocalStorageService.saveRecurring(_recurring);

    final client = SupabaseService.instance.client;
    if (client != null) {
      try {
        await client.from('recurring_payments').delete().eq('id', id);
      } catch (e) {
        debugPrint('Supabase abonelik silme hatası: $e');
      }
    }
  }

  /// Düzenli ödeme ödendi toggle'ı (Otomatik işlem oluşturmaz, yalnızca ödeme durumunu değiştirir)
  Future<void> toggleRecurringPaid(String id) async {
    final index = _recurring.indexWhere((r) => r.id == id);
    if (index != -1) {
      final rec = _recurring[index];
      _recurring[index] = rec.copyWith(isPaid: !rec.isPaid);
      notifyListeners();
      await LocalStorageService.saveRecurring(_recurring);
    }
  }

  double getTemplatePrice(String title, double defaultPrice) {
    final clean = title.trim().toLowerCase();
    for (var r in _recurring) {
      if (r.title.trim().toLowerCase() == clean) return r.amount;
    }
    for (var t in _transactions) {
      final tTitle = t.title.replaceAll(' Ödemesi', '').trim().toLowerCase();
      if (tTitle == clean || t.title.trim().toLowerCase().contains(clean)) return t.amount;
    }
    return defaultPrice;
  }

  void _checkReminders() {
    final now = DateTime.now();
    for (var r in _recurring) {
      if (!r.isPaid && r.reminderEnabled) {
        final days = r.daysRemaining(now);
        NotificationService.instance.checkRecurringReminder(
          title: r.title,
          daysRemaining: days,
        );
      }
    }
  }

  // ==================== AUTH İŞLEMLERİ ====================

  Future<void> signIn({required String email, required String password}) async {
    await SupabaseService.instance.signIn(email: email, password: password);
    await init();
  }

  Future<void> signUp({required String email, required String password, String? fullName}) async {
    await SupabaseService.instance.signUp(email: email, password: password, fullName: fullName);
    await init();
  }

  Future<void> signOut() async {
    await SupabaseService.instance.signOut();
    await init();
  }

  Future<void> deleteAccount() async {
    await SupabaseService.instance.deleteAccount();
    await resetAll();
  }

  Future<void> resetAll() async {
    await LocalStorageService.resetToDemoData();
    await init();
  }
}
