import 'package:Balkano/data/models/user.dart';
import 'package:flutter/material.dart';

class SellerInfoCard extends StatelessWidget {
  final User user;
  const SellerInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey,
          child: user.profileImageUrl != null
              ? ClipOval(
                  child: Image.network(
                    user.profileImageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.person, size: 28, color: Colors.white),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(
              "Member since ${user.registerDate.substring(0, 4)}",
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 4),

            Text(
              "⭐ ${user.rating} (${user.reviewsCount} reviews)",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
