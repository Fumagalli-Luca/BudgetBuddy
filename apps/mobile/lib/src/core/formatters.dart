import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(
  locale: 'it_IT',
  symbol: '€',
  decimalDigits: 0,
);

String euro(num value) => _currency.format(value);

String percent(num value) => '${(value * 100).round()}%';
