import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/providers/locale_provider.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/theme_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isUploadingAvatar = false;

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

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    if (ConnectivityService().isOffline) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange.shade800,
            content: Text(context.tr('offline_action_warning')),
          ),
        );
      }
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;

      setState(() => _isUploadingAvatar = true);

      await ref
          .read(profileProvider.notifier)
          .uploadAvatar(token, File(pickedFile.path));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(context.tr('avatar_updated')),
          ),
        );
      }
    } catch (e, stack) {
      debugPrint("AVATAR_UPLOAD_ERROR: $e");
      debugPrint("AVATAR_UPLOAD_STACK: $stack");
      if (mounted) {
        final isNetwork = e.toString().contains('SocketException') ||
            e.toString().contains('NetworkException') ||
            e.toString().contains('No internet connection') ||
            e.toString().contains('No route to host');
        final errText = isNetwork
            ? context.tr('no_internet')
            : e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              errText.contains('MissingPluginException')
                  ? 'Please fully restart the app to enable photo picker.'
                  : (isNetwork ? errText : '${context.tr('avatar_upload_failed')}: $errText'),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  void _showImagePickerBottomSheet() {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                context.tr('change_profile_picture'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  context.tr('take_photo'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  context.tr('choose_from_gallery'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logoutHandler() async {
    final c = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: c.card,
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('logout_title'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('logout_confirmation'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: c.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: c.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      context.tr('cancel'),
                      style: TextStyle(
                        color: c.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      context.tr('logout'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await ref.read(storageServiceProvider).clearAuth();
      ref.read(authStateProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    return profileState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Scaffold(
        backgroundColor: context.colors.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  (error.toString().contains('SocketException') ||
                          error.toString().contains('NetworkException') ||
                          error.toString().contains('No internet connection') ||
                          error.toString().contains('No route to host'))
                      ? context.tr('no_internet')
                      : error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final token = await ref
                        .read(storageServiceProvider)
                        .getToken();
                    if (token != null) {
                      ref.read(profileProvider.notifier).fetchProfile(token);
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.tr('retry')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text("No profile data"));
        }
        return Scaffold(
          backgroundColor: context.colors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                children: [
                  _buildProfileHeader(profile),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.person_outline_rounded,
                    title: context.tr('account'),
                    children: [
                      _buildNavRow(
                        context.tr('edit_profile'),
                        onTap: () {
                          context.push(RoutePaths.editProfile, extra: profile);
                        },
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        context.tr('change_password'),
                        onTap: () async {
                          context.push(RoutePaths.changePassword);
                        },
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        context.tr('manage_categories'),
                        onTap: () {
                          context.push(RoutePaths.categories);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.settings_outlined,
                    title: context.tr('preferences'),
                    children: [
                      _buildDropdownRow(
                        label: context.tr('currency'),
                        value: ref.watch(currencyProvider),
                        items: const ['USD', 'EUR', 'GBP', 'JPY', 'NPR'],
                        onChanged: (v) async {
                          if (v == null) return;
                          ref.read(currencyProvider.notifier).state = v;
                          await ref
                              .read(storageServiceProvider)
                              .saveCurrency(v);
                          final t = await ref
                              .read(storageServiceProvider)
                              .getToken();
                          if (t != null) {
                            await ref
                                .read(profileProvider.notifier)
                                .updateSettings(t, currency: v);
                            ref
                                .read(dashboardProvider.notifier)
                                .fetchSummary(t);
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildToggleRow(
                        label: context.tr('dark_mode'),
                        value: ref.watch(themeProvider) == ThemeMode.dark,
                        onChanged: (v) async {
                          final mode = v ? ThemeMode.dark : ThemeMode.light;
                          await ref.read(themeProvider.notifier).setTheme(mode);
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
                        label: context.tr('enable_notifications'),
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
                        context.tr('budget_alert_threshold'),
                        trailing: '${profile.budgetAlertThreshold}%',
                        onTap: () => _showThresholdPicker(profile.budgetAlertThreshold),
                      ),
                      _buildDivider(),
                      _buildNavRow(
                        context.tr('language'),
                        trailing: _languageDisplayName(
                          ref.watch(localeProvider).languageCode,
                        ),
                        onTap: () => _showLanguagePicker(
                          ref.watch(localeProvider).languageCode,
                        ),
                      ),
                      _buildDivider(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Guide',
                    children: [
                      _buildNavRow(
                        'App Tour & Onboarding',
                        onTap: () {
                          context.push(
                            RoutePaths.onboarding,
                            extra: true,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    onPressed: logoutHandler,
                    label: context.tr('logout'),
                    btnColor: context.colors.dangerBg,
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

  Widget _buildProfileHeader(Profile profile) {
    final c = context.colors;
    final avatarUrl = profile.avatarUrl?.trim();
    final hasValidAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _isUploadingAvatar ? null : _showImagePickerBottomSheet,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.card, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.profilePrimary.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasValidAvatar)
                        CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _buildInitialsFallback(profile.name),
                        )
                      else
                        _buildInitialsFallback(profile.name),
                      if (_isUploadingAvatar)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _isUploadingAvatar ? null : _showImagePickerBottomSheet,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.card, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          profile.name.isEmpty ? "User" : profile.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: TextStyle(
            fontSize: 13,
            color: c.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsFallback(String name) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3D5CFF), Color(0xFF2D5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Section card wrapper ─────────────────────────────────────────────
  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D5CFF).withValues(alpha: 0.06),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
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
    final c = context.colors;
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
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: c.textPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: TextStyle(fontSize: 14, color: c.textSecondary),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right_rounded, color: c.chevron, size: 20),
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
    final c = context.colors;
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
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.profilePrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: c.border,
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
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
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
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.divider,
      indent: 18,
      endIndent: 18,
    );
  }

  static const Map<String, String> _languages = {
    'en': 'English',
    'ne': 'नेपाली (Nepali)',
    'es': 'Español (Spanish)',
    'fr': 'Français (French)',
    'de': 'Deutsch (German)',
    'ja': '日本語 (Japanese)',
    'zh': '中文 (Chinese)',
  };

  String _languageDisplayName(String code) {
    return _languages[code] ?? code.toUpperCase();
  }

  void _showLanguagePicker(String current) {
    showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(
          context.tr("language"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.colors.card,
        children: _languages.entries.map((entry) {
          final code = entry.key;
          final name = entry.value;
          final isSelected = code == current;
          return SimpleDialogOption(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(localeProvider.notifier).setLocale(code);
              final t = await ref.read(storageServiceProvider).getToken();
              if (t != null) {
                ref
                    .read(profileProvider.notifier)
                    .updateSettings(t, language: code);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : context.colors.textPrimary,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showThresholdPicker(int current) {
    final thresholds = [50, 60, 70, 75, 80, 85, 90, 95];
    showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(
          context.tr("budget_alert_threshold"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.colors.card,
        children: thresholds.map((val) {
          final isSelected = val == current;
          return SimpleDialogOption(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final t = await ref.read(storageServiceProvider).getToken();
              if (t != null) {
                ref
                    .read(profileProvider.notifier)
                    .updateSettings(t, budgetAlertThreshold: val);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$val% of budget limit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : context.colors.textPrimary,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
