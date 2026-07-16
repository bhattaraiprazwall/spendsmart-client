import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/utils/validators.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
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
        SnackBar(content: const Text("This password is already used..")),
      );
      return;
    }
    setState(() {
      _saving = true;
    });
    try {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;

      await ref
          .read(authRepositoryProvider)
          .changePassword(
            token,
            _currentPassController.text.trim(),
            _newPasswordController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Password changed successfully..")),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
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
        iconTheme: const IconThemeData(color: AppColors.neutral),
        centerTitle: true,
        title: const Text('Change Password', style: AppTextStyles.body),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'First let\'s verify its you ',
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _currentPassController,
                label: "Current Password",
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _newPasswordController,
                label: "New Password",
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
                label: "Confirm new Password",
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
                      : const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
