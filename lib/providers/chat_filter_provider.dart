import 'package:flutter/material.dart';
import '../data/enums/message_filter.dart';
import '../data/models/chat.dart';

class ChatFilterProvider extends ChangeNotifier {
  MessageFilter _filter = MessageFilter.all;
  String _query = "";

  MessageFilter get filter => _filter;
  String get query => _query;

  void setFilter(MessageFilter value) {
    _filter = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> applyOnMaps(List<Map<String, dynamic>> data) {
    var result = data;

    /// Search
    if (_query.isNotEmpty) {
      result = result.where((e) {
        final lastMessage = (e['last_message'] ?? '').toString().toLowerCase();
        return lastMessage.contains(_query.toLowerCase());
      }).toList();
    }

    /// Tabs
    if (_filter == MessageFilter.read) {
      result = result.where((e) => (e['unread_count'] ?? 0) == 0).toList();
    }

    if (_filter == MessageFilter.unread) {
      result = result.where((e) => (e['unread_count'] ?? 0) > 0).toList();
    }

    return result;
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  List<Chat> apply(List<Chat> chats) {
    return chats.where((chat) {
      final matchesSearch = chat.sender.name.toLowerCase().contains(
        _query.toLowerCase(),
      );

      final matchesFilter = switch (_filter) {
        MessageFilter.all => true,
        MessageFilter.read => chat.unreadCount == 0,
        MessageFilter.unread => chat.unreadCount > 0,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }
}
