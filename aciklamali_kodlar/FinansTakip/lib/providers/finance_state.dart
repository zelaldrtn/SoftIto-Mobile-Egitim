import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/saving_goal_model.dart';
import '../models/budget_model.dart';
import '../models/recurring_model.dart';
import '../data/local_storage.dart';
import '../data/demo_data.dart';

// uygulamanın tüm finansal durumunu (gelir, gider, birikim, bütçe) merkezi olarak yöneten sınıf
// ChangeNotifier sayesinde bir veri değiştiğinde notifyListeners çağrılarak arayüz otomatik yenilenir
class FinanceState extends ChangeNotifier {
  // veriler diskten yüklenirken bekleme ekranını göstermek için durum bayrağı
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // içeride yönetilen özel listeler
  List<TransactionModel> _transactions = [];
  List<SavingGoalModel> _goals = [];
  List<BudgetLimitModel> _budgets = [];
  List<RecurringPaymentModel> _recurring = [];

  // dışarıdan listelerin doğrudan değiştirilmesini engellemek için sadece okunabilir liste döner
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<SavingGoalModel> get goals => List.unmodifiable(_goals);
  List<BudgetLimitModel> get budgets => List.unmodifiable(_budgets);
  List<RecurringPaymentModel> get recurring => List.unmodifiable(_recurring);

  FinanceState() {
    init();
  }

  // uygulama ilk açıldığında yerel hafızadan tüm verileri yükler
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await LocalStorageService.loadAllData();
      _transactions = (data['transactions'] as List<TransactionModel>);
      _goals = (data['goals'] as List<SavingGoalModel>);
      _budgets = (data['budgets'] as List<BudgetLimitModel>);
      _recurring = (data['recurring'] as List<RecurringPaymentModel>);
      _isDarkMode = data['isDarkMode'] as bool? ?? false;
    } catch (e) {
      debugPrint('Veri yükleme hatası: $e');
      // diskten okuma başarısız olursa veya ilk kez açılıyorsa demo verileri devreye alır
      _transactions = DemoData.initialTransactions;
      _goals = DemoData.initialSavingGoals;
      _budgets = DemoData.initialBudgets;
      _recurring = DemoData.initialRecurringPayments;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ==================== TEMA YÖNETİMİ ====================
  // koyu ve açık tema arasında geçiş yapıp tercihi diske yazar
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    LocalStorageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  // ==================== HESAPLANAN DEĞERLER ====================
  /// Toplam Gelir
  // tüm gelir işlemlerini filtreleyip tutarlarını toplar
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Toplam Gider
  // tüm harcamaları filtreleyip toplar
  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Toplam Birikim
  // hedeflere ayrılan tüm birikimleri toplar
  double get totalSaving {
    return _transactions
        .where((t) => t.type == TransactionType.saving)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Mevcut Net Bakiye = Toplam Gelir - (Toplam Gider + Toplam Birikim)
  // kasada şu an kalan gerçek parayı hesaplar
  double get currentBalance {
    return totalIncome - (totalExpense + totalSaving);
  }

  /// Bu ayki toplam harcama
  // sadece içinde bulunduğumuz ay ve yıla ait harcamaları toplar
  double get thisMonthExpense {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Bu ayki toplam gelir
  double get thisMonthIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Bu ayki toplam birikim
  double get thisMonthSaving {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.saving &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Yaklaşan zorunlu ödemeler toplamı (Bu ay henüz ödenmemiş olanlar)
  // faturası veya aboneliği henüz ödenmemiş kalemlerin tutarını hesaplar
  double get upcomingUnpaidRecurringAmount {
    return _recurring
        .where((r) => !r.isPaid)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  /// Aylık genel bütçe limiti
  // bu aya ait tanımlanmış genel harcama sınırını getirir
  double get monthlyGeneralBudgetLimit {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final budget = _budgets.firstWhere(
      (b) => b.month == monthKey && b.category == 'Genel Bütçe',
      orElse: () => BudgetLimitModel(
        id: 'default',
        month: monthKey,
        category: 'Genel Bütçe',
        limitAmount: 30000.0,
      ),
    );
    return budget.limitAmount;
  }

  /// Korunacak Bütçe Payı (Aylık bütçenin %10'u veya minimum tampon)
  // beklenmedik acil durumlar için dokunulmaması gereken güvence payı
  double get protectedBufferAmount {
    return (monthlyGeneralBudgetLimit * 0.10).clamp(500.0, 5000.0);
  }

  /// FORMÜL: Kullanılabilir Para (Usable Money)
  /// kullanılabilir para = mevcut bakiye - yaklaşan zorunlu ödemeler - ayrılmış birikim - korunacak bütçe
  // kullanıcının gönül rahatlığıyla serbestçe harcayabileceği net tutar
  double get usableMoney {
    final usable = currentBalance -
        upcomingUnpaidRecurringAmount -
        thisMonthSaving -
        protectedBufferAmount;
    return usable > 0 ? usable : 0.0;
  }

  /// Günlük önerilen harcama tutarı
  // ayın bitmesine kaç gün kaldıysa serbest parayı gün sayısına bölerek harcama rehberi sunar
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
  // harcamaların aylık bütçenin ne kadarına ulaştığını yüzde olarak hesaplar
  double get budgetUsageRatio {
    if (monthlyGeneralBudgetLimit <= 0) return 0.0;
    return thisMonthExpense / monthlyGeneralBudgetLimit;
  }

  /// Öne çıkan birikim hedefi (En yüksek öncelikli veya en yakın hedef)
  // henüz tamamlanmamış en acil hedefi ana ekranda vurgulamak için seçer
  SavingGoalModel? get primaryGoal {
    if (_goals.isEmpty) return null;
    final incompleted = _goals.where((g) => !g.isCompleted).toList();
    if (incompleted.isEmpty) return _goals.first;
    incompleted.sort((a, b) => a.priority.compareTo(b.priority));
    return incompleted.first;
  }

  /// Kategori bazlı harcama toplamları (Pasta Grafik için)
  // market, fatura, eğlence gibi kategorilere bu ay ne kadar harcandığını gruplar
  Map<String, double> get categoryExpensesThisMonth {
    final now = DateTime.now();
    final map = <String, double>{};
    for (var t in _transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month) {
        map[t.category] = (map[t.category] ?? 0.0) + t.amount;
      }
    }
    return map;
  }

  /// İstek vs İhtiyaç harcama toplamları
  // 50/30/20 kuralına göre harcamaların ne kadarı zorunlu ne kadarı keyfi ayrıştırır
  Map<String, double> get needVsWantExpensesThisMonth {
    final now = DateTime.now();
    double needTotal = 0;
    double wantTotal = 0;
    for (var t in _transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month) {
        if (t.isNeed) {
          needTotal += t.amount;
        } else {
          wantTotal += t.amount;
        }
      }
    }
    return {'İhtiyaç': needTotal, 'İstek': wantTotal};
  }

  /// Son 7 günün günlük harcamaları (Çubuk grafik için)
  // haftalık grafikte her güne karşılık gelen harcama miktarını hesaplar
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
          .fold(0.0, (sum, t) => sum + t.amount);

      final dayLabel = daysOfWeek[dayDate.weekday - 1];
      result.add({
        'day': dayLabel,
        'date': dayDate,
        'amount': dayTotal,
      });
    }
    return result;
  }

  // ==================== İŞLEM AKSİYONLARI ====================
  // yeni gelir veya gider ekleyip listeyi ve diski günceller
  Future<void> addTransaction(TransactionModel tx) async {
    _transactions.insert(0, tx);
    notifyListeners();
    await LocalStorageService.saveTransactions(_transactions);
  }

  // mevcut işlemi günceller
  Future<void> updateTransaction(TransactionModel tx) async {
    final index = _transactions.indexWhere((item) => item.id == tx.id);
    if (index != -1) {
      _transactions[index] = tx;
      notifyListeners();
      await LocalStorageService.saveTransactions(_transactions);
    }
  }

  // işlemi listeden ve yerel hafızadan siler
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((item) => item.id == id);
    notifyListeners();
    await LocalStorageService.saveTransactions(_transactions);
  }

  // ==================== BİRİKİM AKSİYONLARI ====================
  // yeni birikim hedefi ekler
  Future<void> addSavingGoal(SavingGoalModel goal) async {
    _goals.add(goal);
    notifyListeners();
    await LocalStorageService.saveGoals(_goals);
  }

  // mevcut hedefi günceller
  Future<void> updateSavingGoal(SavingGoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
      await LocalStorageService.saveGoals(_goals);
    }
  }

  // hedefi siler
  Future<void> deleteSavingGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
    await LocalStorageService.saveGoals(_goals);
  }

  // hedefe para yatırma işlemi: hem hedefin biriken tutarını artırır hem de işlem geçmişine birikim kaydı ekler
  Future<void> depositToGoal(String goalId, double amount, {String? note}) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final newSaved = goal.savedAmount + amount;
      _goals[index] = goal.copyWith(savedAmount: newSaved);

      // Ayrıca işlem geçmişine de birikim işlemi olarak ekle
      final tx = TransactionModel(
        id: 'tx_goal_${DateTime.now().millisecondsSinceEpoch}',
        title: '${goal.title} Birikimi',
        amount: amount,
        category: 'Birikim',
        date: DateTime.now(),
        type: TransactionType.saving,
        isNeed: true,
        note: note ?? 'Hedefe aktarılan birikim',
      );
      _transactions.insert(0, tx);

      notifyListeners();
      await LocalStorageService.saveGoals(_goals);
      await LocalStorageService.saveTransactions(_transactions);
    }
  }

  // ==================== BÜTÇE AKSİYONLARI ====================
  // belirli bir kategoriye aylık harcama limiti belirler
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
      ));
    }
    notifyListeners();
    await LocalStorageService.saveBudgets(_budgets);
  }

  // ==================== ABONELİK AKSİYONLARI ====================
  // yeni düzenli ödeme/fatura ekler
  Future<void> addRecurringPayment(RecurringPaymentModel rec) async {
    _recurring.add(rec);
    notifyListeners();
    await LocalStorageService.saveRecurring(_recurring);
  }

  // mevcut düzenli ödemeyi günceller
  Future<void> updateRecurringPayment(RecurringPaymentModel rec) async {
    final index = _recurring.indexWhere((r) => r.id == rec.id);
    if (index != -1) {
      _recurring[index] = rec;
      notifyListeners();
      await LocalStorageService.saveRecurring(_recurring);
    }
  }

  // düzenli ödemeyi siler
  Future<void> deleteRecurringPayment(String id) async {
    _recurring.removeWhere((r) => r.id == id);
    notifyListeners();
    await LocalStorageService.saveRecurring(_recurring);
  }

  // faturanın ödendi durumunu tersine çevirir ve ödendiyse harcama olarak kaydeder
  Future<void> toggleRecurringPaid(String id) async {
    final index = _recurring.indexWhere((r) => r.id == id);
    if (index != -1) {
      final rec = _recurring[index];
      final newStatus = !rec.isPaid;
      _recurring[index] = rec.copyWith(isPaid: newStatus);

      // Eğer ödendi olarak işaretlendiyse ve gider olarak eklenmek istenirse:
      if (newStatus) {
        final tx = TransactionModel(
          id: 'tx_rec_${DateTime.now().millisecondsSinceEpoch}',
          title: '${rec.title} Ödemesi',
          amount: rec.amount,
          category: rec.category,
          date: DateTime.now(),
          type: TransactionType.expense,
          isNeed: true,
          note: 'Düzenli ödeme kaydı',
        );
        _transactions.insert(0, tx);
        await LocalStorageService.saveTransactions(_transactions);
      }

      notifyListeners();
      await LocalStorageService.saveRecurring(_recurring);
    }
  }

  /// Tüm verileri ilk demo haline sıfırlama
  // kullanıcı uygulamayı sıfırlamak isterse demo verileri yeniden yazar
  Future<void> resetAll() async {
    await LocalStorageService.resetToDemoData();
    await init();
  }
}

