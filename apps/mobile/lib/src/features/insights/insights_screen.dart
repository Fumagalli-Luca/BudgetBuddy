import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/budget_insight_service.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../state/app_state.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final service = ref.watch(budgetInsightServiceProvider);

    return BBScaffold(
      title: 'Insights',
      showBottomNav: false,
      body: FutureBuilder<List<BudgetInsight>>(
        future: service.generateInsights(
          expenses: state.expenses,
          categories: state.categories,
          monthlyBudget: state.onboarding.monthlyBudget,
        ),
        builder: (context, snapshot) {
          final insights = snapshot.data ?? const <BudgetInsight>[];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const DisclaimerBanner(),
              const SizedBox(height: 16),
              Text(
                'Insight non giudicanti',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Analisi locale basata solo sulle spese manuali inserite nel mock.',
              ),
              const SizedBox(height: 16),
              if (!snapshot.hasData)
                const Center(child: CircularProgressIndicator())
              else
                ...insights.map(
                  (insight) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.auto_awesome),
                      title: Text(insight.title),
                      subtitle: Text(insight.body),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
