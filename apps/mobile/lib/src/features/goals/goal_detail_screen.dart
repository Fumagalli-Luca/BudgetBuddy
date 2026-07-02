import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({required this.goalId, super.key});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final goal = state.goals.firstWhere((item) => item.id == goalId);

    return BBScaffold(
      title: goal.title,
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Text(goal.emoji, style: const TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 16),
          Text(
            percent(goal.progress),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: goal.progress, minHeight: 12),
          const SizedBox(height: 12),
          Text(
            '${euro(goal.currentAmount)} raccolti su ${euro(goal.targetAmount)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Piano settimanale',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Per arrivare in tempo servono circa ${euro(goal.weeklyNeeded(DateTime.now()))} a settimana.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [5, 10, 20, 50].map((amount) {
                      return ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: Text('${euro(amount)} virtuali'),
                        onPressed: () => ref
                            .read(budgetBuddyProvider.notifier)
                            .moveToGoal(goal.id, amount.toDouble()),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milestone',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...goal.milestones.map(
                    (milestone) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: goal.progress >= milestone,
                      onChanged: null,
                      title: Text(percent(milestone)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Movimenti virtuali',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          ...goal.transactions.map(
            (transaction) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.savings_outlined),
              title: Text(transaction.note),
              subtitle: Text(
                '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
              ),
              trailing: Text(euro(transaction.amount)),
            ),
          ),
        ],
      ),
    );
  }
}
