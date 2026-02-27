// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController? controller;
  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 3,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: null,

        expands: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "describe_product_hint".tr(),
        ),
      ),
    );
  }
}
