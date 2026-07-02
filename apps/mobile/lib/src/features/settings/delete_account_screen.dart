import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/auth_service.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _controller.text.trim().toUpperCase() == 'ELIMINA';

    return BBScaffold(
      title: 'Elimina account',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            Icons.warning_amber,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Cancellazione definitiva',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nell app reale questa azione richiama la Edge Function delete_user_account, rimuove dati personali e revoca l accesso.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Scrivi ELIMINA per confermare',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: canDelete
                ? () async {
                    await ref.read(authServiceProvider).deleteAccount();
                    ref.read(budgetBuddyProvider.notifier).deleteAccountMock();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  }
                : null,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Elimina account'),
          ),
        ],
      ),
    );
  }
}
