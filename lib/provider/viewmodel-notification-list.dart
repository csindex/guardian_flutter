import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../data/data.dart';
import '../services/web-service.dart';
import '../data/uploads.dart';
import '../data/affected-areas.dart';

class NotificationListViewModel extends ChangeNotifier {
  List<NotificationViewModel> notifications = List<NotificationViewModel>();

  Future<List<NotificationViewModel>> fetchNotifications(String keyword) async {
    final results = await Webservice().fetchNotifications(keyword);
    this.notifications =
        results.map((item) => NotificationViewModel(notif: item)).toList();
    notifyListeners();
    return notifications;
  }
}

class NotificationViewModel {
  final Data notif;

  NotificationViewModel({this.notif});

  String get title {
    return this.notif.title;
  }

  String get body {
    return this.notif.whatTodo;
  }

  String get poster {
    return this.notif.whatTodo;
  }

  List<AffectedAreas> get affectedAreas {
    return this.notif.affectedAreas;
  }

  List<Uploads> get uploads {
    return List<Uploads>(); //this.notif.uploads;
  }

  String get imageFullPath {
    return this.notif.imageFullPath; //this.notif.uploads;
  }

  String get date {
    return '${DateFormat('MMM, dd').format(DateTime.parse(this.notif.updatedAt))}'
        ' at ${DateFormat('hh:mm a').format(DateTime.parse(this.notif.updatedAt))}';
  }
}
