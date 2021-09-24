class ResponderData {

  String id;
  String opcen;
  String type;
  String date;
  UserData rUser;
  ProfileData profile;

  ResponderData.fromJsonMap(Map<String, dynamic> map):
        id = map["_id"],
        opcen = map["opcen"],
        type = map["type"],
        date = map["date"],
        rUser = UserData.fromJsonMap(map["user"]),
        profile = ProfileData.fromJsonMap(map["profilee"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['opcen'] = opcen;
    data['type'] = type;
    data['date'] = date;
    data['user'] = rUser;
    data['profilee'] = profile;
    return data;
  }

}

class UserData {

  String userId;
  String name;
  String lname;

  UserData.fromJsonMap(Map<String, dynamic> map) :
        userId = map["_id"],
        name = map["name"],
        lname = map["lname"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = userId;
    data['name'] = name;
    data['lname'] = lname;
    return data;
  }

}

class ProfileData {

  String profileId;
  String profilePic;

  ProfileData.fromJsonMap(Map<String, dynamic> map) :
        profileId = map["_id"],
        profilePic = map["profilepic"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = profileId;
    data['profilepic'] = profilePic;
    return data;
  }

}