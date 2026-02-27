import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordField({super.key, required this.passwordController});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "password".tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: "enter_password".tr(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ],
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineGray),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Your password is incorrect!";
            }
            if (value.length < 6) {
              return "Your password is incorrect!";
            }
            return null;
          },
        ),
      ],
    );
  }
}
