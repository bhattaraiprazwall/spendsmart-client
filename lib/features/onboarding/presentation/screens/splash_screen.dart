import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2300), _proceed);
  }

  Future<void> _proceed() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    _timer?.cancel();

    try {
      final storage = LocalStorageService();
      final token = await storage.getToken();
      final hasSeenIntro = await storage.hasSeenIntro();
      final hasCompletedOnboarding = await storage.hasCompletedOnboarding();

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        if (hasCompletedOnboarding) {
          context.go(RoutePaths.dashboard);
        } else {
          context.go(RoutePaths.onboarding);
        }
      } else {
        if (!hasSeenIntro) {
          context.go(RoutePaths.smartAlerts);
        } else {
          context.go(RoutePaths.login);
        }
      }
    } catch (_) {
      if (mounted) {
        context.go(RoutePaths.login);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0052FF),
      body: GestureDetector(
        onTap: () {
          _timer?.cancel();
          _proceed();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Center Logo and App Name
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 46,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'SpendSmart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
