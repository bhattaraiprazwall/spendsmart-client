import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/validators.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/services/sync_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text == _currentPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('password_already_used'))),
      );
      return;
    }

    final isOnline = ref.read(connectivityServiceProvider).isOnline;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr('no_internet_password'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });
    try {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;

      await ref.read(changePasswordUseCaseProvider)(
        idToken: token,
        currentPassword: _currentPassController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('password_changed'))),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final errStr = e.toString().toLowerCase();
        final isNetworkErr = errStr.contains('socket') ||
            errStr.contains('timeout') ||
            errStr.contains('failed host lookup') ||
            errStr.contains('connection');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.danger,
            content: Row(
              children: [
                Icon(
                  isNetworkErr ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isNetworkErr
                        ? context.tr('no_internet_password')
                        : e.toString().replaceFirst("Exception: ", ""),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        centerTitle: true,
        title: Text(context.tr('change_password'), style: AppTextStyles.body),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  context.tr('verify_identity'),
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _currentPassController,
                  label: context.tr('current_password'),
                  validator: Validators.validateLoginPassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _newPasswordController,
                  label: context.tr('new_password'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Please enter a new password";
                    }
                    if (v.trim().length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _confirmNewPasswordController,
                  label: context.tr('confirm_password'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Re-enter your new password";
                    }
                    if (v.trim() != _newPasswordController.text.trim()) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            context.tr('save'),
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
