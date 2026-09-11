import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/localization/app_translations.dart';
import 'package:spendsmart/core/providers/locale_provider.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    String languageCode = 'en';
    try {
      final ref = ProviderScope.containerOf(this, listen: false);
      languageCode = ref.read(localeProvider).languageCode;
    } catch (_) {
      try {
        languageCode = Localizations.localeOf(this).languageCode;
      } catch (_) {}
    }

    return AppTranslations.translations[languageCode]?[key] ??
        AppTranslations.translations['en']?[key] ??
        key;
  }
}
