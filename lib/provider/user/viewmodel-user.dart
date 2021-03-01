import '../../data/user/data-user.dart';

class UserViewModel {
  final UserData user;

  UserViewModel({this.user});

  String get id {
    return this.user.id;
  }

  String get name {
    return '${this.user.name} ${this.user.lname}';
  }

  String get email {
    return this.user.email;
  }

  String get number {
    return this.user.number;
  }

  String get avatar {
    return this.user.avatar.replaceAll("//", "https://");
  }
}
