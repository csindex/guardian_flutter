import 'package:flutter/foundation.dart';
import 'dart:async';

import '../../services/web-service.dart';
import 'viewmodel-conversation.dart';
import '../../data/messenger/data-conversation.dart';

class ConversationsListViewModel extends ChangeNotifier {
  List<ConversationViewModel> conversations = <ConversationViewModel>[];
  // List<ConversationData> conversationsList = <ConversationData>[];

  Future<List<ConversationViewModel>> fetchConversations(String token, String userId) async {
    conversations.clear();
    final ws = Webservice();
    final conversationsList = await ws.fetchConversations(token, userId);
    for(var c in conversationsList) {
      ConversationViewModel cVM;
      for (String r in c.responders) {
        if (r != userId) {
          final resp = await ws.fetchResponderProfile(token, r);
          final msgList = await ws.fetchMessages(token, c.conversationId);
          if (msgList.isNotEmpty) {
            cVM = ConversationViewModel(
                conversation: c, resp: resp, messages: msgList);
            conversations.add(cVM);
          }
        }
      }
    }
    // this.conversationsList = results.map((item) => PostViewModel(post: item)).toList();
    notifyListeners();
    return conversations;
  }
}
