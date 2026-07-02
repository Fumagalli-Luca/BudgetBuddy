import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/bb_scaffold.dart';
import '../../state/app_state.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  DateTime _date = DateTime.now();
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _categoryId;
  bool _recurring = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetBuddyProvider);
    _categoryId ??= state.categories.first.id;

    return BBScaffold(
      title: 'Aggiungi spesa',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Importo',
              prefixIcon: Icon(Icons.euro),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _categoryId,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: state.categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category.id,
                    child: Text('${category.emoji} ${category.name}'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _categoryId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrizione',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PaymentMethod>(
            value: _paymentMethod,
            decoration: const InputDecoration(
              labelText: 'Pagamento',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
            items: PaymentMethod.values
                .map(
                  (method) => DropdownMenuItem(
                    value: method,
                    child: Text(method.labelIt),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() {
              if (value != null) {
                _paymentMethod = value;
              }
            }),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(
              '${_date.day}/${_date.month}/${_date.year}',
            ),
            subtitle: const Text('Data'),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(DateTime.now().year - 2),
                lastDate: DateTime(DateTime.now().year + 1),
              );
              if (picked != null) {
                setState(() => _date = picked);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tag separati da virgola',
              prefixIcon: Icon(Icons.sell_outlined),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _recurring,
            title: const Text('Spesa ricorrente'),
            subtitle: const Text('Promemoria mensile manuale nel profilo spese'),
            onChanged: (value) => setState(() => _recurring = value),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Salva spesa'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || !SharedValidators.isValidMoneyAmount(amount)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un importo valido.')),
      );
      return;
    }

    ref.read(budgetBuddyProvider.notifier).addExpense(
          amount: amount,
          categoryId: _categoryId!,
          date: _date,
          description: _descriptionController.text.trim().isEmpty
              ? 'Spesa manuale'
              : _descriptionController.text.trim(),
          paymentMethod: _paymentMethod,
          tags: _tagsController.text
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList(),
          isRecurring: _recurring,
        );
    context.pop();
  }
}
