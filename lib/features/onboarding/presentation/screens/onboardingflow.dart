import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/onboarding/presentation/widgets/onboarding.dart';

class OnboardingFlow extends StatefulWidget {
  final bool isRevisit;
  const OnboardingFlow({super.key, this.isRevisit = false});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentPage = 0;

  late final List<Map<String, String>> _pages = widget.isRevisit
      ? [
          {
            'image': 'assets/images/onboarding_alerts.jpg',
            'label': 'Smart spending alerts',
            'description':
                'Receive AI-powered alerts before you overspend and stay financially ahead.',
          },
          {
            'image': 'assets/images/onboarding_budget.png',
            'label': 'Set monthly budgets',
            'description':
                'Set realistic limits for different categories and stay on track.',
          },
          {
            'image': 'assets/images/onboarding2.png',
            'label': 'Track expenses easily',
            'description':
                'Take control of your spending with smart categorisation.',
          },
        ]
      : [
          {
            'image': 'assets/images/onboarding_budget.png',
            'label': 'Set monthly budgets',
            'description':
                'Set realistic limits for different categories and stay on track.',
          },
          {
            'image': 'assets/images/onboarding2.png',
            'label': 'Track expenses easily',
            'description':
                'Take control of your spending with smart categorisation.',
          },
        ];

  Future<void> _finishOnboarding() async {
    if (!widget.isRevisit) {
      await LocalStorageService().saveHasCompletedOnboarding(true);
    }
    if (!mounted) return;
    if (widget.isRevisit && context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLastPage = _currentPage == _pages.length - 1;

    String nextLabel;
    if (widget.isRevisit) {
      nextLabel = isLastPage ? 'Done' : 'Next';
    } else {
      nextLabel = isLastPage ? 'Next →' : 'Next';
    }

    return Onboarding(
      image: page['image']!,
      label: page['label']!,
      description: page['description']!,
      currentPage: _currentPage,
      totalPages: _pages.length,
      nextLabel: nextLabel,
      skipLabel: widget.isRevisit ? 'Close' : 'Skip',
      onNext: () {
        if (!isLastPage) {
          setState(() => _currentPage++);
        } else {
          _finishOnboarding();
        }
      },
      onSkip: () {
        _finishOnboarding();
      },
    );
  }
}
