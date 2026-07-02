import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../core/widgets/bb_scaffold.dart';
import '../../data/demo_data.dart';
import '../../state/app_state.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetBuddyProvider);
    final expenses = _categoryFilter == null
        ? state.expenses
        : state.expenses
            .where((expense) => expense.categoryId == _categoryFilter)
            .toList();

    return BBScaffold(
      title: 'Spese',
      floatingActionButton: FloatingActionButton(
        tooltip: 'Aggiungi spesa',
        onPressed: () => context.push('/expenses/add'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          _ExpenseChart(
            expenses: state.expenses,
            categories: state.categories,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Tutte'),
                    selected: _categoryFilter == null,
                    onSelected: (_) => setState(() => _categoryFilter = null),
                  ),
                ),
                ...state.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: Text(category.emoji),
                      label: Text(category.name),
                      selected: _categoryFilter == category.id,
                      onSelected: (_) =>
                          setState(() => _categoryFilter = category.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...expenses.map(
            (expense) {
              final category = state.categories.firstWhere(
                (item) => item.id == expense.categoryId,
              );
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(category.colorHex).withOpacity(0.16),
                    child: Text(category.emoji),
                  ),
                  title: Text(expense.description),
                  subtitle: Text(
                    '${category.name} - ${expense.paymentMethod.labelIt} - ${expense.date.day}/${expense.date.month}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        euro(expense.amount),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      if (expense.isRecurring)
                        const Icon(Icons.repeat, size: 16),
                    ],
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

class _ExpenseChart extends StatelessWidget {
  const _ExpenseChart({
    required this.expenses,
    required this.categories,
  });

  final List<Expense> expenses;
  final List<ExpenseCategory> categories;

  @override
  Widget build(BuildContext context) {
    final totals = {
      for (final category in categories)
        category.id: expenses
            .where((expense) => expense.categoryId == category.id)
            .fold(0.0, (sum, expense) => sum + expense.amount),
    };
    final maxValue = max(1.0, totals.values.fold(0.0, max));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuzione mese',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            ...categories.map(
              (category) {
                final total = totals[category.id] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(width: 32, child: Text(category.emoji)),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: total / maxValue,
                            color: Color(category.colorHex),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 64,
                        child: Text(
                          euro(total),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
