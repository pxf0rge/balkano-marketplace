import 'package:Balkano/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;

  const AuthButton({super.key, this.text, this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onPressed,
        child:
            child ??
            Text(
              text ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
      ),
    );
  }
}
