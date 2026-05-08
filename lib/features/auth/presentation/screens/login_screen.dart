import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/common/already_login_register.dart';
import 'package:spendsmart/core/widgets/common/custom_textfield.dart';
import 'package:spendsmart/core/widgets/common/primary_button.dart';
import 'package:spendsmart/core/widgets/common/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //TOGGLE TO SHOW/HIDE PASSWORD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Logo
                _buildLogo(),
                const SizedBox(height: 32),

                //HEADLINE
                const Text('Welcome Back', style: AppTextStyles.headline),
                const SizedBox(height: 6),
                const Text(
                  'Login to effortlessly manage your finances.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 32),

                //--EMAIL FIELD--//
                CustomTextfield(
                  controller: _emailController,
                  hint: 'Email Address',
                ),

                const SizedBox(height: 14),
                CustomTextfield(
                  hint: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',

                    // style: TextStyle(
                    //   color: AppColors.primary,
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                PrimaryButton(label: 'Login', onPressed: () {}),
                const SizedBox(height: 30),

                //DIVIDER
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text('OR CONTINUE WITH'),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                //GOOGLE BUTTON
                SocialButton(
                  text: 'Google',
                  icon: SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 15,
                    height: 15,
                  ),
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 10),
                SocialButton(
                  text: 'Apple',
                  icon: SvgPicture.asset(
                    'assets/icons/apple.svg',
                    width: 15,
                    height: 15,
                    color: Colors.white,
                  ),
                  backgroundColor: AppColors.neutral,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 30),
                //SIGNUP ROW
                AlreadyLoginRegister(text1: 'Don\'t have an account?',text2: 'Sign Up',),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //HELPER WIDGET BUILDERS
  //PRIVATE METHODS
  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'SpendSmart',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
