import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/app_localizations.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../state/app_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'sofia.demo@example.com');
  final _passwordController = TextEditingController(text: 'BudgetBuddy123!');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.savings, color: Colors.white, size: 34),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'BudgetBuddy Social',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Una routine sociale e motivazionale per organizzare spese, obiettivi e challenge.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: context.t('email'),
                prefixIcon: const Icon(Icons.mail_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.t('password'),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                _signIn(context);
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(context.t('login')),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                final controller = ref.read(budgetBuddyProvider.notifier);
                controller.signInMock();
                controller.completeOnboarding(
                  ref.read(budgetBuddyProvider).onboarding.copyWith(
                        completed: true,
                      ),
                );
                context.go('/home');
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Entra con dati demo'),
            ),
            const SizedBox(height: 28),
            const DisclaimerBanner(),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      ref.read(budgetBuddyProvider.notifier).signInMock();
      if (context.mounted) {
        context.go('/onboarding');
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accesso non riuscito: $error')),
      );
    }
  }
}
