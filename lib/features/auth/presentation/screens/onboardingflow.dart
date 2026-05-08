import 'package:flutter/material.dart';
import 'package:spendsmart/features/onboarding/presentation/widgets/onboarding.dart';
import 'package:spendsmart/features/auth/presentation/screens/login_screen.dart';
// import 'package:spendsmart/core/widgets/oboarding/onboarding.dart';

// class OnboardingSetbudgets extends StatelessWidget {
//   const OnboardingSetbudgets({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Onboarding(image: 'assets/images/onboarding_budget.png',label: 'Set monthly budgets',description: 'Set realistic limits for different categories and stay on track.',),
//     );
//   }
// }

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboarding_budget.png',
      'label': 'Set monthly budgets',
      'description':
          'Set realistic limits for different categories and stay on track.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'label': 'Track expenses easily',
      'description': 'Take control of your spending with smart categorisation.',
    },
  ];

  void _goToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) {
       return const LoginScreen();
    }, ));
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Onboarding(
      image: page['image']!,
      label: page['label']!,
      description: page['description']!,
      currentPage: _currentPage,
      totalPages: _pages.length,
      onNext: () {
        if (_currentPage < _pages.length - 1) {
          setState(() => _currentPage++);
        } else {
          _goToLogin();
        }
      },
      onSkip: () {
        _goToLogin();
      },
    );
  }
}
