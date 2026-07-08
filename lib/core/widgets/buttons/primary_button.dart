import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? btnColor;
  final Color? textColor;
  final Icon? leadingIcon;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.btnColor,
    this.textColor,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      child: leadingIcon != null
          ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: btnColor),
              onPressed: onPressed,
              icon: leadingIcon!,
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: btnColor),
              onPressed: onPressed,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
    );
  }
}
