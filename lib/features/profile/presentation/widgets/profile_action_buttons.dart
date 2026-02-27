import 'package:Balkano/data/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final User user;
  final Function()? onSave;
  final Function()? onDiscard;
  final bool isLoading;
  const ProfileActionButtons({
    super.key,
    required this.user,
    required this.onSave,
    required this.onDiscard,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF7B61FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onDiscard,
            child: Text(
              "discard".tr(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2A37),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: isLoading ? null : onSave,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    "save".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
