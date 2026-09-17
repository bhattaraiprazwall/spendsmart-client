import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/services/sync_provider.dart';

class ConnectivityBanner extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  ConsumerState<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends ConsumerState<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  bool? _previousOnlineState;
  bool _isOnline = true;
  bool _userDismissed = false;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onConnectivityChanged(bool isOnline) {
    _autoHideTimer?.cancel();

    final prev = _previousOnlineState;
    _previousOnlineState = isOnline;
    _isOnline = isOnline;

    if (prev == null) {
      // First read after cold start
      if (!isOnline) {
        // Started offline
        _userDismissed = false;
        if (mounted) setState(() {});
        _animController.forward();
      } else {
        // Started online - stay hidden
        _animController.reverse();
      }
      return;
    }

    if (prev != isOnline) {
      _userDismissed = false;
      if (mounted) setState(() {});

      if (!isOnline) {
        // Just disconnected
        _animController.forward();
      } else {
        // Just reconnected
        _animController.forward();
        _autoHideTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            _animController.reverse();
          }
        });
      }
    }
  }

  void _dismissManually() {
    setState(() {
      _userDismissed = true;
    });
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to network connectivity stream
    ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      next.whenData((isOnline) {
        _onConnectivityChanged(isOnline);
      });
    });

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final isHidden = _animController.isDismissed || _userDismissed;
                  return IgnorePointer(
                    ignoring: isHidden,
                    child: isHidden
                        ? const SizedBox.shrink()
                        : SlideTransition(
                            position: _offsetAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: child,
                            ),
                          ),
                  );
                },
                child: _buildBannerCard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    final isOffline = !_isOnline;

    final bgColor1 =
        isOffline ? const Color(0xFFD97706) : const Color(0xFF059669);
    final bgColor2 =
        isOffline ? const Color(0xFFB45309) : const Color(0xFF047857);
    final borderColor = isOffline
        ? const Color(0xFFFDE68A).withValues(alpha: 0.4)
        : const Color(0xFFA7F3D0).withValues(alpha: 0.4);

    final icon =
        isOffline ? Icons.wifi_off_rounded : Icons.cloud_done_rounded;

    final title = isOffline
        ? context.tr('you_are_offline')
        : context.tr('back_online');

    final subtitle = isOffline
        ? context.tr('offline_desc')
        : context.tr('syncing_changes');

    return Material(
      color: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor1, bgColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isOffline) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _dismissManually,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
