import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../../news-feed.dart';
import '../../utils/constants/utils.dart';
import '../../utils/schedule-notifications.dart';
import '../../services/socket-service.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  FlutterLocalNotificationsPlugin plugin;

  @override
  void initState() {
    super.initState();

    plugin = FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    plugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload: $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final SocketService socketService = injector.get<SocketService>();
    socketService.createSocketConnection();
    socketService.socket.on("notificationAlert", (data) {
      print('received data X $data');
//      notifications.show(
//        id: 0,
//        importance: Importance.Max,
//        priority: Priority.High,
//        ticker: 'ticker',
//        title: 'sample title',
//        body: 'sample body',
//        payload: 'sample payload',
//      );
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    print('tapped notif');
                    Timer(Duration(seconds: 3), () {
                      showNotification();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/truck.svg',
                          color: colorPrimary,
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Services',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: colorPrimary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/video.svg',
                          color: colorPrimary,
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Videos',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: colorPrimary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/shopping-cart.svg',
                          color: colorPrimary,
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Store',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: colorPrimary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Flexible(
          child: NewsFeed(),
        ),
      ],
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await plugin.show(
        0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Sample notification by JorneL');
  }

}
