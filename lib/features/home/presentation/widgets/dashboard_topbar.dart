import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/features/notifications/presentation/providers/notification_provider.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class DashboardTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final c = context.colors;

    return AppBar(
      backgroundColor: c.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: _buildAvatar(profile, context),
        ),
      ),
      titleSpacing: 10,
      title: _buildGreeting(profile, context),
      actions: [
        _buildDateBadge(context),
        const SizedBox(width: 8),
        _buildBellIcon(context, ref),
        const SizedBox(width: 16),
      ],
    );
  }

  String _firstName(Profile? profile) {
    final name = profile != null ? profile.name.trim() : '';
    if (name.isEmpty) return 'there';
    return name.split(' ').first;
  }

  String _initials(Profile? profile) {
    final name = profile != null ? profile.name.trim() : '';
    if (name.isEmpty) return '?';
    final parts = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  Widget _buildAvatar(Profile? profile, BuildContext context) {
    final avatarUrl = profile?.avatarUrl?.trim();
    final hasValidAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        final shell = StatefulNavigationShell.maybeOf(context);
        if (shell != null) {
          shell.goBranch(3);
        } else {
          context.push(RoutePaths.profile);
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: hasValidAvatar
              ? CachedNetworkImage(
                  imageUrl: avatarUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: const Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildInitialsFallback(profile),
                )
              : _buildInitialsFallback(profile),
        ),
      ),
    );
  }

  Widget _buildInitialsFallback(Profile? profile) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF3D5CFF),
            Color(0xFF2D5BFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(profile),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGreeting(Profile? profile, BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr('welcome_back'),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: c.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          '${_firstName(profile)} 👋',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final c = context.colors;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    final label = '${months[now.month - 1]} ${now.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 13,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBellIcon(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final notificationsAsync = ref.watch(notificationProvider);
    final unreadCount =
        notificationsAsync.value?.where((n) => !n.isRead).length ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await context.push(RoutePaths.notifications);
          ref.read(notificationProvider.notifier).refresh();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.card,
            border: Border.all(color: c.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  Icons.notifications_outlined,
                  color: c.textPrimary,
                  size: 21,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: unreadCount > 9
                        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
                        : const EdgeInsets.all(3.5),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: unreadCount > 9
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius:
                          unreadCount > 9 ? BorderRadius.circular(10) : null,
                      border: Border.all(color: c.card, width: 1.5),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
