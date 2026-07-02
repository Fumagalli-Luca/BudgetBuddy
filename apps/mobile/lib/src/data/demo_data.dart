import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.username,
    required this.avatarEmoji,
    required this.level,
    required this.xp,
    required this.streak,
    required this.goalsCompleted,
    required this.showOnlyPercentages,
    required this.notificationsEnabled,
    required this.localeCode,
    required this.themeModeName,
  });

  final String id;
  final String email;
  final String displayName;
  final String username;
  final String avatarEmoji;
  final int level;
  final int xp;
  final int streak;
  final int goalsCompleted;
  final bool showOnlyPercentages;
  final bool notificationsEnabled;
  final String localeCode;
  final String themeModeName;

  AppUser copyWith({
    String? displayName,
    String? avatarEmoji,
    int? level,
    int? xp,
    int? streak,
    int? goalsCompleted,
    bool? showOnlyPercentages,
    bool? notificationsEnabled,
    String? localeCode,
    String? themeModeName,
  }) {
    return AppUser(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      username: username,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      goalsCompleted: goalsCompleted ?? this.goalsCompleted,
      showOnlyPercentages: showOnlyPercentages ?? this.showOnlyPercentages,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      localeCode: localeCode ?? this.localeCode,
      themeModeName: themeModeName ?? this.themeModeName,
    );
  }
}

class OnboardingProfile {
  const OnboardingProfile({
    required this.mainGoalKind,
    required this.savingStyle,
    required this.monthlyBudget,
    required this.preferredCategoryIds,
    required this.completed,
  });

  final MainGoalKind mainGoalKind;
  final SavingStyle savingStyle;
  final double monthlyBudget;
  final List<String> preferredCategoryIds;
  final bool completed;

  OnboardingProfile copyWith({
    MainGoalKind? mainGoalKind,
    SavingStyle? savingStyle,
    double? monthlyBudget,
    List<String>? preferredCategoryIds,
    bool? completed,
  }) {
    return OnboardingProfile(
      mainGoalKind: mainGoalKind ?? this.mainGoalKind,
      savingStyle: savingStyle ?? this.savingStyle,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      preferredCategoryIds: preferredCategoryIds ?? this.preferredCategoryIds,
      completed: completed ?? this.completed,
    );
  }
}

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
    this.isDefault = true,
  });

  final String id;
  final String name;
  final String emoji;
  final int colorHex;
  final bool isDefault;
}

class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.paymentMethod,
    required this.tags,
    this.isRecurring = false,
  });

  final String id;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String description;
  final PaymentMethod paymentMethod;
  final List<String> tags;
  final bool isRecurring;
}

class GoalTransaction {
  const GoalTransaction({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.createdAt,
    required this.note,
  });

  final String id;
  final String goalId;
  final double amount;
  final DateTime createdAt;
  final String note;
}

class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.title,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.milestones,
    required this.transactions,
  });

  final String id;
  final String title;
  final String emoji;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final List<double> milestones;
  final List<GoalTransaction> transactions;

  double get progress =>
      targetAmount == 0
          ? 0
          : (currentAmount / targetAmount).clamp(0, 1).toDouble();

  double weeklyNeeded(DateTime now) {
    final remaining =
        (targetAmount - currentAmount).clamp(0, targetAmount).toDouble();
    final days = deadline.difference(now).inDays.clamp(1, 3650).toDouble();
    return remaining / (days / 7);
  }

  SavingsGoal copyWith({
    String? title,
    String? emoji,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    List<double>? milestones,
    List<GoalTransaction>? transactions,
  }) {
    return SavingsGoal(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      milestones: milestones ?? this.milestones,
      transactions: transactions ?? this.transactions,
    );
  }
}

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.days,
    required this.rewardXp,
    required this.badgeId,
    required this.isGroupChallenge,
    required this.participants,
  });

  final String id;
  final String title;
  final String description;
  final ChallengeKind kind;
  final int days;
  final int rewardXp;
  final String badgeId;
  final bool isGroupChallenge;
  final List<ChallengeParticipant> participants;
}

class ChallengeParticipant {
  const ChallengeParticipant({
    required this.userId,
    required this.displayName,
    required this.progress,
    required this.completed,
  });

  final String userId;
  final String displayName;
  final double progress;
  final bool completed;
}

class BuddyGroup {
  const BuddyGroup({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.members,
    required this.comments,
  });

  final String id;
  final String name;
  final String inviteCode;
  final List<GroupMember> members;
  final List<GroupComment> comments;
}

class GroupMember {
  const GroupMember({
    required this.userId,
    required this.displayName,
    required this.avatarEmoji,
    required this.progressPercentage,
  });

  final String userId;
  final String displayName;
  final String avatarEmoji;
  final double progressPercentage;
}

class GroupComment {
  const GroupComment({
    required this.id,
    required this.userName,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String userName;
  final String body;
  final DateTime createdAt;
}

class Badge {
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
  });

  final String id;
  final String name;
  final String description;
  final String emoji;
}

class UserBadge {
  const UserBadge({
    required this.badgeId,
    required this.awardedAt,
  });

  final String badgeId;
  final DateTime awardedAt;
}

class DemoBudgetData {
  static final now = DateTime.now();

  static final categories = <ExpenseCategory>[
    const ExpenseCategory(
      id: 'food',
      name: 'Food',
      emoji: '🍜',
      colorHex: 0xFF6C4DFF,
    ),
    const ExpenseCategory(
      id: 'delivery',
      name: 'Delivery',
      emoji: '🥡',
      colorHex: 0xFFC8F560,
    ),
    const ExpenseCategory(
      id: 'transport',
      name: 'Transport',
      emoji: '🚇',
      colorHex: 0xFF2BB3A3,
    ),
    const ExpenseCategory(
      id: 'fun',
      name: 'Fun',
      emoji: '🎧',
      colorHex: 0xFFFFB84D,
    ),
    const ExpenseCategory(
      id: 'study',
      name: 'Study',
      emoji: '📚',
      colorHex: 0xFFFF6B6B,
    ),
    const ExpenseCategory(
      id: 'home',
      name: 'Home',
      emoji: '🏠',
      colorHex: 0xFF9A78FF,
    ),
  ];

  static final currentUser = AppUser(
    id: 'user-sofia',
    email: 'sofia.demo@example.com',
    displayName: 'Sofia',
    username: 'sofia_saves',
    avatarEmoji: '🌙',
    level: 7,
    xp: 1840,
    streak: 12,
    goalsCompleted: 3,
    showOnlyPercentages: true,
    notificationsEnabled: false,
    localeCode: 'it',
    themeModeName: 'system',
  );

  static final onboarding = OnboardingProfile(
    mainGoalKind: MainGoalKind.travel,
    savingStyle: SavingStyle.balanced,
    monthlyBudget: 850,
    preferredCategoryIds: ['food', 'transport', 'fun', 'delivery'],
    completed: false,
  );

  static final expenses = <Expense>[
    _expense('e1', 12.5, 'food', 1, 'Pranzo universita', PaymentMethod.card, ['uni']),
    _expense('e2', 7.2, 'transport', 2, 'Metro', PaymentMethod.wallet, ['abbonamento']),
    _expense('e3', 22.0, 'delivery', 3, 'Delivery poke', PaymentMethod.card, ['delivery']),
    _expense('e4', 4.5, 'food', 4, 'Caffe e snack', PaymentMethod.cash, ['snack']),
    _expense('e5', 18.0, 'fun', 5, 'Cinema', PaymentMethod.card, ['weekend']),
    _expense('e6', 39.0, 'study', 6, 'Libro usato', PaymentMethod.card, ['studio']),
    _expense('e7', 9.9, 'fun', 7, 'Streaming', PaymentMethod.card, ['ricorrente'], true),
    _expense('e8', 16.4, 'delivery', 8, 'Pizza con amici', PaymentMethod.card, ['delivery']),
    _expense('e9', 32.0, 'home', 9, 'Spesa casa', PaymentMethod.card, ['casa']),
    _expense('e10', 6.0, 'transport', 10, 'Bus extra', PaymentMethod.wallet, ['trasporti']),
    _expense('e11', 14.0, 'food', 11, 'Aperitivo leggero', PaymentMethod.card, ['amici']),
    _expense('e12', 24.5, 'fun', 12, 'Concerto local', PaymentMethod.card, ['musica']),
    _expense('e13', 11.2, 'food', 13, 'Mensa', PaymentMethod.card, ['uni']),
    _expense('e14', 19.8, 'delivery', 14, 'Sushi delivery', PaymentMethod.card, ['delivery']),
    _expense('e15', 3.5, 'food', 15, 'Colazione', PaymentMethod.cash, ['bar']),
    _expense('e16', 27.0, 'home', 16, 'Detersivi', PaymentMethod.card, ['casa']),
    _expense('e17', 8.0, 'transport', 17, 'Monopattino', PaymentMethod.wallet, ['mobilita']),
    _expense('e18', 15.0, 'study', 18, 'Appunti stampati', PaymentMethod.cash, ['studio']),
    _expense('e19', 21.0, 'fun', 19, 'Regalo compleanno', PaymentMethod.card, ['regali']),
    _expense('e20', 5.5, 'food', 20, 'Gelato', PaymentMethod.cash, ['weekend']),
  ];

  static final goals = <SavingsGoal>[
    _goal('g1', 'Interrail estate', '🚆', 900, 540, 95),
    _goal('g2', 'MacBook usato', '💻', 1200, 220, 180),
    _goal('g3', 'Fondo emergenza', '🛟', 600, 310, 150),
    _goal('g4', 'Concerto a Berlino', '🎤', 260, 180, 45),
  ];

  static final badges = <Badge>[
    const Badge(id: 'starter', name: 'Primo passo', description: 'Prima spesa registrata', emoji: '✨'),
    const Badge(id: 'delivery_free', name: 'Delivery detox', description: 'Una settimana senza delivery', emoji: '🥗'),
    const Badge(id: 'weekend_guardian', name: 'Weekend smart', description: 'Weekend sotto budget', emoji: '🛡️'),
    const Badge(id: 'impulse_master', name: 'Anti impulso', description: '7 giorni senza acquisti impulsivi', emoji: '🧘'),
    const Badge(id: 'daily_saver', name: '5 euro hero', description: 'Risparmio giornaliero costante', emoji: '💚'),
    const Badge(id: 'goal_25', name: '25%', description: 'Primo quarto obiettivo', emoji: '🌱'),
    const Badge(id: 'goal_50', name: 'Meta vicina', description: 'Meta obiettivo raggiunta', emoji: '🏁'),
    const Badge(id: 'group_energy', name: 'Squadra', description: 'Challenge di gruppo completata', emoji: '🤝'),
  ];

  static final userBadges = <UserBadge>[
    UserBadge(badgeId: 'starter', awardedAt: now.subtract(const Duration(days: 40))),
    UserBadge(badgeId: 'goal_25', awardedAt: now.subtract(const Duration(days: 18))),
    UserBadge(badgeId: 'weekend_guardian', awardedAt: now.subtract(const Duration(days: 7))),
  ];

  static final challenges = <Challenge>[
    _challenge('c1', 'No delivery week', 'Cucina o organizza pasti per 7 giorni.', ChallengeKind.noDeliveryWeek, 7, 180, 'delivery_free', false, 0.45),
    _challenge('c2', 'Weekend sotto 30 euro', 'Divertiti senza superare 30 euro.', ChallengeKind.weekendUnder30, 2, 120, 'weekend_guardian', true, 0.7),
    _challenge('c3', '7 giorni senza acquisti impulsivi', 'Aspetta 24 ore prima di comprare.', ChallengeKind.noImpulse7Days, 7, 160, 'impulse_master', false, 0.25),
    _challenge('c4', 'Risparmia 5 euro al giorno', 'Sposta 5 euro virtuali verso un obiettivo.', ChallengeKind.save5PerDay, 10, 220, 'daily_saver', false, 0.6),
    _challenge('c5', 'Study week smart', 'Budget leggero per materiali e pause.', ChallengeKind.custom, 5, 90, 'starter', true, 0.35),
  ];

  static final group = BuddyGroup(
    id: 'group-1',
    name: 'Weekend Berlino',
    inviteCode: 'BERLINO30',
    members: const [
      GroupMember(
        userId: 'user-sofia',
        displayName: 'Sofia',
        avatarEmoji: '🌙',
        progressPercentage: 0.61,
      ),
      GroupMember(
        userId: 'user-marco',
        displayName: 'Marco',
        avatarEmoji: '⚡',
        progressPercentage: 0.44,
      ),
      GroupMember(
        userId: 'user-giulia',
        displayName: 'Giulia',
        avatarEmoji: '🌿',
        progressPercentage: 0.73,
      ),
    ],
    comments: [
      GroupComment(
        id: 'comment-1',
        userName: 'Giulia',
        body: 'Io propongo picnic invece di brunch domenica.',
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      GroupComment(
        id: 'comment-2',
        userName: 'Marco',
        body: 'Ci sto, cosi salvo budget per il concerto.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ],
  );

  static Expense _expense(
    String id,
    double amount,
    String categoryId,
    int daysAgo,
    String description,
    PaymentMethod paymentMethod,
    List<String> tags, [
    bool recurring = false,
  ]) {
    return Expense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      date: now.subtract(Duration(days: daysAgo)),
      description: description,
      paymentMethod: paymentMethod,
      tags: tags,
      isRecurring: recurring,
    );
  }

  static SavingsGoal _goal(
    String id,
    String title,
    String emoji,
    double target,
    double current,
    int days,
  ) {
    return SavingsGoal(
      id: id,
      title: title,
      emoji: emoji,
      targetAmount: target,
      currentAmount: current,
      deadline: now.add(Duration(days: days)),
      milestones: const [0.25, 0.5, 0.75, 1],
      transactions: [
        GoalTransaction(
          id: '$id-t1',
          goalId: id,
          amount: current * 0.45,
          createdAt: now.subtract(const Duration(days: 28)),
          note: 'Primo trasferimento virtuale',
        ),
        GoalTransaction(
          id: '$id-t2',
          goalId: id,
          amount: current * 0.55,
          createdAt: now.subtract(const Duration(days: 8)),
          note: 'Extra risparmio',
        ),
      ],
    );
  }

  static Challenge _challenge(
    String id,
    String title,
    String description,
    ChallengeKind kind,
    int days,
    int reward,
    String badgeId,
    bool isGroup,
    double progress,
  ) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      kind: kind,
      days: days,
      rewardXp: reward,
      badgeId: badgeId,
      isGroupChallenge: isGroup,
      participants: [
        ChallengeParticipant(
          userId: 'user-sofia',
          displayName: 'Sofia',
          progress: progress,
          completed: progress >= 1,
        ),
        ChallengeParticipant(
          userId: 'user-marco',
          displayName: 'Marco',
          progress: (progress - 0.12).clamp(0, 1).toDouble(),
          completed: false,
        ),
        ChallengeParticipant(
          userId: 'user-giulia',
          displayName: 'Giulia',
          progress: (progress + 0.18).clamp(0, 1).toDouble(),
          completed: progress + 0.18 >= 1,
        ),
      ],
    );
  }
}
