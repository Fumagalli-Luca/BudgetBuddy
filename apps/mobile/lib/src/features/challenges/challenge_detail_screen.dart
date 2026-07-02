import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  const ChallengeDetailScreen({required this.challengeId, super.key});

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final challenge = state.challenges.firstWhere((item) => item.id == challengeId);
    final userProgress = challenge.participants.firstWhere(
      (participant) => participant.userId == state.user.id,
    );
    final badge = state.badges.firstWhere((item) => item.id == challenge.badgeId);

    return BBScaffold(
      title: challenge.title,
      showBottomNav: false,
      actions: [
        IconButton(
          tooltip: 'Segnala contenuto',
          onPressed: () => _showReportDialog(context),
          icon: const Icon(Icons.flag_outlined),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            challenge.isGroupChallenge
                ? Icons.groups_2_outlined
                : Icons.emoji_events_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            challenge.description,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: userProgress.progress, minHeight: 12),
          const SizedBox(height: 8),
          Text('${percent(userProgress.progress)} completato'),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Text(badge.emoji, style: const TextStyle(fontSize: 32)),
              title: Text('Badge: ${badge.name}'),
              subtitle: Text('${badge.description} - ${challenge.rewardXp} XP'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: userProgress.completed
                ? null
                : () {
                    ref
                        .read(budgetBuddyProvider.notifier)
                        .completeChallenge(challenge.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Badge ${badge.name} assegnato.')),
                    );
                  },
            icon: const Icon(Icons.check_circle_outline),
            label: Text(userProgress.completed ? 'Completata' : 'Completa challenge'),
          ),
          const SizedBox(height: 24),
          Text(
            'Classifica',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          ...([...challenge.participants]
                ..sort((a, b) => b.progress.compareTo(a.progress)))
              .map(
            (participant) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text(participant.displayName[0])),
              title: Text(participant.displayName),
              subtitle: LinearProgressIndicator(value: participant.progress),
              trailing: Text(percent(participant.progress)),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segnala contenuto'),
        content: const Text(
          'La segnalazione viene inviata alla moderazione admin. Nel mock locale viene solo confermata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Segnalazione inviata.')),
              );
            },
            child: const Text('Invia'),
          ),
        ],
      ),
    );
  }
}
