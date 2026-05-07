import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/onboarding.dart';

class OnboardingSetbudgets extends StatelessWidget {
  const OnboardingSetbudgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(image: 'assets/images/onboarding_budget.png',label: 'Set monthly budgets',description: 'Set realistic limits for different categories and stay on track.',),
    );
  }
}