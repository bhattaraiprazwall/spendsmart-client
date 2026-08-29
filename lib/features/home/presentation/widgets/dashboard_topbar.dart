import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/features/profile/data/models/profile_model.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class DashboardTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: _buildAvatar(profile),
      leadingWidth: 58,
      title: _buildGreeting(profile),
      actions: [_buildBellIcon(context)],
    );
  }

  String _firstName(ProfileModel? profile) {
    final name = profile != null ? profile.name.trim() : '';
    if (name.isEmpty) return 'there';
    return name.split(' ').first;
  }

  String _initials(ProfileModel? profile) {
    final name = profile != null ? profile.name.trim() : '';
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  Widget _buildAvatar(ProfileModel? profile) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 1.5),
          color: AppColors.primary.withOpacity(0.1),
        ),
        child: Center(
          child: Text(
            _initials(profile),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(ProfileModel? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Hi, ${_firstName(profile)} 👋',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.neutral,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildDateBadge(),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          profile?.email ?? '',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.subtitleColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDateBadge() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    final label = '${months[now.month - 1]} ${now.year}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBellIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.notifications),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: AppColors.neutral,
            size: 20,
          ),
        ),
      ),
    );
  }
}
