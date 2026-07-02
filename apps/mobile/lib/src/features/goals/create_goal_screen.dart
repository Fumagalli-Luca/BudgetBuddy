import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _emoji = '🎯';
  DateTime _deadline = DateTime.now().add(const Duration(days: 120));

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BBScaffold(
      title: 'Nuovo obiettivo',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Nome obiettivo',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Importo target',
              prefixIcon: Icon(Icons.euro),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _emoji,
            decoration: const InputDecoration(
              labelText: 'Icona',
              prefixIcon: Icon(Icons.emoji_objects_outlined),
            ),
            items: const ['🎯', '✈️', '🚗', '🏠', '🎤', '💻', '📚', '🛟']
                .map(
                  (emoji) => DropdownMenuItem(value: emoji, child: Text(emoji)),
                )
                .toList(),
            onChanged: (value) => setState(() {
              if (value != null) {
                _emoji = value;
              }
            }),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_available_outlined),
            title: Text('${_deadline.day}/${_deadline.month}/${_deadline.year}'),
            subtitle: const Text('Data target'),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _deadline,
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (picked != null) {
                setState(() => _deadline = picked);
              }
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Crea obiettivo'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (_titleController.text.trim().isEmpty ||
        amount == null ||
        !SharedValidators.isValidMoneyAmount(amount)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci nome e importo validi.')),
      );
      return;
    }

    ref.read(budgetBuddyProvider.notifier).createGoal(
          title: _titleController.text.trim(),
          emoji: _emoji,
          targetAmount: amount,
          deadline: _deadline,
        );
    context.pop();
  }
}
