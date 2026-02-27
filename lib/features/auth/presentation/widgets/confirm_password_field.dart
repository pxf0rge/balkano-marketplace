import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController passwordController;

  const ConfirmPasswordField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "confirm_password".tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "confirm_your_password".tr(),
            suffixIcon: const Icon(Icons.lock_outline),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineGray),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "password_not_match".tr();
            }
            if (value != passwordController.text) {
              return "password_not_match".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
