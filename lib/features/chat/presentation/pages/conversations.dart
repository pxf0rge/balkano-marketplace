import 'package:Balkano/features/chat/presentation/pages/message_page.dart';
import 'package:Balkano/providers/chat_filter_provider.dart';
import 'package:Balkano/providers/chat_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/conversation_item.dart';
import '../widgets/messages_filter_tabs.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (value) {
                  context.read<ChatFilterProvider>().setQuery(value);
                },

                decoration: InputDecoration(
                  hintText: "search_hint".tr(),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Tabs
            MessagesFilterTabs(
              onChanged: (value) {
                context.read<ChatFilterProvider>().setFilter(value);
              },
            ),

            const SizedBox(height: 16),

            /// Single Conversation
            Expanded(
              child: StreamBuilder(
                stream: context.watch<ChatProvider>().conversationsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final rawConversations =
                      snapshot.data as List<Map<String, dynamic>>;
                  final myId = Supabase.instance.client.auth.currentUser!.id;

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: _attachUnreadCounts(rawConversations),
                    builder: (context, futureSnap) {
                      if (!futureSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final conversations = context
                          .watch<ChatFilterProvider>()
                          .applyOnMaps(futureSnap.data!);

                      if (conversations.isEmpty) {
                        return Center(child: Text("no_chats_yet".tr()));
                      }

                      return ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          final c = conversations[index];

                          final otherUserId = c['user1_id'] == myId
                              ? c['user2_id']
                              : c['user1_id'];

                          return FutureBuilder(
                            future: context.read<ChatProvider>().getProfile(
                              otherUserId,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text("no_chats_found".tr()),
                                );
                              }

                              final profile =
                                  snapshot.data as Map<String, dynamic>;

                              final unread = c['unread_count'] ?? 0;

                              return ConversationItem(
                                name: profile['name'] ?? 'User',
                                imageUrl: profile['profile_image'],
                                lastMessage: c['last_message'] ?? '',
                                time: c['last_message_time']
                                    .toString()
                                    .substring(11, 16),
                                unreadCount: unread,
                                onTap: () async {
                                  final convid = await context
                                      .read<ChatProvider>()
                                      .getOrCreateConversation(otherUserId);

                                  if (!context.mounted) return;

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatPage(
                                        otherUserId: otherUserId,
                                        conversationId: convid,
                                        otherUserName:
                                            profile['name'] ?? 'User',
                                        otherUserAvatar:
                                            profile['profile_image'],
                                      ),
                                    ),
                                  );

                                  setState(() {});
                                },
                              );

                              // return FutureBuilder<int>(
                              //   future: context
                              //       .read<ChatProvider>()
                              //       .getUnreadCount(c['id']),
                              //   builder: (context, unreadSnap) {
                              //     final unread = unreadSnap.data ?? 0;

                              //     return ConversationItem(
                              //       name: profile['name'] ?? 'User',
                              //       imageUrl: profile['profile_image'],
                              //       lastMessage: c['last_message'] ?? '',
                              //       time: c['last_message_time']
                              //           .toString()
                              //           .substring(11, 16),
                              //       unreadCount: unread,
                              //       onTap: () async {
                              //         final convid = await context
                              //             .read<ChatProvider>()
                              //             .getOrCreateConversation(otherUserId);

                              //         if (!context.mounted) return;

                              //         await Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (_) => ChatPage(
                              //               otherUserId: otherUserId,
                              //               conversationId: convid,
                              //               otherUserName:
                              //                   profile['name'] ?? 'User',
                              //               otherUserAvatar:
                              //                   profile['profile_image'],
                              //             ),
                              //           ),
                              //         );

                              //         setState(() {});
                              //       },
                              //     );
                              //   },
                              // );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 115),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _attachUnreadCounts(
    List<Map<String, dynamic>> conversations,
  ) async {
    final chatProvider = context.read<ChatProvider>();
    final List<Map<String, dynamic>> result = [];

    for (final c in conversations) {
      final unread = await chatProvider.getUnreadCount(c['id']);
      result.add({...c, 'unread_count': unread});
    }

    return result;
  }
}
