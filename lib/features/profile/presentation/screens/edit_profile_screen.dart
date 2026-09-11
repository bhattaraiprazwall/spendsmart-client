import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;
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
    _nameController.text = widget.profile.name;
    _avatarController.text = widget.profile.avatarUrl ?? "";
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(context.tr('profile_updated')),
      ),
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(profileProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        centerTitle: true,
        title: Text(context.tr('edit_profile'), style: AppTextStyles.body),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: context.tr('name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? context.tr('name_required') : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _avatarController,
                label: context.tr('avatar_url_optional'),
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
    );
  }
}
