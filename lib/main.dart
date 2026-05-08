import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
import 'package:spendsmart/features/home/presentation/screens/home_screen.dart';
import 'package:spendsmart/features/onboarding/presentation/screens/onboardingflow.dart';
import 'package:spendsmart/features/auth/presentation/screens/signup_screen.dart';

void main() {
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
      home: const HomeScreen(),
    );
  }
}