import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/utils/validators.dart';
import 'package:spendsmart/core/widgets/already_login_register.dart';
import 'package:spendsmart/core/widgets/checkbox.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/features/auth/presentation/providers/register_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // final success =
    await ref
        .read(registerProvider.notifier)
        .register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );

    // if (success) {
    //   context.go('/login');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Registration Successful',
    //         style: TextStyle(color: Colors.green),
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        print("PREVIOUS = $previous");
        print("NEXT = $next");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        context.go(RoutePaths.login);
      }
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });
    final authState = ref.watch(registerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SpendSmart',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Join SpendSmart',
                style: AppTextStyles.headline.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 10),

              const Text(
                'Create your account to start managaging your finances effortlessly.',
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _name,
                label: 'Full Name',
                validator: Validators.validateName,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _email,
                label: 'Email Address',
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _password,
                label: 'Password',
                isPassword: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _confirmpassword,
                label: 'Confirm Password',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != _password.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const TermsCheckBox(),
              const SizedBox(height: 15),
              PrimaryButton(
                onPressed: isLoading ? () {} : _register,
                label: isLoading ? 'Please wait...' : 'Sign Up',
              ),
              const SizedBox(height: 30),
               AlreadyLoginRegister(
                action:(){
                  context.go(RoutePaths.login);

                } ,
                text1: 'Already have an account? ',
                text2: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
