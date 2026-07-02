import 'package:budgetbuddy_shared/budgetbuddy_shared.dart';
import 'package:test/test.dart';

void main() {
  test('mandatory disclaimer is available to every app', () {
    expect(mandatoryDisclaimer, contains('consulenza finanziaria'));
  });

  test('money validator rejects invalid values', () {
    expect(SharedValidators.isValidMoneyAmount(10), isTrue);
    expect(SharedValidators.isValidMoneyAmount(0), isFalse);
    expect(SharedValidators.isValidMoneyAmount(-4), isFalse);
  });
}
