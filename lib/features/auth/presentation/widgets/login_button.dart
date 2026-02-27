import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const LoginButton({super.key, required this.onPressed, this.child});

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
              "login".tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
      ),
    );
  }
}
