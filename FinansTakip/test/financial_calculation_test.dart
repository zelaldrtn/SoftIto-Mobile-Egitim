import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moneyplan/core/services/exchange_rate_service.dart';
import 'package:moneyplan/features/accounts/models/account_model.dart';
import 'package:moneyplan/models/transaction_model.dart';
import 'package:moneyplan/providers/finance_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Financial Calculations & Operations Tests', () {
    test('ExchangeRateService converts currencies accurately', () async {
      final rateService = ExchangeRateService.instance;
      // Default rate: 1 USD = 34.50 TRY
      final convertedTRY = rateService.convert(100.0, from: 'USD', to: 'TRY');
      expect(convertedTRY, equals(3450.0));

      // Same currency conversion
      final sameCurrency = rateService.convert(500.0, from: 'TRY', to: 'TRY');
      expect(sameCurrency, equals(500.0));
    });

    test('FinancialCard available limit calculation', () {
      final creditCard = FinancialCard(
        id: 'cc_1',
        cardName: 'Bonus',
        bankName: 'Garanti',
        cardType: CardType.credit,
        creditLimit: 20000.0,
        currentDebt: 5000.0,
      );

      expect(creditCard.availableLimit, equals(15000.0));
      expect(creditCard.debtUsageRatio, equals(0.25));
    });

    test('Credit Card Debt Payoff decreases debt and decreases source balance without counting as monthly expense', () async {
      final state = FinanceState();
      await state.init();

      // Find initial balances
      final initialCreditCards = state.cards.where((c) => c.cardType == CardType.credit).toList();
      final initialDebitCards = state.cards.where((c) => c.cardType == CardType.debit).toList();

      expect(initialCreditCards.isNotEmpty, isTrue);
      expect(initialDebitCards.isNotEmpty, isTrue);

      final creditCard = initialCreditCards.first;
      final debitCard = initialDebitCards.first;

      final initialDebt = creditCard.currentDebt;
      final initialDebitBalance = debitCard.currentBalance;
      final initialMonthlyExpense = state.thisMonthExpense;

      const payAmount = 1000.0;
      await state.payCreditCardDebt(
        creditCardId: creditCard.id,
        paidAmount: payAmount,
        sourceCardId: debitCard.id,
      );

      // Verify updated cards
      final updatedCreditCard = state.cards.firstWhere((c) => c.id == creditCard.id);
      final updatedDebitCard = state.cards.firstWhere((c) => c.id == debitCard.id);

      expect(updatedCreditCard.currentDebt, equals((initialDebt - payAmount).clamp(0.0, double.infinity)));
      expect(updatedDebitCard.currentBalance, equals(initialDebitBalance - payAmount));

      // Verify debt payoff is NOT added to monthly expense
      expect(state.thisMonthExpense, equals(initialMonthlyExpense));

      // Verify transaction is recorded as debtPayment
      final lastTx = state.transactions.first;
      expect(lastTx.type, equals(TransactionType.debtPayment));
      expect(lastTx.amount, equals(payAmount));
    });

    test('Adding expense from Debit Card decreases its balance', () async {
      final state = FinanceState();
      await state.init();

      final debitCard = state.cards.firstWhere((c) => c.cardType == CardType.debit);
      final initialBalance = debitCard.currentBalance;

      final tx = TransactionModel(
        id: 'test_exp_1',
        title: 'Market Test',
        amount: 250.0,
        category: 'Market',
        date: DateTime.now(),
        type: TransactionType.expense,
        cardId: debitCard.id,
      );

      await state.addTransaction(tx);

      final updatedDebitCard = state.cards.firstWhere((c) => c.id == debitCard.id);
      expect(updatedDebitCard.currentBalance, equals(initialBalance - 250.0));
    });
  });
}
