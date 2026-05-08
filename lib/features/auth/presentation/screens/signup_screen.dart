import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/common/already_login_register.dart';
import 'package:spendsmart/core/widgets/common/checkbox.dart';
import 'package:spendsmart/core/widgets/common/custom_textfield.dart';
import 'package:spendsmart/core/widgets/common/primary_button.dart';

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
              style: AppTextStyles.body.copyWith(color: AppColors.primary,fontSize: 35,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

             Text('Join SpendSmart', style: AppTextStyles.headline.copyWith(fontSize: 25)),
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
            PrimaryButton(onPressed: () {}, label: 'Sign Up'),
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
