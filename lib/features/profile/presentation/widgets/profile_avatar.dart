import 'dart:io';
import 'package:Balkano/data/models/user.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final User user;
  final File? imageFile;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.imageFile,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0E0E0),
              image: DecorationImage(
                image: imageFile != null
                    ? FileImage(imageFile!)
                    : user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : const AssetImage("assets/images/profile.png")
                          as ImageProvider,
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey[700]!, width: 2),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1F2A37),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
