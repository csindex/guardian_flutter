import '../../data/user/data-user2.dart';
import '../../data/user/data-responder.dart';

class UserViewModel {
  final UserData2 user;

  UserViewModel({this.user});

  String get id {
    return this.user.id;
  }

  String get name {
    return '${this.user.name}${this.user.lname == null ? '' : ' '}${this.user.lname ?? ''}';
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

  List<ResponderData> get responderData {
    return this.user.responderData;
  }
}
