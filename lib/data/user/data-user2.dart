import 'data-responder.dart';

class UserData2 {
  String id;
  String name;
  String lname;
  String email;
  String number;
  String avatar;
  List<ResponderData> responderData = [];

  UserData2.fromJsonMap(Map<String, dynamic> map):
        id = map["_id"],
        name = map["name"],
        lname = map["lname"],
        email = map["email"],
        number = map["number"],
        avatar = map["avatar"],
        responderData = List<ResponderData>.from(
            map["responder"]?.map((it) => ResponderData.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['name'] = name;
    data['lname'] = lname;
    data['email'] = email;
    data['number'] = number;
    data['avatar'] = avatar;
    data['responder'] = responderData;
    return data;
  }
}
