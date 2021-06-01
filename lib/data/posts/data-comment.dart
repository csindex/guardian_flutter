import 'package:intl/intl.dart';

class CommentData {
  String commentId;
  String text;
  String authorName;
  String authorAvatar;
  String authorId;
  String date;

  CommentData.fromJsonMap(Map<String, dynamic> map)
      : commentId = map["_id"],
        text = map["text"],
        authorName = map["name"],
        authorAvatar = map["profilepic"],
        authorId = map["user"],
        date = map["date"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = commentId;
    data['text'] = text;
    data['name'] = authorName;
    data['profilepic'] = authorAvatar;
    data['user'] = authorId;
    data['date'] = date;
    return data;
  }
}
