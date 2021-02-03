import 'data-education.dart';
import 'data-experience.dart';
import 'data-user.dart';

class UserDetailsData {
  List<String> skills;
  String id;
  UserData user;
  String profilePic;
  String company;
  String website;
  String location;
  String bio;
  String status;
  List<ExperienceData> experience;
  List<EducationData> education;
  String msg;

  UserDetailsData.fromJsonMap(Map<String, dynamic> map)
      : skills = List<String>.from(map["skills"]).toList(),
        id = map["_id"],
        user = UserData.fromJsonMap(map["user"]),
        profilePic = map["profilepic"],
        company = map["company"],
        website = map["website"],
        location = map["location"],
        bio = map["bio"],
        status = map["status"],
        msg = map["msg"],
        experience = List<ExperienceData>.from(
            map["experience"].map((it) => ExperienceData.fromJsonMap(it))),
        education = List<EducationData>.from(
            map["education"].map((it) => EducationData.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skills'] = skills;
    data['_id'] = id;
    data['user'] = user.toJson();
    data['profilepic'] = profilePic;
    data['company'] = company;
    data['website'] = website;
    data['location'] = location;
    data['bio'] = bio;
    data['status'] = status;
    data['msg'] = msg;
    data['experience'] = experience;
    data['education'] = education;
    return data;
  }
}
