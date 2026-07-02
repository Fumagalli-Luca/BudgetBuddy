import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../state/app_state.dart';

class SimulatorScreen extends ConsumerStatefulWidget {
  const SimulatorScreen({super.key});

  @override
  ConsumerState<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends ConsumerState<SimulatorScreen> {
  final _amountController = TextEditingController(text: '80');
  final _nameController = TextEditingController(text: 'Sneakers');
  String? _goalId;

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetBuddyProvider);
    _goalId ??= state.primaryGoal.id;
    final goal = state.goals.firstWhere((item) => item.id == _goalId);
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final weeklyNeeded = goal.weeklyNeeded(DateTime.now());
    final delayDays = weeklyNeeded == 0 ? 0 : (amount / weeklyNeeded * 7).ceil();
    final ratio = state.availableBalance == 0 ? 1 : amount / state.availableBalance;
    final result = _resultLabel(amount, ratio, delayDays);

    return BBScaffold(
      title: 'Posso permettermelo?',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DisclaimerBanner(),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Acquisto',
              prefixIcon: Icon(Icons.shopping_bag_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Importo',
              prefixIcon: Icon(Icons.euro),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _goalId,
            decoration: const InputDecoration(
              labelText: 'Obiettivo impattato',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            items: state.goals
                .map(
                  (goal) => DropdownMenuItem(
                    value: goal.id,
                    child: Text('${goal.emoji} ${goal.title}'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _goalId = value),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(result.body),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: SharedValidators.isValidMoneyAmount(amount)
                        ? (amount / goal.targetAmount).clamp(0, 1).toDouble()
                        : 0,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Impatto: ${euro(amount)} equivale a circa $delayDays giorni di ritardo teorico su ${goal.title}.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: amount > 0
                ? () => ref
                    .read(budgetBuddyProvider.notifier)
                    .moveToGoal(goal.id, amount.clamp(0, 999).toDouble() / 10)
                : null,
            icon: const Icon(Icons.savings_outlined),
            label: const Text('Sposta il 10% verso l obiettivo'),
          ),
        ],
      ),
    );
  }

  _SimulatorResult _resultLabel(double amount, double ratio, int delayDays) {
    if (!SharedValidators.isValidMoneyAmount(amount)) {
      return const _SimulatorResult(
        title: 'Inserisci un importo',
        body: 'Il simulatore mostrera un impatto organizzativo sul tuo obiettivo.',
      );
    }
    if (ratio < 0.12 && delayDays < 5) {
      return const _SimulatorResult(
        title: 'Compra ora, con consapevolezza',
        body: 'L impatto stimato e leggero rispetto al budget manuale e all obiettivo selezionato.',
      );
    }
    if (ratio < 0.28) {
      return const _SimulatorResult(
        title: 'Aspetta 24 ore',
        body: 'Potrebbe essere sostenibile, ma una pausa aiuta a distinguere desiderio e impulso.',
      );
    }
    return const _SimulatorResult(
      title: 'Valuta un alternativa',
      body: 'L acquisto sposta sensibilmente il ritmo del tuo obiettivo. Cerca una versione piu economica o rimandalo.',
    );
  }
}

class _SimulatorResult {
  const _SimulatorResult({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}
