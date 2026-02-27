import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function()? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 3,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
