// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListingTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final TextInputType keyboardType;

  const ListingTextField({
    super.key,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
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
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
        validator: (value) => value!.isEmpty ? "field_required".tr() : null,
      ),
    );
  }
}
