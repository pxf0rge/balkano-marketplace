import 'package:Balkano/core/cache/app_cache_manager.dart';
import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/providers/chat_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatelessWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatAppBar({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      decoration: const BoxDecoration(color: AppColors.darkHeader),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),

          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            backgroundImage: otherUserAvatar != null
                ? AppCacheManager.instance.getImage(otherUserAvatar!)
                : null,
            child: otherUserAvatar == null
                ? Text(
                    otherUserName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),
              StreamBuilder<bool>(
                stream: context.read<ChatProvider>().typingStatusStream(
                  otherUserId,
                ),
                builder: (context, typingSnapshot) {
                  final isTyping = typingSnapshot.data == true;

                  if (isTyping) {
                    return Text(
                      "typing".tr(),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 12,
                      ),
                    );
                  }

                  // اگر تایپ نمی‌کند → presence نمایش بده
                  return StreamBuilder<Map<String, dynamic>>(
                    stream: context.read<ChatProvider>().presenceStream(
                      otherUserId,
                    ),
                    builder: (context, presenceSnapshot) {
                      if (!presenceSnapshot.hasData) {
                        return const SizedBox();
                      }

                      (presenceSnapshot.data);

                      final presence = presenceSnapshot.data!;
                      final isOnline = presence['is_online'] == true;
                      final lastSeen = presence['last_seen'];

                      return Text(
                        isOnline
                            ? "online".tr()
                            : lastSeen != null
                            ? "Last seen: ${DateTime.parse(lastSeen).toLocal().toString().substring(11, 16)}"
                            : "offline".tr(),
                        style: TextStyle(
                          color: isOnline ? Colors.greenAccent : Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
