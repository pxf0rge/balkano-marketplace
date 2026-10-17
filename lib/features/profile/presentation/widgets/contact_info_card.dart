import 'package:Balkano/data/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ContactInfoCard extends StatelessWidget {
  final User user;
  ContactInfoCard({super.key, required this.user});

  final location = PhosphorIconsRegular.mapPin;
  final phone = PhosphorIconsRegular.phone;
  final email = PhosphorIconsRegular.envelope;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 3,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "contact_information".tr(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: location,
            label: "location".tr(),
            value: user.location,
          ),

          const SizedBox(height: 12),

          _InfoRow(icon: phone, label: "phone".tr(), value: user.phone),

          const SizedBox(height: 12),

          _InfoRow(icon: email, label: "Email", value: user.email),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade300,
          child: Icon(icon, size: 18, color: Colors.black),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
