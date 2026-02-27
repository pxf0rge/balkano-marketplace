import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FullNameField extends StatelessWidget {
  final TextEditingController controller;

  const FullNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "full_name".tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "enter_full_name".tr(),
            suffixIcon: const Icon(Icons.person_outline),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineGray),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "full_name_required".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
