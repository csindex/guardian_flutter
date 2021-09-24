import '../../data/messenger/data-message.dart';
import '../../data/messenger/data-conversation.dart';
import '../../data/messenger/data-responder.dart';
import '../../utils/constants/utils.dart';

class ConversationViewModel {
  final ConversationData conversation;
  final ResponderData resp;
  final List<MessageData> messages;

  ConversationViewModel({this.conversation, this. resp, this.messages});

  String get conversationId {
    return this.conversation.conversationId;
  }

  List<MessageData> get msgList {
    return this.messages;
  }

  String get _lastMsgSenderId {
    return this.messages[messages.length - 1].senderId;
  }

  String get _lastMsgType {
    String msg = _lastMsg;
    String type = 'text';
    if (msg.endsWith('.mp4') || msg.endsWith('.mpeg4')) {
      type = 'video';
    } else if (msg.endsWith('.jpg') || msg.endsWith('.jpeg') || msg.endsWith('.png')) {
      type = 'photo';
    } else {
      type = 'text';
    }
    return type;
  }

  String get _lastMsg {
    return this.messages[messages.length - 1].msg;
  }

  String get senderName {
    return '${this.resp.rUser.name} ${this.resp.rUser.lname}';
  }

  String get _senderFName {
    return this.resp.rUser.name;
  }

  String get lastMsg {
    String m = '';
    if (_lastMsgSenderId == this.resp.rUser.userId) {
      if (_lastMsgType == 'video') {
        m = '$_senderFName sent a video.';
      } else if (_lastMsgType == 'photo') {
        m = '$_senderFName sent a photo.';
      } else {
        m = _lastMsg;
      }
    } else {
      if (_lastMsgType == 'video') {
        m = 'You sent a video.';
      } else if (_lastMsgType == 'photo') {
        m = 'You sent a photo.';
      } else {
        m = 'You: $_lastMsg';
      }
    }
    return m;
  }

  String get senderProfilePic {
    return '$secretHollowsEndPoint5/${resp.profile.profilePic}'; //sampleImages[Random().nextInt(120) % 6]
  }

  // String get date {
  //   return 'Posted on ${DateFormat('EEEE, MMMM d, y hh:mm a').format(DateTime.parse(this.post.date).add(Duration(hours: 8)))}';
  // }
}
