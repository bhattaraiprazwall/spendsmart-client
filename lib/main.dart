import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/providers/locale_provider.dart';
import 'package:spendsmart/core/providers/theme_provider.dart';
import 'package:spendsmart/core/routing/app_router.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/firebase_options.dart';
import 'package:spendsmart/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = NotificationService();
  await notificationService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadPreferencesOnStart();
  }

  Future<void> _loadPreferencesOnStart() async {
    final storage = LocalStorageService();
    final token = await storage.getToken();
    if (token != null) {
      ref.read(authStateProvider.notifier).state = true;
    }
    final currency = await storage.getCurrency();
    if (currency != null && currency.isNotEmpty) {
      ref.read(currencyProvider.notifier).state = currency;
    }
    await ref.read(localeProvider.notifier).loadLocale();
    await ref.read(themeProvider.notifier).loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      key: ValueKey(locale.languageCode),
      title: 'SpendSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ne'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('ja'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        _FallbackCupertinoLocalisationsDelegate(),
        _FallbackMaterialLocalizationsDelegate(),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en');
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },
    );
  }
}

class _FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_FallbackCupertinoLocalisationsDelegate old) => false;
}

class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}
