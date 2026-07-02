import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../state/app_state.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final goal = state.primaryGoal;
    final scheme = Theme.of(context).colorScheme;

    return BBScaffold(
      title: 'Ciao, ${state.user.displayName}',
      actions: [
        IconButton(
          tooltip: 'Insights',
          onPressed: () => context.push('/insights'),
          icon: const Icon(Icons.auto_awesome),
        ),
        IconButton(
          tooltip: 'Impostazioni',
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/add'),
        icon: const Icon(Icons.add),
        label: const Text('Spesa'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const DisclaimerBanner(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo manuale disponibile',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.82),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  euro(state.availableBalance),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: (state.monthlyExpenses / state.onboarding.monthlyBudget)
                      .clamp(0, 1)
                      .toDouble(),
                  backgroundColor: scheme.onPrimary.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '${euro(state.monthlyExpenses)} spesi su ${euro(state.onboarding.monthlyBudget)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.86),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${state.user.streak} giorni',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  icon: Icons.emoji_events,
                  label: 'Livello',
                  value: '${state.user.level}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
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
                              'Obiettivo principale',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              goal.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(percent(goal.progress)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(value: goal.progress),
                  const SizedBox(height: 8),
                  Text(
                    '${euro(goal.currentAmount)} di ${euro(goal.targetAmount)}. Circa ${euro(goal.weeklyNeeded(DateTime.now()))}/settimana.',
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/goals/${goal.id}'),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Dettagli'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tips_and_updates, color: scheme.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggerimento del giorno',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Prima di un acquisto non urgente, aspetta 24 ore e guarda che impatto ha sul tuo obiettivo.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/simulator'),
                  icon: const Icon(Icons.psychology_alt_outlined),
                  label: const Text('Simulatore'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/groups/${state.group.id}'),
                  icon: const Icon(Icons.group_outlined),
                  label: const Text('Gruppo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
