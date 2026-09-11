import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await ref
        .read(storageServiceProvider)
        .saveTheme(mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> loadTheme() async {
    final saved = await ref.read(storageServiceProvider).getTheme();
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'light') {
      state = ThemeMode.light;
    }
  }
}
