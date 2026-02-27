import 'package:Balkano/core/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;

  const LocationField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "location".tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "enter_location".tr(),
            suffixIcon: const Icon(Icons.location_on_outlined),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineGray),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "location_required".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
