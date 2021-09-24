class ConversationData {

  List<String> responders;
  String conversationId;
  String createdAt;
  String updatedAt;

  ConversationData.fromJsonMap(Map<String, dynamic> map):
        responders = List<String>.from(map["responders"]),
        conversationId = map["_id"],
        createdAt = map["createdAt"],
        updatedAt = map["updatedAt"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responders'] = responders;
    data['_id'] = conversationId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

}