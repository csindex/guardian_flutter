class UserData {
  String id;
  String name;
  String email;
  String number;
  String avatar;

  UserData.fromJsonMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map["name"],
        email = map["email"],
        number = map["number"],
        avatar = map["avatar"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['number'] = number;
    data['avatar'] = avatar;
    return data;
  }
}
