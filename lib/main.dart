import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/home_screen.dart';
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
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(authStateProvider, (previous, next) {
      if (next == false && previous == true) {
        _router.go('/');
      }
    });

    return MaterialApp.router(
      title: 'SpendSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
