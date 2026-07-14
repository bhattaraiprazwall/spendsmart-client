import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:spendsmart/features/category/presentation/screens/add_category_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/home_screen.dart';
import 'package:spendsmart/features/profile/presentation/screens/change_password_screen.dart';
import 'package:spendsmart/features/profile/presentation/screens/edit_profile_screen.dart';
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
        GoRoute(
          path: '/edit_profile',
          builder: (context, state) =>
              EditProfileScreen(profile: state.extra as Map<String, dynamic>),
        ),
        GoRoute(
          path: '/change_password',
          builder: (_, _) => const ChangePasswordScreen(),
        ),
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
