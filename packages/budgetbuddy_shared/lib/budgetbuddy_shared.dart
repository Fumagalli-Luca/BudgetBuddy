library budgetbuddy_shared;

const appName = 'BudgetBuddy Social';

const mandatoryDisclaimer =
    'Le informazioni fornite sono a scopo educativo e organizzativo e non costituiscono consulenza finanziaria.';

enum SavingStyle {
  light,
  balanced,
  aggressive;

  String get labelIt => switch (this) {
        SavingStyle.light => 'Leggero',
        SavingStyle.balanced => 'Bilanciato',
        SavingStyle.aggressive => 'Aggressivo',
      };

  String get labelEn => switch (this) {
        SavingStyle.light => 'Light',
        SavingStyle.balanced => 'Balanced',
        SavingStyle.aggressive => 'Aggressive',
      };
}

enum MainGoalKind {
  travel,
  car,
  rent,
  emergency,
  concert,
  study,
  other;

  String get labelIt => switch (this) {
        MainGoalKind.travel => 'Viaggio',
        MainGoalKind.car => 'Auto',
        MainGoalKind.rent => 'Affitto',
        MainGoalKind.emergency => 'Emergenza',
        MainGoalKind.concert => 'Concerto',
        MainGoalKind.study => 'Studio',
        MainGoalKind.other => 'Altro',
      };

  String get labelEn => switch (this) {
        MainGoalKind.travel => 'Travel',
        MainGoalKind.car => 'Car',
        MainGoalKind.rent => 'Rent',
        MainGoalKind.emergency => 'Emergency',
        MainGoalKind.concert => 'Concert',
        MainGoalKind.study => 'Study',
        MainGoalKind.other => 'Other',
      };
}

enum ChallengeKind {
  noDeliveryWeek,
  weekendUnder30,
  noImpulse7Days,
  save5PerDay,
  custom;
}

enum PaymentMethod {
  cash,
  card,
  transfer,
  wallet,
  other;

  String get labelIt => switch (this) {
        PaymentMethod.cash => 'Contanti',
        PaymentMethod.card => 'Carta',
        PaymentMethod.transfer => 'Bonifico',
        PaymentMethod.wallet => 'Wallet',
        PaymentMethod.other => 'Altro',
      };
}

class SharedValidators {
  const SharedValidators._();

  static bool isValidMoneyAmount(num amount) => amount > 0 && amount < 1000000;

  static bool isValidUsername(String value) {
    final normalized = value.trim();
    return normalized.length >= 3 &&
        normalized.length <= 24 &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(normalized);
  }
}
