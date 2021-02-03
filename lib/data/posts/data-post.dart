import 'data-comment.dart';
import 'data-like.dart';

class PostData {
  String postId;
  String text;
  String authorName;
  String authorAvatar;
  String authorProfilePic;
  String authorId;
  String articleImage;
  List<LikeData> likes;
  List<CommentData> comments;
  String date;

  PostData.fromJsonMap(Map<String, dynamic> map)
      : postId = map["_id"],
        text = map["text"],
        authorName = map["name"],
        authorAvatar = map["avatar"],
        authorProfilePic = map["profilepic"],
        authorId = map["user"],
        articleImage = map["articleImage"],
        likes = List<LikeData>.from(
            map["likes"].map((it) => LikeData.fromJsonMap(it))),
        comments = List<CommentData>.from(
            map["comments"].map((it) => CommentData.fromJsonMap(it))),
        date = map["date"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = postId;
    data['text'] = text;
    data['name'] = authorName;
    data['avatar'] = authorAvatar;
    data['profilepic'] = authorProfilePic;
    data['user'] = authorId;
    data['articleImage'] = articleImage;
    data['likes'] = likes;
    data['comments'] = comments;
    data['date'] = date;
    return data;
  }
}
