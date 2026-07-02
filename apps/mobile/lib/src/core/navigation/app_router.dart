import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/challenges/challenge_detail_screen.dart';
import '../../features/challenges/challenge_list_screen.dart';
import '../../features/expenses/add_expense_screen.dart';
import '../../features/expenses/expense_list_screen.dart';
import '../../features/goals/create_goal_screen.dart';
import '../../features/goals/goal_detail_screen.dart';
import '../../features/goals/goal_list_screen.dart';
import '../../features/groups/group_detail_screen.dart';
import '../../features/home/dashboard_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/delete_account_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/simulator/simulator_screen.dart';
import '../../state/app_state.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(budgetBuddyProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, routerState) {
      final location = routerState.uri.path;
      final isPublic = location == '/splash' || location == '/login';

      if (!appState.isSignedIn && !isPublic) {
        return '/login';
      }

      if (appState.isSignedIn &&
          !appState.isOnboarded &&
          location != '/onboarding' &&
          location != '/splash') {
        return '/onboarding';
      }

      if (appState.isSignedIn &&
          appState.isOnboarded &&
          (location == '/login' ||
              location == '/onboarding' ||
              location == '/splash')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpenseListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddExpenseScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalListScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateGoalScreen(),
          ),
          GoRoute(
            path: ':goalId',
            builder: (context, state) =>
                GoalDetailScreen(goalId: state.pathParameters['goalId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const ChallengeListScreen(),
        routes: [
          GoRoute(
            path: ':challengeId',
            builder: (context, state) => ChallengeDetailScreen(
              challengeId: state.pathParameters['challengeId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/groups/:groupId',
        builder: (context, state) =>
            GroupDetailScreen(groupId: state.pathParameters['groupId']!),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/simulator',
        builder: (context, state) => const SimulatorScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'delete-account',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
        ],
      ),
    ],
  );
});
