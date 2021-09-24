class MessageData {

  String msgId;
  String senderId;
  String msg;
  String cId;
  String createdAt;
  String updatedAt;

  MessageData.fromJsonMap(Map<String, dynamic> map):
        msgId = map["_id"],
        senderId = map["sender"],
        msg = map["text"],
        cId = map["conversationId"],
        createdAt = map["createdAt"],
        updatedAt = map["updatedAt"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = msgId;
    data['sender'] = senderId;
    data['text'] = msg;
    data['conversationId'] = cId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

}