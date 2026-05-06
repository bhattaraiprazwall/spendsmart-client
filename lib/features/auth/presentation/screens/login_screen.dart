import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendsmart/core/theme/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //TOGGLE TO SHOW/HIDE PASSWORD
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
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
                _buildTextField(
                  controller: _emailController,
                  hint: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 14),
                _buildPasswordField(hint: 'Password'),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                ),

                const SizedBox(height: 20),
                _buildPrimaryButton(label: 'Login', onPressed: () {}),
                const SizedBox(height: 30),
                //DIVIDER

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text('OR CONTINUE WITH'),
                    ),
                    const Expanded(child:Divider())
                  ],
                )
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

  //GENERIC TEXT INPUT FIELDS
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
    );
  }

  //PASSWORD FIELD WITH SHOW/HIDE TOGGLE
  Widget _buildPasswordField({required String hint}) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
