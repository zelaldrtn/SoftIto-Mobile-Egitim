import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/saving_goal_model.dart';
import '../models/budget_model.dart';
import '../models/recurring_model.dart';
import 'demo_data.dart';

class LocalStorageService {
  static const String _keyTransactions = 'moneyplan_transactions';
  static const String _keyGoals = 'moneyplan_goals';
  static const String _keyBudgets = 'moneyplan_budgets';
  static const String _keyRecurring = 'moneyplan_recurring';
  static const String _keyThemeMode = 'moneyplan_theme_mode';
  static const String _keyIsFirstRun = 'moneyplan_first_run';

  /// İlk açılışta demo verilerini yükler, daha sonraki açılışlarda kaydedilenleri çeker
  static Future<Map<String, dynamic>> loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool(_keyIsFirstRun) ?? true;

    List<TransactionModel> transactions = [];
    List<SavingGoalModel> goals = [];
    List<BudgetLimitModel> budgets = [];
    List<RecurringPaymentModel> recurring = [];
    bool isDarkMode = prefs.getBool(_keyThemeMode) ?? false;

    if (isFirstRun) {
      transactions = DemoData.initialTransactions;
      goals = DemoData.initialSavingGoals;
      budgets = DemoData.initialBudgets;
      recurring = DemoData.initialRecurringPayments;

      // İlk çalıştırma verilerini kaydet
      await saveTransactions(transactions);
      await saveGoals(goals);
      await saveBudgets(budgets);
      await saveRecurring(recurring);
      await prefs.setBool(_keyIsFirstRun, false);
    } else {
      // SharedPreferences'tan oku
      final txString = prefs.getString(_keyTransactions);
      if (txString != null) {
        final List list = jsonDecode(txString);
        transactions = list.map((e) => TransactionModel.fromMap(e)).toList();
      }

      final goalsString = prefs.getString(_keyGoals);
      if (goalsString != null) {
        final List list = jsonDecode(goalsString);
        goals = list.map((e) => SavingGoalModel.fromMap(e)).toList();
      }

      final budgetsString = prefs.getString(_keyBudgets);
      if (budgetsString != null) {
        final List list = jsonDecode(budgetsString);
        budgets = list.map((e) => BudgetLimitModel.fromMap(e)).toList();
      }

      final recurringString = prefs.getString(_keyRecurring);
      if (recurringString != null) {
        final List list = jsonDecode(recurringString);
        recurring = list.map((e) => RecurringPaymentModel.fromMap(e)).toList();
      }
    }

    return {
      'transactions': transactions,
      'goals': goals,
      'budgets': budgets,
      'recurring': recurring,
      'isDarkMode': isDarkMode,
    };
  }

  static Future<void> saveTransactions(List<TransactionModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toMap()).toList();
    await prefs.setString(_keyTransactions, jsonEncode(jsonList));
  }

  static Future<void> saveGoals(List<SavingGoalModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toMap()).toList();
    await prefs.setString(_keyGoals, jsonEncode(jsonList));
  }

  static Future<void> saveBudgets(List<BudgetLimitModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toMap()).toList();
    await prefs.setString(_keyBudgets, jsonEncode(jsonList));
  }

  static Future<void> saveRecurring(List<RecurringPaymentModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toMap()).toList();
    await prefs.setString(_keyRecurring, jsonEncode(jsonList));
  }

  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeMode, isDark);
  }

  static Future<void> resetToDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstRun, true);
  }
}
