import 'package:budgetbuddy_social/src/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders BudgetBuddy Social shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BudgetBuddyApp()));
    expect(find.text('BudgetBuddy Social'), findsOneWidget);
  });
}
