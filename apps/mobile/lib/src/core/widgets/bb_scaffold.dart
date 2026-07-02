import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BBScaffold extends StatelessWidget {
  const BBScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions,
    this.floatingActionButton,
    this.showBottomNav = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: _selectedIndex(context),
              onDestinationSelected: (index) => context.go(_paths[index]),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Spese',
                ),
                NavigationDestination(
                  icon: Icon(Icons.flag_outlined),
                  selectedIcon: Icon(Icons.flag),
                  label: 'Obiettivi',
                ),
                NavigationDestination(
                  icon: Icon(Icons.emoji_events_outlined),
                  selectedIcon: Icon(Icons.emoji_events),
                  label: 'Challenge',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profilo',
                ),
              ],
            )
          : null,
    );
  }

  static const _paths = ['/home', '/expenses', '/goals', '/challenges', '/profile'];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/expenses')) {
      return 1;
    }
    if (location.startsWith('/goals')) {
      return 2;
    }
    if (location.startsWith('/challenges') || location.startsWith('/groups')) {
      return 3;
    }
    if (location.startsWith('/profile') || location.startsWith('/settings')) {
      return 4;
    }
    return 0;
  }
}
