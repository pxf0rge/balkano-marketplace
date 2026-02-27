import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/providers/chat_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageInputField extends StatefulWidget {
  final String otherUserId;
  final String conversationId;
  final VoidCallback? onMessageSent;
  final Function(String newConversationId)? onConversationCreated;

  const MessageInputField({
    super.key,
    required this.otherUserId,
    required this.onMessageSent,
    required this.conversationId,
    required this.onConversationCreated,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final controller = TextEditingController();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "type_message".tr(),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: () async {
              if (_isSending) return;
              if (controller.text.trim().isEmpty) return;

              setState(() => _isSending = true);

              try {
                final newConversationId = await context
                    .read<ChatProvider>()
                    .sendMessageToUser(
                      conversationId: widget.conversationId,
                      otherUserId: widget.otherUserId,
                      text: controller.text,
                    );

                if (widget.conversationId.isEmpty) {
                  widget.onConversationCreated?.call(newConversationId);
                }

                controller.clear();

                // 🔔 notify ChatPage
                widget.onMessageSent?.call();
              } finally {
                if (mounted) {
                  setState(() => _isSending = false);
                }
              }
            },

            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
