import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(child: AdminApp()));
}

final _router = GoRouter(
  initialLocation: '/stats',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/stats', builder: (context, state) => const StatsPage()),
        GoRoute(path: '/users', builder: (context, state) => const UsersPage()),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: '/challenges',
          builder: (context, state) => const ChallengesPage(),
        ),
        GoRoute(
          path: '/education',
          builder: (context, state) => const EducationPage(),
        ),
        GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
        GoRoute(path: '/', redirect: (context, state) => '/stats'),
      ],
    ),
  ],
);

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C4DFF),
      secondary: const Color(0xFFC8F560),
    );
    return MaterialApp.router(
      title: 'BudgetBuddy Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      routerConfig: _router,
    );
  }
}

class AdminShell extends StatelessWidget {
  const AdminShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final selected = _adminRoutes.indexWhere((route) => path.startsWith(route.path));
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selected < 0 ? 0 : selected,
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Icon(Icons.admin_panel_settings, size: 32),
            ),
            destinations: _adminRoutes
                .map(
                  (route) => NavigationRailDestination(
                    icon: Icon(route.icon),
                    label: Text(route.label),
                  ),
                )
                .toList(),
            onDestinationSelected: (index) => context.go(_adminRoutes[index].path),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('BudgetBuddy Admin'),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: Text('Demo admin role')),
                    ),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _adminRoutes = [
  _AdminRoute('/stats', 'Stats', Icons.query_stats),
  _AdminRoute('/users', 'Utenti', Icons.people_outline),
  _AdminRoute('/categories', 'Categorie', Icons.category_outlined),
  _AdminRoute('/challenges', 'Challenge', Icons.emoji_events_outlined),
  _AdminRoute('/education', 'Contenuti', Icons.school_outlined),
  _AdminRoute('/reports', 'Report', Icons.flag_outlined),
];

class _AdminRoute {
  const _AdminRoute(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}

final adminDataProvider = Provider((ref) => AdminDemoData());

class AdminDemoData {
  final users = const [
    AdminUser('Sofia', 'sofia.demo@example.com', 'active', 7, 12),
    AdminUser('Marco', 'marco.demo@example.com', 'active', 5, 4),
    AdminUser('Giulia', 'giulia.demo@example.com', 'active', 8, 16),
  ];

  final categories = const [
    AdminCategory('Food', true, 68),
    AdminCategory('Delivery', true, 24),
    AdminCategory('Transport', true, 31),
    AdminCategory('Fun', true, 44),
    AdminCategory('Study', true, 12),
    AdminCategory('Home', true, 19),
  ];

  final reports = const [
    AdminReport('Commento challenge', 'Commento poco costruttivo', 'open'),
    AdminReport('Profilo utente', 'Avatar da verificare', 'reviewing'),
    AdminReport('Challenge custom', 'Testo ambiguo', 'closed'),
  ];

  final challenges = const [
    AdminChallenge('No delivery week', 'public', 312, true),
    AdminChallenge('Weekend sotto 30 euro', 'group', 180, true),
    AdminChallenge('7 giorni senza impulsi', 'public', 220, true),
    AdminChallenge('Risparmia 5 euro al giorno', 'public', 144, true),
    AdminChallenge('Study week smart', 'group', 71, false),
  ];
}

class AdminUser {
  const AdminUser(this.name, this.email, this.status, this.level, this.streak);

  final String name;
  final String email;
  final String status;
  final int level;
  final int streak;
}

class AdminCategory {
  const AdminCategory(this.name, this.active, this.usage);

  final String name;
  final bool active;
  final int usage;
}

class AdminReport {
  const AdminReport(this.target, this.reason, this.status);

  final String target;
  final String reason;
  final String status;
}

class AdminChallenge {
  const AdminChallenge(this.title, this.visibility, this.participants, this.active);

  final String title;
  final String visibility;
  final int participants;
  final bool active;
}

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(adminDataProvider);
    return _AdminPage(
      title: 'Statistiche aggregate anonimizzate',
      children: [
        _DisclaimerPanel(),
        _StatGrid(
          stats: [
            ('Utenti attivi', '${data.users.length}', Icons.people_outline),
            ('Spese demo', '20', Icons.receipt_long_outlined),
            ('Obiettivi', '4', Icons.flag_outlined),
            ('Report aperti', '2', Icons.flag_outlined),
          ],
        ),
        const _BarPanel(
          title: 'Categorie piu usate',
          values: {'Food': 68, 'Delivery': 24, 'Transport': 31, 'Fun': 44},
        ),
      ],
    );
  }
}

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(adminDataProvider);
    return _AdminPage(
      title: 'Utenti',
      children: data.users
          .map(
            (user) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(user.name),
                subtitle: Text('${user.email} - livello ${user.level}'),
                trailing: Chip(label: Text(user.status)),
              ),
            ),
          )
          .toList(),
    );
  }
}

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(adminDataProvider);
    return _AdminPage(
      title: 'Categorie',
      children: data.categories
          .map(
            (category) => Card(
              child: SwitchListTile(
                value: category.active,
                onChanged: (_) {},
                title: Text(category.name),
                subtitle: Text('${category.usage} usi aggregati'),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ChallengesPage extends ConsumerWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(adminDataProvider);
    return _AdminPage(
      title: 'Challenge predefinite',
      actions: [
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nuova challenge'),
        ),
      ],
      children: data.challenges
          .map(
            (challenge) => Card(
              child: ListTile(
                leading: Icon(
                  challenge.active
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                ),
                title: Text(challenge.title),
                subtitle: Text(
                  '${challenge.visibility} - ${challenge.participants} partecipanti',
                ),
                trailing: const Icon(Icons.edit_outlined),
              ),
            ),
          )
          .toList(),
    );
  }
}

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdminPage(
      title: 'Contenuti educational',
      actions: [
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nuovo contenuto'),
        ),
      ],
      children: const [
        _ContentCard('Regola delle 24 ore', 'draft'),
        _ContentCard('Come leggere un budget manuale', 'published'),
        _ContentCard('Risparmiare per un viaggio', 'published'),
      ],
    );
  }
}

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(adminDataProvider);
    return _AdminPage(
      title: 'Moderazione report',
      children: data.reports
          .map(
            (report) => Card(
              child: ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(report.target),
                subtitle: Text(report.reason),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(report.status)),
                    IconButton(
                      tooltip: 'Chiudi report',
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AdminPage extends StatelessWidget {
  const _AdminPage({
    required this.title,
    required this.children,
    this.actions = const [],
  });

  final String title;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            ...actions,
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _DisclaimerPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            const Expanded(child: Text(mandatoryDisclaimer)),
          ],
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final List<(String, String, IconData)> stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: stats
          .map(
            (stat) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(stat.$3),
                    const Spacer(),
                    Text(stat.$1),
                    Text(
                      stat.$2,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BarPanel extends StatelessWidget {
  const _BarPanel({
    required this.title,
    required this.values,
  });

  final String title;
  final Map<String, int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.values.reduce((a, b) => a > b ? a : b).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...values.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Text(entry.key)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: entry.value / maxValue,
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${entry.value}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard(this.title, this.status);

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.article_outlined),
        title: Text(title),
        subtitle: Text(status),
        trailing: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
