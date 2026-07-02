import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);

    return BBScaffold(
      title: 'Obiettivi',
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crea obiettivo',
        onPressed: () => context.push('/goals/create'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          ...state.goals.map(
            (goal) => Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.push('/goals/${goal.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(goal.emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '${euro(goal.currentAmount)} / ${euro(goal.targetAmount)}',
                                ),
                              ],
                            ),
                          ),
                          Text(percent(goal.progress)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(value: goal.progress),
                      const SizedBox(height: 8),
                      Text(
                        'Da mettere da parte: ${euro(goal.weeklyNeeded(DateTime.now()))}/settimana',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
