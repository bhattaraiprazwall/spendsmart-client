import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendsmart/core/utils/currency_util.dart';

final currencyProvider = StateProvider<String>((ref) => 'USD');

final currencySymbolProvider = Provider<String>((ref) {
  return CurrencyUtil.symbolFor(ref.watch(currencyProvider));
});
