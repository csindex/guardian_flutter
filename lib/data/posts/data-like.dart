class LikeData {
  String likeId;
  String likerId;

  LikeData.fromJsonMap(Map<String, dynamic> map)
      : likeId = map["_id"],
        likerId = map["user"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = likeId;
    data['user'] = likerId;
    return data;
  }
}
