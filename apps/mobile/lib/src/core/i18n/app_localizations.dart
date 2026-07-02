import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('it'), Locale('en')];

  static const _values = {
    'it': {
      'appName': 'BudgetBuddy Social',
      'login': 'Accedi',
      'email': 'Email',
      'password': 'Password',
      'continue': 'Continua',
      'home': 'Home',
      'expenses': 'Spese',
      'goals': 'Obiettivi',
      'challenges': 'Challenge',
      'profile': 'Profilo',
      'addExpense': 'Aggiungi spesa',
      'settings': 'Impostazioni',
      'deleteAccount': 'Elimina account',
      'monthlyBudget': 'Budget mensile',
      'availableBalance': 'Saldo disponibile',
      'monthExpenses': 'Spese mese',
      'mainGoal': 'Obiettivo principale',
      'dailyTip': 'Suggerimento del giorno',
      'insights': 'Insights',
      'simulator': 'Posso permettermelo?',
      'privacy': 'Privacy',
      'terms': 'Termini',
    },
    'en': {
      'appName': 'BudgetBuddy Social',
      'login': 'Log in',
      'email': 'Email',
      'password': 'Password',
      'continue': 'Continue',
      'home': 'Home',
      'expenses': 'Expenses',
      'goals': 'Goals',
      'challenges': 'Challenges',
      'profile': 'Profile',
      'addExpense': 'Add expense',
      'settings': 'Settings',
      'deleteAccount': 'Delete account',
      'monthlyBudget': 'Monthly budget',
      'availableBalance': 'Available balance',
      'monthExpenses': 'Monthly expenses',
      'mainGoal': 'Main goal',
      'dailyTip': 'Daily tip',
      'insights': 'Insights',
      'simulator': 'Can I afford it?',
      'privacy': 'Privacy',
      'terms': 'Terms',
    },
  };

  String t(String key) => _values[locale.languageCode]?[key] ?? _values['it']![key] ?? key;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsX on BuildContext {
  String t(String key) => AppLocalizations.of(this).t(key);
}
