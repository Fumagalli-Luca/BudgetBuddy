import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/demo_data.dart';

class BudgetInsight {
  const BudgetInsight({
    required this.title,
    required this.body,
    required this.kind,
  });

  final String title;
  final String body;
  final String kind;
}

abstract class BudgetInsightService {
  Future<List<BudgetInsight>> generateInsights({
    required List<Expense> expenses,
    required List<ExpenseCategory> categories,
    required double monthlyBudget,
  });
}

class LocalMockBudgetInsightService implements BudgetInsightService {
  const LocalMockBudgetInsightService();

  @override
  Future<List<BudgetInsight>> generateInsights({
    required List<Expense> expenses,
    required List<ExpenseCategory> categories,
    required double monthlyBudget,
  }) async {
    final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final byCategory = <String, double>{};
    for (final expense in expenses) {
      byCategory.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final deliveryTotal = byCategory['delivery'] ?? 0;
    final deliveryShare = total == 0 ? 0 : (deliveryTotal / total * 100).round();
    final remaining = monthlyBudget - total;

    return [
      BudgetInsight(
        title: 'Delivery sotto la lente',
        body: 'Questo mese delivery pesa il $deliveryShare% delle spese manuali. Puoi tenerlo come semplice dato di consapevolezza.',
        kind: 'category_share',
      ),
      BudgetInsight(
        title: remaining >= 0 ? 'Budget ancora respirabile' : 'Budget da ribilanciare',
        body: remaining >= 0
            ? 'Hai ancora circa ${remaining.toStringAsFixed(0)} euro disponibili nel budget mensile inserito.'
            : 'Hai superato il budget manuale di ${remaining.abs().toStringAsFixed(0)} euro. Prova a guardare le prossime spese flessibili.',
        kind: 'budget_status',
      ),
      const BudgetInsight(
        title: 'Nota educativa',
        body: 'Gli insight sono organizzativi e non sostituiscono consigli finanziari professionali.',
        kind: 'disclaimer',
      ),
    ];
  }
}

final budgetInsightServiceProvider = Provider<BudgetInsightService>(
  (ref) => const LocalMockBudgetInsightService(),
);
