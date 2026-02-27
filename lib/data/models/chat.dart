import 'package:Balkano/data/models/user.dart';

class Chat {
  final User sender;
  String lastMessage;
  DateTime timestamp;
  String id;
  int unreadCount;
  bool hasUnreadMessages() => unreadCount > 0;
  Chat({
    required this.sender,
    required this.lastMessage,
    required this.id,
    required this.timestamp,
    this.unreadCount = 0,
  });
}
