import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricLogin = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      // print("Token: $token");
      if (token != null) {
        ref.read(profileProvider.notifier).fetchProfile(token);
      }
    });
  }

  Future<void> logoutHandler() async {
    print('Logged out');
    await ref.read(storageServiceProvider).deleteToken();
    ref.read(authStateProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    return profileState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("Error: ${error.toString()}"),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text("No profile data"));
        }
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                children: [
                  _buildProfileHeader(
                    name: profile.name,
                    subname: profile.email,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.person_outline_rounded,
                    title: 'Account',
                    children: [
                      _buildNavRow(
                        'Edit Profile',
                        onTap: () async {
                          context.push('edit_profile', extra: profile);
                          final t = await ref
                              .read(storageServiceProvider)
                              .getToken();
                          if (t != null) {
                            ref.read(profileProvider.notifier).fetchProfile(t);
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        'Change Password',
                        onTap: () async {
                          context.push('change_password');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    children: [
                      _buildDropdownRow(
                        label: 'Currency',
                        value: profile.currency,
                        items: const ['USD', 'EUR', 'GBP', 'JPY', 'NPR'],
                        onChanged: (v) async {
                          final t = await ref
                              .read(storageServiceProvider)
                              .getToken();
                          if (t != null) {
                            ref
                                .read(profileProvider.notifier)
                                .updateSettings(t, currency: v);
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildToggleRow(
                        label: 'Dark Mode',
                        value: profile.theme == "dark",
                        onChanged: (v) async {
                          final t = await ref
                              .read(storageServiceProvider)
                              .getToken();
                          if (t != null) {
                            ref
                                .read(profileProvider.notifier)
                                .updateSettings(t, theme: v ? "dark" : "light");
                          }
                        },
                      ),
                      _buildDivider(),

                      _buildToggleRow(
                        label: 'Enable app notifications',
                        value: profile.notificationsEnabled == true,
                        onChanged: (v) async {
                          final t = await ref
                              .read(storageServiceProvider)
                              .getToken();
                          if (t != null) {
                            ref
                                .read(profileProvider.notifier)
                                .updateSettings(t, notificationsEnabled: v);
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        'Language',
                        trailing: (profile.language as String? ?? "en")
                            .toUpperCase(),
                        onTap: () => _showLanguagePicker(
                          profile.language as String? ?? "en",
                        ),
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        'Budget Alert Threshold',
                        trailing:
                            "${profile.budgetAlertThreshold as int? ?? 80}%",
                        onTap: () => _showThresholdPicker(
                          profile.budgetAlertThreshold as int? ?? 80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.shield_outlined,
                    title: 'Security',
                    children: [
                      _buildToggleRow(
                        label: 'Biometric Login',
                        subtitle: 'Use Touch ID or Face ID to unlock',
                        value: _biometricLogin,
                        onChanged: (v) => setState(() => _biometricLogin = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.help_outline_rounded,
                    title: 'Support',
                    children: [
                      _buildNavRow('Help Center'),
                      _buildDivider(),
                      _buildNavRow('Terms of Service'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    onPressed: logoutHandler,
                    label: "Logout",
                    btnColor: AppColors.logoutBg,
                    textColor: AppColors.logoutText,
                    leadingIcon: Icon(
                      Icons.logout_rounded,
                      color: AppColors.logoutText,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader({required String name, required String subname}) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.profilePrimary.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage(
                'https://tse2.mm.bing.net/th/id/OIP.sBD5k_FV4Y2F7_V3RQj6EQHaHa?r=0&cb=thfvnextfalcon3&rs=1&pid=ImgDetMain&o=7&rm=3',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          (name as String? ?? "U"),
          // .substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.labelColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subname,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.subtitleColor,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ── Section card wrapper ─────────────────────────────────────────────
  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D5CFF).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.sectionIcon, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.labelColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ── Row types ────────────────────────────────────────────────────────
  Widget _buildNavRow(String label, {String? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelColor,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.subtitleColor,
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.chevronColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.profilePrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDDE0EF),
            thumbIcon: value
                ? WidgetStateProperty.all(
                    const Icon(
                      Icons.check_rounded,
                      color: AppColors.profilePrimary,
                      size: 14,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.labelColor,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColors.profilePrimary,
                size: 22,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.profilePrimary,
              ),
              items: items
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 18,
      endIndent: 18,
    );
  }

  void _showLanguagePicker(String current) {
    showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Select Language"),
        children: ["en", "es", "fr", "de", "ja", "zh"]
            .map(
              (l) => SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final t = await ref.read(storageServiceProvider).getToken();
                  if (t != null) {
                    ref
                        .read(profileProvider.notifier)
                        .updateSettings(t, language: l);
                  }
                },
                child: Text(
                  l.toUpperCase(),
                  style: TextStyle(
                    fontWeight: l == current
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: l == current ? AppColors.profilePrimary : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showThresholdPicker(int current) {
    showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Budget Alert Threshold"),
        children: [50, 60, 70, 80, 90, 100]
            .map(
              (t) => SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final token = await ref
                      .read(storageServiceProvider)
                      .getToken();
                  if (token != null) {
                    ref
                        .read(profileProvider.notifier)
                        .updateSettings(token, budgetAlertThreshold: t);
                  }
                },
                child: Text(
                  "$t%",
                  style: TextStyle(
                    fontWeight: t == current
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: t == current ? AppColors.profilePrimary : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
