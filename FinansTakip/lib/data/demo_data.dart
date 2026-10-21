import '../models/transaction_model.dart';
import '../models/saving_goal_model.dart';
import '../models/budget_model.dart';
import '../models/recurring_model.dart';

/// MoneyPlan Başlangıç Demo Verileri
/// Bu veriler uygulamanın ilk açılışında görsel zenginlik ve kullanıcıya
/// örnek rehber olması amacıyla yüklenir.
class DemoData {
  static List<TransactionModel> get initialTransactions {
    final now = DateTime.now();
    return [
      TransactionModel(
        id: 'tx_demo_1',
        title: 'Maaş Ödemesi',
        amount: 48500.0,
        category: 'Maaş',
        date: DateTime(now.year, now.month, 1),
        type: TransactionType.income,
        isNeed: true,
        note: 'Şirket aylık hakediş',
      ),
      TransactionModel(
        id: 'tx_demo_2',
        title: 'Freelance Tasarım İşi',
        amount: 9200.0,
        category: 'Ek Gelir',
        date: DateTime(now.year, now.month, 5),
        type: TransactionType.income,
        isNeed: true,
        note: 'Mobil uygulama UI tasarımı',
      ),
      TransactionModel(
        id: 'tx_demo_3',
        title: 'Ev Kirası',
        amount: 17500.0,
        category: 'Kira',
        date: DateTime(now.year, now.month, 2),
        type: TransactionType.expense,
        isNeed: true,
        note: 'Ekim ayı ev kirası',
      ),
      TransactionModel(
        id: 'tx_demo_4',
        title: 'Haftalık Süpermarket',
        amount: 3450.0,
        category: 'Market',
        date: DateTime(now.year, now.month, 7),
        type: TransactionType.expense,
        isNeed: true,
        note: 'Meyve, sebze ve temel gıdalar',
      ),
      TransactionModel(
        id: 'tx_demo_5',
        title: 'Arkadaşlarla Akşam Yemeği',
        amount: 1420.0,
        category: 'Yemek',
        date: DateTime(now.year, now.month, 10),
        type: TransactionType.expense,
        isNeed: false, // İstek
        note: 'Kadıköy buluşması',
      ),
      TransactionModel(
        id: 'tx_demo_6',
        title: 'MacBook Pro Birikimi',
        amount: 5000.0,
        category: 'Birikim',
        date: DateTime(now.year, now.month, 12),
        type: TransactionType.saving,
        isNeed: true,
        note: 'Yeni bilgisayar fonuna aktarım',
      ),
      TransactionModel(
        id: 'tx_demo_7',
        title: 'Elektrik & İnternet Faturası',
        amount: 1180.0,
        category: 'Faturalar',
        date: DateTime(now.year, now.month, 14),
        type: TransactionType.expense,
        isNeed: true,
        note: 'Fiber ve elektrik faturası',
      ),
      TransactionModel(
        id: 'tx_demo_8',
        title: 'Yeni Spor Ayakkabı',
        amount: 2800.0,
        category: 'Giyim',
        date: DateTime(now.year, now.month, 16),
        type: TransactionType.expense,
        isNeed: false, // İstek
        note: 'Sezon indirimi alışverişi',
      ),
      TransactionModel(
        id: 'tx_demo_9',
        title: 'Kahve & Tatlı Keyfi',
        amount: 340.0,
        category: 'Yemek',
        date: DateTime(now.year, now.month, 18),
        type: TransactionType.expense,
        isNeed: false, // İstek
        note: 'Haftasonu molası',
      ),
      TransactionModel(
        id: 'tx_demo_10',
        title: 'Japonya Tatili Fonu',
        amount: 4000.0,
        category: 'Birikim',
        date: DateTime(now.year, now.month, 19),
        type: TransactionType.saving,
        isNeed: false,
        note: '2027 Tokyo seyahat birikimi',
      ),
    ];
  }

  static List<SavingGoalModel> get initialSavingGoals {
    return [
      SavingGoalModel(
        id: 'goal_demo_1',
        title: 'MacBook Pro M3 Max',
        targetAmount: 85000.0,
        savedAmount: 51000.0,
        priority: 1,
        iconKey: 'laptop',
        quote: 'Yaratıcılığını özgür bırak, projelerini hızlandır 💻',
        colorHex: '#9D84B7',
      ),
      SavingGoalModel(
        id: 'goal_demo_2',
        title: 'Tokyo & Kyoto Seyahati',
        targetAmount: 110000.0,
        savedAmount: 42000.0,
        priority: 2,
        iconKey: 'travel',
        quote: 'Kiraz çiçekleri altında unutulmaz bir bahar 🌸',
        colorHex: '#F7D965',
      ),
      SavingGoalModel(
        id: 'goal_demo_3',
        title: 'Acil Durum Fonu (6 Aylık)',
        targetAmount: 90000.0,
        savedAmount: 72000.0,
        priority: 1,
        iconKey: 'emergency',
        quote: 'Huzurlu ve güvende bir gelecek için kalkan 🛡️',
        colorHex: '#2D734C',
      ),
    ];
  }

  static List<BudgetLimitModel> get initialBudgets {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return [
      BudgetLimitModel(
        id: 'budget_demo_total',
        month: monthKey,
        category: 'Genel Bütçe',
        limitAmount: 32000.0,
      ),
      BudgetLimitModel(
        id: 'budget_demo_market',
        month: monthKey,
        category: 'Market',
        limitAmount: 7000.0,
      ),
      BudgetLimitModel(
        id: 'budget_demo_yemek',
        month: monthKey,
        category: 'Yemek',
        limitAmount: 4500.0,
      ),
      BudgetLimitModel(
        id: 'budget_demo_giyim',
        month: monthKey,
        category: 'Giyim',
        limitAmount: 3500.0,
      ),
      BudgetLimitModel(
        id: 'budget_demo_eglence',
        month: monthKey,
        category: 'Eğlence',
        limitAmount: 3000.0,
      ),
    ];
  }

  static List<RecurringPaymentModel> get initialRecurringPayments {
    return [
      RecurringPaymentModel(
        id: 'rec_demo_1',
        title: 'Ev Kirası',
        amount: 17500.0,
        category: 'Kira',
        dueDay: 2,
        repeatType: 'Aylık',
        isPaid: true,
        iconKey: 'rent',
      ),
      RecurringPaymentModel(
        id: 'rec_demo_2',
        title: 'Netflix Premium Aile',
        amount: 299.99,
        category: 'Abonelik',
        dueDay: 25,
        repeatType: 'Aylık',
        isPaid: false,
        iconKey: 'netflix',
      ),
      RecurringPaymentModel(
        id: 'rec_demo_3',
        title: 'Spotify Aile Planı',
        amount: 99.99,
        category: 'Abonelik',
        dueDay: 28,
        repeatType: 'Aylık',
        isPaid: false,
        iconKey: 'spotify',
      ),
      RecurringPaymentModel(
        id: 'rec_demo_4',
        title: 'Fiber İnternet',
        amount: 480.0,
        category: 'Faturalar',
        dueDay: 15,
        repeatType: 'Aylık',
        isPaid: true,
        iconKey: 'wifi',
      ),
      RecurringPaymentModel(
        id: 'rec_demo_5',
        title: 'Spor Salonu Üyeliği',
        amount: 1250.0,
        category: 'Sağlık',
        dueDay: 29,
        repeatType: 'Aylık',
        isPaid: false,
        iconKey: 'gym',
      ),
    ];
  }
}
