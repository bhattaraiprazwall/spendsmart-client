import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';
import 'package:spendsmart/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/home_screen.dart';
import 'package:spendsmart/features/onboarding/presentation/screens/onboardingflow.dart';
import 'package:spendsmart/features/onboarding/presentation/widgets/onboarding.dart';
// import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
// import 'package:spendsmart/features/expenses/presentation/screens/add_expense_screen.dart';
// import 'package:spendsmart/features/home/presentation/screens/home_screen.dart';
import 'package:spendsmart/firebase_options.dart';

// import 'package:spendsmart/features/onboarding/presentation/screens/onboardingflow.dart';
// import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SignupScreen(),
    );
  }
}
