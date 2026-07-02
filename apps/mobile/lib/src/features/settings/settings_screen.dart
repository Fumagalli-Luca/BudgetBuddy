import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/notification_service.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../state/app_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final controller = ref.read(budgetBuddyProvider.notifier);

    return BBScaffold(
      title: 'Impostazioni',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DisclaimerBanner(),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: state.user.notificationsEnabled,
            title: const Text('Consenso notifiche'),
            subtitle: const Text('Promemoria challenge e riepilogo settimanale'),
            onChanged: (value) async {
              if (value) {
                final result = await ref
                    .read(notificationServiceProvider)
                    .requestPermission();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Permesso notifiche: ${result.name}')),
                  );
                }
              }
              controller.setNotificationsEnabled(value);
            },
          ),
          const Divider(),
          Text('Lingua', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'it', label: Text('Italiano')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {state.user.localeCode},
            onSelectionChanged: (value) => controller.setLocale(value.first),
          ),
          const SizedBox(height: 20),
          Text('Tema', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'system', icon: Icon(Icons.brightness_auto)),
              ButtonSegment(value: 'light', icon: Icon(Icons.light_mode)),
              ButtonSegment(value: 'dark', icon: Icon(Icons.dark_mode)),
            ],
            selected: {state.user.themeModeName},
            onSelectionChanged: (value) => controller.setThemeMode(value.first),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: state.user.showOnlyPercentages,
            title: const Text('Mostra solo percentuali nei gruppi'),
            subtitle: const Text('Nasconde importi e saldo agli amici'),
            onChanged: controller.setPrivacyPercentagesOnly,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_outlined),
            title: const Text('Privacy policy'),
            subtitle: const Text('Placeholder MVP'),
            onTap: () => _legalDialog(context, 'Privacy policy'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Termini di servizio'),
            subtitle: const Text('Placeholder MVP'),
            onTap: () => _legalDialog(context, 'Termini di servizio'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Segnala un contenuto'),
            subtitle: const Text('Invia alla moderazione admin'),
            onTap: () => _reportDialog(context),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.push('/settings/delete-account'),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Elimina account'),
          ),
        ],
      ),
    );
  }

  void _legalDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text(
          'Testo legale placeholder da sostituire prima della pubblicazione store.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  void _reportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segnala contenuto'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Descrivi il contenuto o comportamento da moderare',
          ),
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
                const SnackBar(content: Text('Report inviato.')),
              );
            },
            child: const Text('Invia'),
          ),
        ],
      ),
    );
  }
}
