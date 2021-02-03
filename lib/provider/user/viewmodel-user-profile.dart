import '../../data/user/data-user-details.dart';
import '../../data/user/data-education.dart';
import '../../data/user/data-experience.dart';
import '../../data/user/data-user.dart';
import '../../utils/constants/utils.dart';

class UserProfileViewModel {
  final UserDetailsData userDetails;

  UserProfileViewModel({this.userDetails});

  List<String> get skills {
    return this.userDetails.skills;
  }

  String get id {
    return this.userDetails.id;
  }

  UserData get user {
    return this.userDetails.user;
  }

  String get profilePic {
    return '$secretHollowsEndPoint/img/${this.userDetails.profilePic}';
  }

  String get company {
    return this.userDetails.company;
  }

  String get website {
    return this.userDetails.website;
  }

  String get location {
    return this.userDetails.location;
  }

  String get bio {
    return this.userDetails.bio;
  }

  String get status {
    return this.userDetails.status;
  }

  List<ExperienceData> get experience {
    return this.userDetails.experience;
  }

  List<EducationData> get education {
    return this.userDetails.education;
  }
}
