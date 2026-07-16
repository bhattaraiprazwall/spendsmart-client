import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final profile = ref.read(profileProvider).asData?.value;
    //   _nameController.text = profile?["data"]["name"] ?? "";
    //   _avatarController.text = profile?["data"]["avatarUrl"] ?? "";
    // });
    _nameController.text = widget.profile["name"] ?? "";
    _avatarController.text = widget.profile["avatarUrl"] ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;

    await ref
        .read(profileProvider.notifier)
        .updateProfile(
          token,
          name: _nameController.text.trim(),
          avatarUrl: _avatarController.text.trim().isEmpty
              ? null
              : _avatarController.text.trim(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text('Profile Updated Successfully'),
      ),
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(profileProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral),
        centerTitle: true,
        title: const Text('Edit Profile', style: AppTextStyles.body),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: "Name",
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _avatarController,
                label: "Avatar URL (optional)",
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isSaving
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
