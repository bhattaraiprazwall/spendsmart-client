import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/routing/route_paths.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text('404', style: AppTextStyles.headline),
              const SizedBox(height: 8),
              const Text('Page not found'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(RoutePaths.dashboard),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
