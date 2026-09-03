import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    return const Locale('en');
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await ref.read(storageServiceProvider).saveLanguage(languageCode);
  }

  Future<void> loadLocale() async {
    final languageCode = await ref.read(storageServiceProvider).getLanguage();
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }
}
