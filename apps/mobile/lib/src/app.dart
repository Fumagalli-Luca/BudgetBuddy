import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/i18n/app_localizations.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'state/app_state.dart';

class BudgetBuddyApp extends ConsumerWidget {
  const BudgetBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetBuddyProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'BudgetBuddy Social',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: state.themeMode,
      locale: Locale(state.user.localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
