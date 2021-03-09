import 'package:flutter/material.dart';
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
import 'list-responders.dart';


class Responders extends StatefulWidget {
  final String token;
  final String origin;
  final UserViewModel vm;
  final UserProfileViewModel userVM;
  final List<UserProfileViewModel> responderList;

  Responders({
    this.responderList, this.token, this.origin, this.vm, this.userVM});

  @override
  _RespondersState createState() => _RespondersState();
}

class _RespondersState extends State<Responders> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar,
        body: Material(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Material(
                        color: colorPrimary,
                        child: InkWell(
                          onTap: () {
                            // TODO: Responders
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.ambulance,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
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
                            // TODO: Posts
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.envelope,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
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
                            // TODO: Profile
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.solidUser,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
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
                (widget.vm == null && widget.responderList.length == 0) ?
                Container(
                  height: MediaQuery.of(context).size.height / 2.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                    ),
                  ),
                ) :
                Flexible(
                  child: RespondersList(
                    token: widget.token,
                    vm: widget.vm,
                    responderList: widget.responderList,
                    userVM: widget.userVM,
                    origin: widget.origin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _appBar => CustomAppBarHome(
    height: 88.0,
    icon: Image.asset(
      'assets/images/guardian.png',
      height: 88.0,
      width: 88.0,
      fit: BoxFit.fitWidth,
      alignment: FractionalOffset.center,
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'GUARDIAN',
          style: TextStyle(
              fontSize: 28.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0),
        ),
        Text(
          'Emergency Response',
          style: TextStyle(
            fontSize: 10.0,
            color: colorPrimary,
            letterSpacing: 4.2,
            wordSpacing: 8.0,
          ),
        ),
      ],
    ),
    actions: Row(
      children: [
        ClipOval(
          child: Material(
            // button color
            child: InkWell(
              splashColor: Colors.grey.shade700, // inkwell color
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        ClipOval(
          child: Material(
            // button color
            child: InkWell(
              splashColor: Colors.grey.shade700, // inkwell color
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Icon(
                  Icons.menu,
                  color: Colors.grey.shade500,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ],
    ),
  );
}
