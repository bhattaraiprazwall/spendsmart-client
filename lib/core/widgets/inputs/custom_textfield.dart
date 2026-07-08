import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? label;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.label,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscurePassword,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
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
              )
            : null,
      ),
    );
  }
}
