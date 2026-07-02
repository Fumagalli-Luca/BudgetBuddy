import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/demo_data.dart';
import '../../state/app_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late MainGoalKind _goalKind;
  late SavingStyle _savingStyle;
  late double _monthlyBudget;
  late Set<String> _categories;

  @override
  void initState() {
    super.initState();
    final onboarding = ref.read(budgetBuddyProvider).onboarding;
    _goalKind = onboarding.mainGoalKind;
    _savingStyle = onboarding.savingStyle;
    _monthlyBudget = onboarding.monthlyBudget;
    _categories = onboarding.preferredCategoryIds.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetBuddyProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Setup iniziale')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Costruiamo il tuo ritmo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scegli un obiettivo reale, il livello di intensita e le categorie che vuoi osservare meglio.',
            ),
            const SizedBox(height: 24),
            Text('Obiettivo principale', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MainGoalKind.values.map((goal) {
                return ChoiceChip(
                  label: Text(goal.labelIt),
                  selected: _goalKind == goal,
                  onSelected: (_) => setState(() => _goalKind = goal),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Stile risparmio', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SegmentedButton<SavingStyle>(
              segments: SavingStyle.values
                  .map(
                    (style) => ButtonSegment(
                      value: style,
                      label: Text(style.labelIt),
                    ),
                  )
                  .toList(),
              selected: {_savingStyle},
              onSelectionChanged: (value) =>
                  setState(() => _savingStyle = value.first),
            ),
            const SizedBox(height: 24),
            Text('Budget mensile manuale', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.52),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${_monthlyBudget.round()} euro',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Slider(
                    value: _monthlyBudget,
                    min: 150,
                    max: 2500,
                    divisions: 47,
                    label: '${_monthlyBudget.round()}',
                    onChanged: (value) => setState(() => _monthlyBudget = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Categorie preferite', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.categories.map((category) {
                final selected = _categories.contains(category.id);
                return FilterChip(
                  avatar: Text(category.emoji),
                  label: Text(category.name),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _categories.add(category.id);
                      } else {
                        _categories.remove(category.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                ref.read(budgetBuddyProvider.notifier).completeOnboarding(
                      OnboardingProfile(
                        mainGoalKind: _goalKind,
                        savingStyle: _savingStyle,
                        monthlyBudget: _monthlyBudget,
                        preferredCategoryIds: _categories.toList(),
                        completed: true,
                      ),
                    );
                context.go('/home');
              },
              icon: const Icon(Icons.check),
              label: const Text('Inizia'),
            ),
          ],
        ),
      ),
    );
  }
}
