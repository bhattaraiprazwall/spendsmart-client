import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _darkMode = false;
  bool _biometricLogin = true;
  String _currency = 'USD';
  // ── Colours & constants ──────────────────────────────────────────────
  static const _bg = Color(0xFFEEF0FB);
  static const _card = Colors.white;
  static const _primary = Color(0xFF3D5CFF);
  static const _sectionIcon = Color(0xFF3D5CFF);
  static const _labelColor = Color(0xFF1A1E2C);
  static const _subtitleColor = Color(0xFF9095A0);
  static const _divider = Color(0xFFF2F3F7);
  static const _chevronColor = Color(0xFFB0B5C3);
  static const _logoutText = Color(0xFFE53935);
  static const _logoutBg = Color(0xFFFFF0F0);
  static const _logoutBorder = Color(0xFFFFCDD2);
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      print("Token: $token");
      if (token != null) {
        ref.read(profileProvider.notifier).fetchProfile(token);
      }
    });
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

        //   return SingleChildScrollView(
        //     padding: const EdgeInsets.all(20),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const SizedBox(height: 20),
        //         Center(
        //           child: CircleAvatar(
        //             radius: 50,
        //             backgroundColor: AppColors.primary,
        //             child: Text(
        //               (profile["name"] as String? ?? "U")
        //                   .substring(0, 1)
        //                   .toUpperCase(),
        //               style: const TextStyle(fontSize: 40, color: Colors.white),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 20),
        //         Center(
        //           child: Text(
        //             profile["name"] ?? "User",
        //             style: AppTextStyles.headline,
        //           ),
        //         ),
        //         Center(
        //           child: Text(profile["email"] ?? "", style: AppTextStyles.body),
        //         ),
        //         const SizedBox(height: 30),
        //         _buildInfoTile("Currency", profile["currency"] ?? "USD"),
        //         _buildInfoTile("Language", profile["language"] ?? "en"),
        //         _buildInfoTile("Theme", profile["theme"] ?? "light"),
        //         _buildInfoTile(
        //           "Notifications",
        //           profile["notificationsEnabled"] == true
        //               ? "Enabled"
        //               : "Disabled",
        //         ),
        //         _buildInfoTile(
        //           "Budget Alert Threshold",
        //           "${profile["budgetAlertThreshold"] ?? 80}%",
        //         ),
        //       ],
        //     ),
        //   );

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                children: [
                  _buildProfileHeader(name: profile["data"]["name"] as String,subname: profile["data"]["email"]),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.person_outline_rounded,
                    title: 'Account',
                    children: [
                      _buildNavRow('Edit Profile'),
                      _buildDivider(),
                      _buildNavRow('Change Password'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    children: [
                      _buildDropdownRow(
                        label: 'Currency',
                        value: _currency,
                        items: const ['USD', 'EUR', 'GBP', 'JPY', 'NPR'],
                        onChanged: (v) => setState(() => _currency = v!),
                      ),
                      _buildDivider(),
                      _buildToggleRow(
                        label: 'Dark Mode',
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                      _buildDivider(),
                      _buildNavRow('Language', trailing: 'English'),
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
                  _buildLogoutButton(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildInfoTile(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label, style: AppTextStyles.body),
  //         Text(
  //           value,
  //           style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                color: _primary.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage('https://tse2.mm.bing.net/th/id/OIP.sBD5k_FV4Y2F7_V3RQj6EQHaHa?r=0&cb=thfvnextfalcon3&rs=1&pid=ImgDetMain&o=7&rm=3'),
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
            color: _labelColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subname,
          style: TextStyle(
            fontSize: 13,
            color: _subtitleColor,
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
        color: _card,
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
                Icon(icon, color: _sectionIcon, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _labelColor,
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
  Widget _buildNavRow(String label, {String? trailing}) {
    return InkWell(
      onTap: () {},
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
                  color: _labelColor,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: const TextStyle(fontSize: 14, color: _subtitleColor),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: _chevronColor,
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
                    color: _labelColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: _subtitleColor),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDDE0EF),
            thumbIcon: value
                ? WidgetStateProperty.all(
                    const Icon(Icons.check_rounded, color: _primary, size: 14),
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
                color: _labelColor,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: _primary,
                size: 22,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _primary,
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
      color: _divider,
      indent: 18,
      endIndent: 18,
    );
  }

  // ── Logout button ────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: _logoutBg,
          side: const BorderSide(color: _logoutBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, color: _logoutText, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _logoutText,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
