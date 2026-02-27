import 'package:Balkano/providers/chat_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_input_field.dart';
import '../widgets/sender_message_bubble.dart';
import '../widgets/receiver_message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String conversationId;
  const ChatPage({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    required this.conversationId,
    this.otherUserAvatar,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  late String _conversationId;

  @override
  void initState() {
    super.initState();

    context.read<ChatProvider>().markConversationAsRead(widget.conversationId);
    _conversationId = widget.conversationId;

    if (_conversationId.isNotEmpty) {
      context.read<ChatProvider>().markConversationAsRead(_conversationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ChatAppBar(
              otherUserId: widget.otherUserId,
              otherUserName: widget.otherUserName,
              otherUserAvatar: widget.otherUserAvatar,
            ),

            Expanded(
              child: StreamBuilder(
                stream: context.watch<ChatProvider>().messagesStream(
                  _conversationId,
                ),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data as List<Map<String, dynamic>>;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
                    }
                  });

                  final myId = Supabase.instance.client.auth.currentUser!.id;

                  // for (final msg in messages) {
                  //   if (msg['sender_id'] != myId &&
                  //       msg['delivered_at'] == null) {
                  //     Supabase.instance.client
                  //         .from('messages')
                  //         .update({
                  //           'delivered_at': DateTime.now().toIso8601String(),
                  //         })
                  //         .eq('id', msg['id']);
                  //   }
                  // }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['sender_id'] == myId;

                      if (isMe) {
                        String status = "sent".tr();

                        if (msg['is_read'] == true) {
                          status = "seen".tr();
                        }

                        return GestureDetector(
                          onLongPress: () async {
                            final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("delete_message".tr()),
                                    content:
                                        Text("delete_message_confirm".tr()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text("cancel".tr()),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text("delete".tr()),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;

                            if (confirmed) {
                              await context
                                  .read<ChatProvider>()
                                  .deleteMessage(msg['id']);
                            }
                          },
                          child: SenderMessageBubble(
                            message: msg['text'],
                            time: msg['created_at']
                                .toString()
                                .substring(11, 16),
                            status: status,
                          ),
                        );
                      } else {
                        return ReceiverMessageBubble(
                          message: msg['text'],
                          time: msg['created_at'].toString().substring(11, 16),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            MessageInputField(
              otherUserId: widget.otherUserId,
              conversationId: _conversationId,
              onMessageSent: () {
                setState(() {});
              },
              onConversationCreated: (id) {
                setState(() {
                  _conversationId = id;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
