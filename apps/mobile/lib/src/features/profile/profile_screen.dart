import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final earnedBadges = state.userBadges
        .map((userBadge) => state.badges.firstWhere((badge) => badge.id == userBadge.badgeId))
        .toList();

    return BBScaffold(
      title: 'Profilo',
      actions: [
        IconButton(
          tooltip: 'Impostazioni',
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Text(state.user.avatarEmoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user.displayName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        Text('@${state.user.username}'),
                        const SizedBox(height: 8),
                        Text('Livello ${state.user.level} - ${state.user.xp} XP'),
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
              Expanded(child: _ProfileStat(label: 'Streak', value: '${state.user.streak}')),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileStat(
                  label: 'Obiettivi',
                  value: '${state.user.goalsCompleted}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Badge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: earnedBadges
                .map(
                  (badge) => Chip(
                    avatar: Text(badge.emoji),
                    label: Text(badge.name),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy social'),
              subtitle: Text(
                state.user.showOnlyPercentages
                    ? 'Nei gruppi mostri solo percentuali.'
                    : 'Nei gruppi mostri piu dettagli.',
              ),
              trailing: Switch(
                value: state.user.showOnlyPercentages,
                onChanged: (value) => ref
                    .read(budgetBuddyProvider.notifier)
                    .setPrivacyPercentagesOnly(value),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune),
            label: const Text('Impostazioni'),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
  });

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
            Text(label),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
