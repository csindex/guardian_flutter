import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import './provider/viewmodel-notification-list.dart';
import './utils/constants/utils.dart';
import './notification.dart' as notif;

class NewsFeed extends StatefulWidget {

//  Widget _createRecommendedPages() => SizedBox(
//    child: RecommendedPages(348.0),
//    height: 348.0,
//  );

  @override
  _NewsFeedState createState() => _NewsFeedState();

}

class _NewsFeedState extends State<NewsFeed> {

  List<NotificationViewModel> notifs = List<NotificationViewModel>();

  void _pullNotifications() {
    final vm = Provider.of<NotificationListViewModel>(context, listen: false);
    vm.fetchNotifications("").then((value) {
      setState(() {
        notifs.clear();
        notifs.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _pullNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: refresh,
      child: notif.Notification(notifications: notifs),
    );
  }

  Future<void> refresh() {
    _pullNotifications();
    return Future.value();
  }

}
