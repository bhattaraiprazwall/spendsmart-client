import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/localization/app_translations.dart';
import 'package:spendsmart/core/providers/locale_provider.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    final ref = ProviderScope.containerOf(this, listen: false);
    final locale = ref.read(localeProvider);
    final languageCode = locale.languageCode;
    
    return AppTranslations.translations[languageCode]?[key] ?? 
           AppTranslations.translations['en']?[key] ?? 
           key;
  }
}
