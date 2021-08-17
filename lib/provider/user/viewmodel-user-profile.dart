import 'package:intl/intl.dart';

import '../../data/user/data-user-details.dart';
import '../../data/user/data-education.dart';
import '../../data/user/data-experience.dart';
import '../../data/user/data-user.dart';
import '../../utils/constants/utils.dart';

class UserProfileViewModel {
  final UserDetailsData userDetails;

  UserProfileViewModel({this.userDetails});

  List<String> get skills {
    return this.userDetails?.skills;
  }

  String get id {
    return this.userDetails?.id;
  }

  UserData get user {
    return this.userDetails?.user;
  }

  String get profilePic {
    return '$secretHollowsEndPoint/img/${this.userDetails?.profilePic}';
  }

  String get positionStatus {
    return this.userDetails?.positionStatus;
  }

  String get company {
    return this.userDetails?.company;
  }

  String get website {
    return this.userDetails?.website;
  }

  String get location {
    return this.userDetails?.location;
  }

  String get bio {
    return this.userDetails?.bio;
  }

  String get gender {
    return this.userDetails?.gender;
  }

  String get civilStatus {
    return this.userDetails?.civilStatus;
  }

  String get birthDate {
    return DateFormat('MM/dd/yyyy').format(DateTime.parse(this.userDetails?.birthDate).add(Duration(hours: 8)));
  }

  String get homeAddress {
    return this.userDetails?.homeAddress;
  }

  String get city {
    return this.userDetails?.city;
  }

  String get area {
    return this.userDetails?.area;
  }

  String get state {
    return this.userDetails?.state;
  }

  double get lat {
    return this.userDetails?.homeLat;
  }

  double get lng {
    return this.userDetails?.homeLng;
  }

  List<ExperienceData> get experience {
    return this.userDetails?.experience;
  }

  List<EducationData> get education {
    return this.userDetails?.education;
  }
}
