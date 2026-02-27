import 'package:Balkano/features/chat/data/datasource/chat_remote_datasource.dart';

class ChatRepositoryImpl {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  Stream<List<Map<String, dynamic>>> getMessages(String conversationId) {
    return remote.streamMessages(conversationId);
  }

  Future<void> deleteMessage(String messageId) {
    return remote.deleteMessage(messageId: messageId);
  }

  Future<String> getOrCreateConversation(
    String currentUserId,
    String otherUserId,
  ) {
    return remote.getOrCreateConversation(currentUserId, otherUserId);
  }

  Stream<List<Map<String, dynamic>>> getConversations(String myUserId) {
    return remote.streamConversations(myUserId);
  }

  Future<void> sendMessage(
    String conversationId,
    String senderId,
    String text,
  ) {
    return remote.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text,
    );
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) {
    return remote.getUserProfile(userId);
  }

  Future<int> getUnreadCount({
    required String conversationId,
    required String myUserId,
  }) {
    return remote.getUnreadCount(
      conversationId: conversationId,
      myUserId: myUserId,
    );
  }

  Stream<Map<String, dynamic>> getPresence(String userId) {
    return remote.streamPresence(userId);
  }

  Stream<bool> typingStream(String conversationId) {
    return remote.streamTypingStatus(conversationId);
  }

  Future<void> markAsRead(String conversationId, String myUserId) {
    return remote.markAsRead(conversationId, myUserId);
  }
}
