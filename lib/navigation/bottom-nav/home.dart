import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../widgets/posts/list-posts.dart';
import '../../widgets/profile/profile-dashboard.dart';
import '../../utils/constants/utils.dart';
import '../../utils/schedule-notifications.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../services/socket-service.dart';
import '../../services/web-service.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

class Home extends StatefulWidget {
  final String token;
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final Function openProfileScreen;

  Home(
      {Key key,
      @required this.openProfileScreen,
      this.token,
      this.vm,
      this.userProfileVM})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState(/*token: this.token, vm: this.vm*/);
}

class _HomeState extends State<Home> {
  FlutterLocalNotificationsPlugin plugin;

  // String token;
  // UserViewModel vm;
  //
  // _HomeState({this.token, this.vm});

  String _page = 'posts';

  @override
  void initState() {
    super.initState();

    plugin = FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: ios);
    plugin.initialize(initSettings, onSelectNotification: onSelectNotification);
    // print('VM: ${widget.vm.name}');
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
      children: [
        Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Material(
                color: colorPrimary,
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
                      children: [
                        // SvgPicture.asset(
                        //   'assets/truck.svg',
                        //   color: colorPrimary,
                        //   height: 16.0,
                        //   width: 16.0,
                        // ),
                        FaIcon(
                          FontAwesomeIcons.ambulance,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          // 'Services',
                          'Responders',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
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
                color: colorPrimary,
                child: InkWell(
                  onTap: () {
                    if (_page != 'posts') {
                      setState(() {
                        _page = 'posts';
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'assets/video.svg',
                        //   color: colorPrimary,
                        //   height: 16.0,
                        //   width: 16.0,
                        // ),
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          // 'Videos',
                          'Posts',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
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
                color: colorPrimary,
                child: InkWell(
                  onTap: () {
                    // if (widget.vm != null && widget.userProfileVM != null) {
                    // NavigationHelper.openProfileScreen(
                    //     context, widget.vm, widget.userProfileVM, widget.token);
                    widget.openProfileScreen();
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'assets/shopping-cart.svg',
                        //   color: colorPrimary,
                        //   height: 16.0,
                        //   width: 16.0,
                        // ),
                        FaIcon(
                          FontAwesomeIcons.solidUser,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          // 'Store',
                          'Profile',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
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
        (_page == 'posts')
            ? (widget.vm == null)
                ? Container(
                    height: MediaQuery.of(context).size.height / 2.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                      ),
                    ),
                  )
                : Flexible(
                    child: PostsList(
                      token: widget.token,
                      viewModel: widget.vm,
                    ),
                  )
            : (_page == 'detailed-profile')
                ? (widget.vm == null)
                    ? Container(
                        height: MediaQuery.of(context).size.height / 2.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colorPrimary),
                          ),
                        ),
                      )
                    : Flexible(
                        child: ProfileDashboard(
                            token: widget.token, vm: widget.vm),
                      )
                : Container(),
      ],
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await plugin.show(
        0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Sample notification by JorneL');
  }

  // Future<Object> fetchUserProfile() async {
  //   return await Webservice().fetchUserProfile(token);
  // }

}
