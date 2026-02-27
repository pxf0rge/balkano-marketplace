import 'package:Balkano/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SenderMessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final String? status;

  const SenderMessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(width: 6),
              Text(
                status ?? '',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
