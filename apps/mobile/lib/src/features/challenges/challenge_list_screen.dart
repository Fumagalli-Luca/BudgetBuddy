import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class ChallengeListScreen extends ConsumerWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);

    return BBScaffold(
      title: 'Challenge',
      actions: [
        IconButton(
          tooltip: 'Gruppo amici',
          onPressed: () => context.push('/groups/${state.group.id}'),
          icon: const Icon(Icons.group_outlined),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          ...state.challenges.map(
            (challenge) {
              final currentUser = challenge.participants.firstWhere(
                (item) => item.userId == state.user.id,
              );
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => context.push('/challenges/${challenge.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              challenge.isGroupChallenge
                                  ? Icons.groups_2_outlined
                                  : Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                challenge.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text('${challenge.rewardXp} XP'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(challenge.description),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(value: currentUser.progress),
                        const SizedBox(height: 8),
                        Text(
                          '${percent(currentUser.progress)} - ${challenge.days} giorni',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
