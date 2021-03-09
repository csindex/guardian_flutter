import 'data-education.dart';
import 'data-experience.dart';
import 'data-user.dart';

class UserDetailsData {
  List<String> skills;
  String id;
  UserData user;
  String profilePic;
  String positionStatus;
  String company;
  String website;
  String location;
  String bio;
  String gender;
  String civilStatus;
  String birthDate;
  String homeAddress;
  double homeLat;
  double homeLng;
  List<ExperienceData> experience;
  List<EducationData> education;
  String msg;

  UserDetailsData.fromJsonMap(Map<String, dynamic> map):
        skills = List<String>.from(map["skills"]).toList(),
        id = map["_id"],
        user = UserData.fromJsonMap(map["user"]),
        profilePic = map["profilepic"],
        positionStatus = map["status"],
        company = map["organization"],
        website = map["website"],
        location = map["location"],
        bio = map["bio"],
        gender = map["gender"],
        civilStatus = map["civilstatus"],
        birthDate = map["birthday"],
        homeAddress = map["completeaddress"],
        homeLat = map["lat"],
        homeLng = map["lng"],
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
    data['status'] = positionStatus;
    data['organization'] = company;
    data['website'] = website;
    data['location'] = location;
    data['bio'] = bio;
    data['gender'] = gender;
    data['civilstatus'] = civilStatus;
    data['birthday'] = birthDate;
    data['completeaddress'] = homeAddress;
    data['lat'] = homeLat;
    data['lng'] = homeLng;
    data['msg'] = msg;
    data['experience'] = experience;
    data['education'] = education;
    return data;
  }
}
