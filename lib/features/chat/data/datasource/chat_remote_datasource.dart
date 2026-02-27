import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDataSource {
  final SupabaseClient client;

  ChatRemoteDataSource(this.client);

  /// Send message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    await client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': senderId,
      'text': text,
      // 'delivered_at': DateTime.now().toIso8601String(),
      'is_read': false,
    });
  }

  Future<void> deleteMessage({
    required String messageId,
  }) async {
    await client.from('messages').delete().eq('id', messageId);
  }

  Stream<Map<String, dynamic>> streamPresence(String userId) {
    return client
        .from('presence')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((event) => event.isNotEmpty ? event.first : {});
  }

  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
    required String userId,
  }) async {
    await client.from('typing_status').upsert({
      'conversation_id': conversationId,
      'user_id': userId,
      'is_typing': isTyping,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Stream<bool> streamTypingStatus(String conversationId) {
    return client
        .from('user_typing_status')
        .stream(primaryKey: ['conversation_id', 'user_id'])
        .eq('conversation_id', conversationId)
        .map((event) {
          if (event.isEmpty) return false;
          return event.first['is_typing'] == true;
        });
  }

  Stream<List<Map<String, dynamic>>> streamMessages(String conversationId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .map((event) => event);
  }

  Future<String> getOrCreateConversation(
    String currentUserId,
    String otherUserId,
  ) async {
    final existing = await client
        .from('conversations')
        .select()
        .or(
          'and(user1_id.eq.$currentUserId,user2_id.eq.$otherUserId),'
          'and(user1_id.eq.$otherUserId,user2_id.eq.$currentUserId)',
        )
        .maybeSingle();

    if (existing != null) {
      return existing['id'];
    }

    final inserted = await client
        .from('conversations')
        .insert({
          'user1_id': currentUserId,
          'user2_id': otherUserId,
          'last_message': '',
          'last_message_time': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return inserted['id'];
  }

  Stream<List<Map<String, dynamic>>> streamConversations(String myUserId) {
    return client
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('last_message_time', ascending: false)
        .map((rows) {
          return rows
              .where(
                (c) => c['user1_id'] == myUserId || c['user2_id'] == myUserId,
              )
              .toList();
        });
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final data = await client
        .from('users')
        .select('id, name, profile_image')
        .eq('id', userId)
        .single();

    return data;
  }

  Future<int> getUnreadCount({
    required String conversationId,
    required String myUserId,
  }) async {
    final data = await client
        .from('messages')
        .select('id')
        .eq('conversation_id', conversationId)
        .eq('is_read', false)
        .neq('sender_id', myUserId);

    return data.length;
  }

  Future<void> markAsRead(String conversationId, String myUserId) async {
    await client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', myUserId);
  }
}
