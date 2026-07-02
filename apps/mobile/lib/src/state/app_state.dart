import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/demo_data.dart';

const _uuid = Uuid();

class BudgetBuddyState {
  const BudgetBuddyState({
    required this.isSignedIn,
    required this.accountDeleted,
    required this.user,
    required this.onboarding,
    required this.categories,
    required this.expenses,
    required this.goals,
    required this.challenges,
    required this.group,
    required this.badges,
    required this.userBadges,
  });

  final bool isSignedIn;
  final bool accountDeleted;
  final AppUser user;
  final OnboardingProfile onboarding;
  final List<ExpenseCategory> categories;
  final List<Expense> expenses;
  final List<SavingsGoal> goals;
  final List<Challenge> challenges;
  final BuddyGroup group;
  final List<Badge> badges;
  final List<UserBadge> userBadges;

  bool get isOnboarded => onboarding.completed;

  double get monthlyExpenses {
    final now = DateTime.now();
    return expenses
        .where((expense) =>
            expense.date.year == now.year && expense.date.month == now.month)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get availableBalance => onboarding.monthlyBudget - monthlyExpenses;

  SavingsGoal get primaryGoal => goals.first;

  ThemeMode get themeMode => switch (user.themeModeName) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  BudgetBuddyState copyWith({
    bool? isSignedIn,
    bool? accountDeleted,
    AppUser? user,
    OnboardingProfile? onboarding,
    List<ExpenseCategory>? categories,
    List<Expense>? expenses,
    List<SavingsGoal>? goals,
    List<Challenge>? challenges,
    BuddyGroup? group,
    List<Badge>? badges,
    List<UserBadge>? userBadges,
  }) {
    return BudgetBuddyState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      accountDeleted: accountDeleted ?? this.accountDeleted,
      user: user ?? this.user,
      onboarding: onboarding ?? this.onboarding,
      categories: categories ?? this.categories,
      expenses: expenses ?? this.expenses,
      goals: goals ?? this.goals,
      challenges: challenges ?? this.challenges,
      group: group ?? this.group,
      badges: badges ?? this.badges,
      userBadges: userBadges ?? this.userBadges,
    );
  }

  static BudgetBuddyState demo() {
    return BudgetBuddyState(
      isSignedIn: false,
      accountDeleted: false,
      user: DemoBudgetData.currentUser,
      onboarding: DemoBudgetData.onboarding,
      categories: DemoBudgetData.categories,
      expenses: DemoBudgetData.expenses,
      goals: DemoBudgetData.goals,
      challenges: DemoBudgetData.challenges,
      group: DemoBudgetData.group,
      badges: DemoBudgetData.badges,
      userBadges: DemoBudgetData.userBadges,
    );
  }
}

class BudgetBuddyController extends StateNotifier<BudgetBuddyState> {
  BudgetBuddyController() : super(BudgetBuddyState.demo());

  void signInMock() {
    state = state.copyWith(isSignedIn: true, accountDeleted: false);
  }

  void completeOnboarding(OnboardingProfile profile) {
    state = state.copyWith(onboarding: profile.copyWith(completed: true));
  }

  void addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    required String description,
    required PaymentMethod paymentMethod,
    required List<String> tags,
    required bool isRecurring,
  }) {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
      tags: tags,
      isRecurring: isRecurring,
    );
    state = state.copyWith(expenses: [expense, ...state.expenses]);
  }

  void createGoal({
    required String title,
    required String emoji,
    required double targetAmount,
    required DateTime deadline,
  }) {
    final goal = SavingsGoal(
      id: _uuid.v4(),
      title: title,
      emoji: emoji,
      targetAmount: targetAmount,
      currentAmount: 0,
      deadline: deadline,
      milestones: const [0.25, 0.5, 0.75, 1],
      transactions: const [],
    );
    state = state.copyWith(goals: [goal, ...state.goals]);
  }

  void moveToGoal(String goalId, double amount) {
    final goals = state.goals.map((goal) {
      if (goal.id != goalId) {
        return goal;
      }
      final transaction = GoalTransaction(
        id: _uuid.v4(),
        goalId: goalId,
        amount: amount,
        createdAt: DateTime.now(),
        note: 'Movimento virtuale',
      );
      return goal.copyWith(
        currentAmount:
            (goal.currentAmount + amount).clamp(0, goal.targetAmount).toDouble(),
        transactions: [transaction, ...goal.transactions],
      );
    }).toList();
    state = state.copyWith(goals: goals);
  }

  void completeChallenge(String challengeId) {
    final challenges = state.challenges.map((challenge) {
      if (challenge.id != challengeId) {
        return challenge;
      }
      final participants = challenge.participants.map((participant) {
        if (participant.userId != state.user.id) {
          return participant;
        }
        return ChallengeParticipant(
          userId: participant.userId,
          displayName: participant.displayName,
          progress: 1,
          completed: true,
        );
      }).toList();
      return Challenge(
        id: challenge.id,
        title: challenge.title,
        description: challenge.description,
        kind: challenge.kind,
        days: challenge.days,
        rewardXp: challenge.rewardXp,
        badgeId: challenge.badgeId,
        isGroupChallenge: challenge.isGroupChallenge,
        participants: participants,
      );
    }).toList();

    final challenge = state.challenges.firstWhere((item) => item.id == challengeId);
    final hasBadge =
        state.userBadges.any((badge) => badge.badgeId == challenge.badgeId);

    state = state.copyWith(
      challenges: challenges,
      user: state.user.copyWith(
        xp: state.user.xp + challenge.rewardXp,
        level: state.user.level + (challenge.rewardXp >= 180 ? 1 : 0),
      ),
      userBadges: hasBadge
          ? state.userBadges
          : [
              UserBadge(
                badgeId: challenge.badgeId,
                awardedAt: DateTime.now(),
              ),
              ...state.userBadges,
            ],
    );
  }

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(
      user: state.user.copyWith(notificationsEnabled: value),
    );
  }

  void setLocale(String localeCode) {
    state = state.copyWith(user: state.user.copyWith(localeCode: localeCode));
  }

  void setThemeMode(String themeModeName) {
    state =
        state.copyWith(user: state.user.copyWith(themeModeName: themeModeName));
  }

  void setPrivacyPercentagesOnly(bool value) {
    state = state.copyWith(
      user: state.user.copyWith(showOnlyPercentages: value),
    );
  }

  void deleteAccountMock() {
    state = BudgetBuddyState.demo().copyWith(accountDeleted: true);
  }
}

final budgetBuddyProvider =
    StateNotifierProvider<BudgetBuddyController, BudgetBuddyState>(
  (ref) => BudgetBuddyController(),
);
