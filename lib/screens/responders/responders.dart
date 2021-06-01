import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';

class Responders extends StatefulWidget {
  final String token;
  final String origin;
  final UserViewModel vm;
  final UserProfileViewModel userVM;
  final List<UserProfileViewModel> responderList;

  Responders(
      {this.responderList, this.token, this.origin, this.vm, this.userVM});

  @override
  _RespondersState createState() => _RespondersState();
}

class _RespondersState extends State<Responders>
    with AutomaticKeepAliveClientMixin<Responders> {
  List<UserProfileViewModel> _responderList = <UserProfileViewModel>[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _responderList = widget.responderList;
  }

  void _fetchResponders() {
    fetchUsers().then((value) {
      print('fetchResponders - $value');
      setState(() {
        _responderList = value;
      });
    });
  }

  Future<void> _refresh() {
    _fetchResponders();
    return Future.value();
  }

  Widget _createResponderItem(int index) {
    return GestureDetector(
      onTap: () {
        // print('clicked ${widget.responderList[index].user.name}');
        NavigationHelper.openProfileScreen2(context, widget.vm,
            _responderList[index], widget.userVM, widget.token, 'post');
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 4.0,
        ),
        child: _thirdDesign(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build called on responders');
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: _refresh,
      child: Container(
        color: Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return (index == 0) ?
            Padding(
              padding: EdgeInsets.all(16.0),
              child: _header,
            ) :
            _createResponderItem(index - 1);
          },
          itemCount: _responderList.length + 1,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }

  /*Widget get _appBar => CustomAppBarHome(
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
      );*/

  Widget get _header => Row(
    mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          FontAwesomeIcons.connectdevelop,
          color: Colors.grey.shade700,
          size: 16.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          'Connect with other Volunteers',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );

  Widget _thirdDesign(int index) {
    var _responder = _responderList[index];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 8.0,
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(24.0),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900,
                  spreadRadius: 1.0,
                  blurRadius: 4.0,
                  offset: Offset(4.0, 6.0),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 100.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 99.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_responder.profilePic),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            '${_responder.user.name} ${_responder.user.lname}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              _responder.positionStatus ?? '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: SizedBox(
              height: 8.0,
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              (_responder.company != null) ? '@ ${_responder.company}' : '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: SizedBox(
              height: 8.0,
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              _responder.location ?? '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * return SafeArea(
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
 * **/
