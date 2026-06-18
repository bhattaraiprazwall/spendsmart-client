import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/already_login_register.dart';
import 'package:spendsmart/core/widgets/checkbox.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _register() async {
    final name = _fullname.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final confirmPassword = _confirmpassword.text;

    if (name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _fullname.dispose();
    _email.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(10),
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

            CustomTextfield(controller: _fullname, hint: 'Full Name'),
            const SizedBox(height: 20),

            CustomTextfield(controller: _email, hint: 'Email Address'),
            const SizedBox(height: 20),

            CustomTextfield(
              controller: _password,
              hint: 'Password',
              isPassword: true,
            ),
            const SizedBox(height: 20),

            CustomTextfield(
              controller: _confirmpassword,
              hint: 'Confirm Password',
              isPassword: true,
            ),
            const SizedBox(height: 20),

            TermsCheckBox(),
            const SizedBox(height: 15),
            PrimaryButton(
              onPressed: _isLoading ? () {} : _register,
              label: _isLoading ? 'Please wait...' : 'Sign Up',
            ),
            const SizedBox(height: 30),
            AlreadyLoginRegister(
              text1: 'Already have an account? ',
              text2: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
