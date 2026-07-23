import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/presentation/screens/not_found_screen.dart';
import 'package:spendsmart/core/presentation/shell/home_shell.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:spendsmart/features/category/presentation/screens/add_category_screen.dart';
import 'package:spendsmart/features/category/presentation/screens/categories_list.dart';
import 'package:spendsmart/features/category/presentation/screens/edit_category_screen.dart';
import 'package:spendsmart/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/dashboard_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/insights_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/transactions_screen.dart';
import 'package:spendsmart/features/onboarding/presentation/screens/onboardingflow.dart';
import 'package:spendsmart/features/profile/presentation/screens/change_password_screen.dart';
import 'package:spendsmart/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:spendsmart/features/profile/presentation/screens/profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final goRouter = GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    errorBuilder: (_, _) => const NotFoundScreen(),
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider);
      final matched = state.matchedLocation;
      final isAuthRoute =
          matched == RoutePaths.login ||
          matched == RoutePaths.signup ||
          matched == RoutePaths.onboarding;

      if (!isLoggedIn && !isAuthRoute) return RoutePaths.login;
      if (isLoggedIn && isAuthRoute) return RoutePaths.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: RoutePaths.signup, builder: (_, _) => const SignupScreen()),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (_, _) => const OnboardingFlow(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                builder: (_, _) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.transactions,
                builder: (_, _) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.insights,
                builder: (_, _) => const InsightsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (_, state) =>
            EditProfileScreen(profile: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: RoutePaths.changePassword,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.categories,
        builder: (_, _) => const CategoriesScreen(),
      ),
      GoRoute(
        path: RoutePaths.addCategory,
        builder: (_, _) => const AddCategoryScreen(),
      ),
      GoRoute(
        path: '/categories/edit/:id',
        builder: (_, state) =>
            EditCategoryScreen(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.addExpense,
        builder: (_, _) => const AddExpenseScreen(),
      ),
    ],
  );

  ref.listen(authStateProvider, (_, _) => goRouter.refresh());
  return goRouter;
});
