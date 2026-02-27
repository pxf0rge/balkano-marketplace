import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final String value;
  final IconData icon;
  final Function(String) onChanged;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.validator,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  "Edit $label",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                /// Input
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller,
                      validator: validator,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "enter_here".tr(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF7B61FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "cancel".tr(),
                          style: const TextStyle(
                            color: Color(0xFF7B61FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F2A37),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            onChanged(controller.text.trim());
                            Navigator.pop(context);
                          }
                        },

                        child: Text(
                          "save".tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
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
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(value, style: const TextStyle(fontSize: 15)),
                  ),
                  InkWell(
                    onTap: () => _showEditDialog(context),
                    child: Icon(icon, size: 20, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
