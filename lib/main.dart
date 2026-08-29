import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/app_router.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'SpendSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
