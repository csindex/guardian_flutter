class UserData {
  String id;
  String name;
  String lname;
  String email;
  String number;
  String avatar;

  UserData.fromJsonMap(Map<String, dynamic> map):
        id = map["_id"],
        name = map["name"],
        lname = map["lname"],
        email = map["email"],
        number = map["number"],
        avatar = map["avatar"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['name'] = name;
    data['lname'] = lname;
    data['email'] = email;
    data['number'] = number;
    data['avatar'] = avatar;
    return data;
  }
}
