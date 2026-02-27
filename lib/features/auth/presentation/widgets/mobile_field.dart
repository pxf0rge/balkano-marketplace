import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MobileField extends StatelessWidget {
  final TextEditingController controller;
  const MobileField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "mobile".tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "enter_mobile".tr(),
            suffixIcon: const Icon(Icons.phone_outlined),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineGray),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "mobile_invalid".tr();
            }
            if (value.length < 10) {
              return "mobile_invalid".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
