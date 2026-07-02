import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({required this.groupId, super.key});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final group = state.group;

    return BBScaffold(
      title: group.name,
      showBottomNav: false,
      actions: [
        IconButton(
          tooltip: 'Invita',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Codice invito: ${group.inviteCode}')),
            );
          },
          icon: const Icon(Icons.ios_share_outlined),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Privacy gruppo'),
              subtitle: Text(
                state.user.showOnlyPercentages
                    ? 'Gli amici vedono solo percentuali e badge, non importi.'
                    : 'Stai condividendo piu dettagli. Puoi cambiare dalle impostazioni.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_2_outlined),
              title: const Text('Codice invito'),
              subtitle: Text(group.inviteCode),
              trailing: const Icon(Icons.copy),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Codice copiato nel mock.')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Membri',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          ...group.members.map(
            (member) => Card(
              child: ListTile(
                leading: Text(member.avatarEmoji, style: const TextStyle(fontSize: 28)),
                title: Text(member.displayName),
                subtitle: LinearProgressIndicator(value: member.progressPercentage),
                trailing: Text(percent(member.progressPercentage)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Commenti challenge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          ...group.comments.map(
            (comment) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text(comment.userName[0])),
              title: Text(comment.userName),
              subtitle: Text(comment.body),
              trailing: IconButton(
                tooltip: 'Segnala',
                onPressed: () => _showReport(context),
                icon: const Icon(Icons.flag_outlined),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showCommentMock(context),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Aggiungi commento'),
          ),
        ],
      ),
    );
  }

  void _showCommentMock(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Commento'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Scrivi un commento positivo'),
          maxLines: 3,
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
                const SnackBar(content: Text('Commento salvato nel mock.')),
              );
            },
            child: const Text('Invia'),
          ),
        ],
      ),
    );
  }

  void _showReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Segnalazione inviata alla moderazione.')),
    );
  }
}
