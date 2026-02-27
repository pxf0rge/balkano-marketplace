import 'package:Balkano/core/cache/app_cache_manager.dart';
import 'package:Balkano/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:Balkano/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider extends ChangeNotifier {
  late ChatRepositoryImpl repository;

  ChatProvider() {
    repository = ChatRepositoryImpl(
      ChatRemoteDataSource(Supabase.instance.client),
    );
  }

  Future<void> deleteMessage(String messageId) async {
    await repository.deleteMessage(messageId);
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String conversationId) {
    return repository.getMessages(conversationId);
  }

  Stream<List<Map<String, dynamic>>> conversationsStream() {
    final myId = Supabase.instance.client.auth.currentUser!.id;
    return repository.getConversations(myId);
  }

  Future<String> getOrCreateConversation(String otherUserId) {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    return repository.getOrCreateConversation(currentUserId, otherUserId);
  }

  Future<String> sendMessageToUser({
    required String otherUserId,
    required String text,
    required String conversationId,
  }) async {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

    String finalConversationId = conversationId;

    // 🧠 اگر هنوز کانورسیشن نداریم، بساز
    if (conversationId.isEmpty) {
      finalConversationId = await repository.getOrCreateConversation(
        currentUserId,
        otherUserId,
      );
    }

    // 📩 ذخیره پیام
    await repository.sendMessage(finalConversationId, currentUserId, text);

    // 🔄 آپدیت آخرین پیام
    await Supabase.instance.client
        .from('conversations')
        .update({
          'last_message': text,
          'last_message_time': DateTime.now().toIso8601String(),
        })
        .eq('id', finalConversationId);

    return finalConversationId;
  }

  Future<Map<String, dynamic>> getProfile(String userId) async {
    final cached = AppCacheManager.instance.getProfile(userId);
    if (cached != null) return cached;

    final profile = await repository.getUserProfile(userId);
    AppCacheManager.instance.cacheProfile(userId, profile);
    return profile;
  }

  Future<int> getUnreadCount(String conversationId) async {
    final myId = Supabase.instance.client.auth.currentUser!.id;

    return repository.getUnreadCount(
      conversationId: conversationId,
      myUserId: myId,
    );
  }

  Future<void> markConversationAsRead(String conversationId) async {
    final myId = Supabase.instance.client.auth.currentUser!.id;

    await repository.markAsRead(conversationId, myId);
  }

  Stream<Map<String, dynamic>> presenceStream(String userId) {
    return repository.getPresence(userId);
  }

  Stream<bool> typingStatusStream(String conversationId) {
    return repository.typingStream(conversationId);
  }
}
