import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

import '../bottom-nav/home.dart';
import '../bottom-nav/report.dart';
import '../bottom-nav/special.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../screens/profile/profile-main.dart';
import '../../screens/responders/responders.dart';
import '../../screens/posts/posts.dart';
import '../../screens/id/id.dart';
import '../../services/web-service.dart';

class GuardianHome extends StatefulWidget {
  final String token;

  GuardianHome({this.token});

  @override
  State<StatefulWidget> createState() => _GuardianHomeState();
}

class _GuardianHomeState extends State<GuardianHome> {
  UserViewModel vm;
  UserProfileViewModel userProfileVM;
  List<UserProfileViewModel> userList = [];

  final _scrollController = ScrollController();
  List _children;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print('fcmToken - $token'));
  }

  @override
  void initState() {
    super.initState();
    _children = [
      Home(
        token: widget.token,
        vm: vm,
        userProfileVM: userProfileVM,
        openProfileScreen: openProfileScreen,
        userList: userList,
      ),
      Container(),
      Report(),
      Special(androidFusedLocation: true),
    ];
    getMessage();

    _fetchDetails().then((value) {
      setState(() {
        _children[0] = Home(
          token: widget.token,
          vm: value,
          userProfileVM: userProfileVM,
          openProfileScreen: openProfileScreen,
          userList: userList,
        );
        // print('value: $value');
        vm = value;
      });
      var box = Hive.box('user_db');
      box.put('name', value.name);
      box.put('token', widget.token);
      box.put('id', value.id);
    });

    _fetchUserProfile().then((value) => setState(() {
          _children[0] = Home(
            token: widget.token,
            vm: vm,
            userProfileVM: UserProfileViewModel(userDetails: value),
            openProfileScreen: openProfileScreen,
            userList: userList,
          );
          // print('UserProfileValue: ${value.profilePic}');
          userProfileVM = UserProfileViewModel(userDetails: value);
        }));

    fetchUsers().then((value) {
      print('fetchUsers - $value');
      setState(() {
        _children[0] = Home(
          token: widget.token,
          vm: vm,
          userProfileVM: userProfileVM,
          openProfileScreen: openProfileScreen,
          userList: value,
        );
        userList = value;
      });
    });
  }

  Future<void> _refreshUser() {
    _fetchUserProfile().then((value) => setState(() {
      _children[0] = Home(
        token: widget.token,
        vm: vm,
        userProfileVM: UserProfileViewModel(userDetails: value),
        openProfileScreen: openProfileScreen,
        userList: userList,
      );
      // print('UserProfileValue: ${value.profilePic}');
      userProfileVM = UserProfileViewModel(userDetails: value);
    }));
    return Future.value();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<UserViewModel> _fetchDetails() async {
    var result = await Webservice().fetchUserDetails(widget.token);
    print('User = $result');
    return UserViewModel(user: result);
  }

  Future<Object> _fetchUserProfile() async {
    var result = await Webservice().fetchUserProfile(widget.token);
    print('UserProfile = $result');
    // return UserProfileViewModel(userDetails: result);
    return result;
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    });
  }

  // _editProfilePicture() {
  //   setState(() {});
  // }

  openProfileScreen() => NavigationHelper.openProfileScreen2(
      context, vm, userProfileVM, userProfileVM, widget.token, 'post');

  @override
  Widget build(BuildContext context) {
    print('build guardian-home $userProfileVM');
    _register();
    print('authToken - ${widget.token}');
    return DefaultTabController(
      length: (userProfileVM != null && userProfileVM.company != null) ? 4: 3,
      initialIndex: (userProfileVM != null && userProfileVM.company != null) ? 2 : 1,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: colorPrimary,
                leading: Transform.translate(
                  offset: Offset(16.0, 0.0),
                  child: Image.asset(
                    'assets/images/guardian.png',
                    // height: 24.0,
                    // width: 24.0,
                    // fit: BoxFit.fitWidth,
                    // alignment: FractionalOffset.center,
                  ),
                ),
                centerTitle: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GUARDIAN',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5.0,
                      ),
                    ),
                    Text(
                      'Emergency Response',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                        letterSpacing: 4.0,
                      ),
                    ),
                  ],
                ),
                pinned: true,
                //<-- pinned to true
                floating: true,
                //<-- floating to true
                forceElevated: innerBoxIsScrolled,
                //<-- forceElevated to innerBoxIsScrolled
                bottom: (userProfileVM != null && userProfileVM.company != null) ?
                TabBar(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.0,
                  ),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/id_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/ambu_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/post_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/prof_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ) :
                TabBar(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.0,
                  ),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/ambu_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/post_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                    Tab(
                      icon: ImageIcon(
                        AssetImage('assets/prof_ti.png'),
                        size: 128,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: (userProfileVM != null && userProfileVM.company != null)
              ? TabBarView(
                      children: [
                        ID(
                          vm: vm,
                          userProfileVM: userProfileVM,
                          userOriginalVM: userProfileVM,
                        ),
                        Responders(
                          vm: vm,
                          userVM: userProfileVM,
                          token: widget.token,
                          origin: 'posts',
                          responderList: userList,
                        ),
                        Posts(
                          token: widget.token,
                          vm: vm,
                          userProfileVM: userProfileVM,
                          openProfileScreen: openProfileScreen,
                          userList: userList,
                        ),
                        ProfileMain(
                          vm: vm,
                          userVM: userProfileVM,
                          token: widget.token,
                          origin: 'posts',
                          userOVM: userProfileVM,
                          refresh: _refreshUser,
                        ),
                      ],
                    )
              : TabBarView(
                  children: [
                    Responders(
                      vm: vm,
                      userVM: userProfileVM,
                      token: widget.token,
                      origin: 'posts',
                      responderList: userList,
                    ),
                    Posts(
                      token: widget.token,
                      vm: vm,
                      userProfileVM: userProfileVM,
                      openProfileScreen: openProfileScreen,
                      userList: userList,
                    ),
                    ProfileMain(
                      vm: vm,
                      userVM: userProfileVM,
                      token: widget.token,
                      origin: 'posts',
                      userOVM: userProfileVM,
                      refresh: _refreshUser,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/***
 * SafeArea(
    child: WillPopScope(
    onWillPop: () => Future.value(false),
    child: Scaffold(
    key: _pageKey,
    drawer: Drawer(
    child: ListView(
    padding: EdgeInsets.zero,
    children: [
    DrawerHeader(
    decoration: BoxDecoration(
    gradient:
    LinearGradient(colors: [colorPrimary, colorPrimary1]),
    ),
    child: GestureDetector(
    onTap: () {
    _fetchUserProfile().then((value) {
    Navigator.pop(context);
    print('fetchUserProfile result - $value');
    userProfileVM =
    (value == 'There is no profile for this user')
    ? null
    : UserProfileViewModel(userDetails: value);
    NavigationHelper.openProfileScreen2(
    context,
    vm,
    userProfileVM,
    userProfileVM,
    widget.token,
    'post',
    );
    });
    },
    child: Container(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    // CircleAvatar(
    //   radius: 36.0,
    //   backgroundColor: Colors.white,
    //   backgroundImage: NetworkImage(
    //     (userProfileVM == null || userProfileVM.profilePic.contains('null'))
    //         ? (vm == null )
    //         ? 'https://blog.radware.com/wp-content/uploads/2020/06/anonymous.jpg'
    //         : vm.avatar
    //         : userProfileVM.profilePic,
    //   ),
    // ),
    ClipOval(
    child: SizedBox(
    width: 72.0,
    height: 72.0,
    child: FadeInImage.assetNetwork(
    placeholder: 'assets/loading.gif',
    image: (userProfileVM == null ||
    userProfileVM.profilePic
    .contains('null'))
    ? 'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE'
    : userProfileVM.profilePic,
    fit: BoxFit.cover,
    ),
    ),
    ),
    SizedBox(
    width: 8.0,
    ),
    Flexible(
    child: Text(
    (vm == null) ? 'Unknown?' : vm.name,
    maxLines: 2,
    style: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
    SizedBox(
    height: 16.0,
    ),
    Text(
    (userProfileVM == null ||
    // userProfileVM.status == null ||
    userProfileVM.company == null)
    ? ''
    : /*'${userProfileVM.status} at */'${userProfileVM.company}',
    style: TextStyle(
    color: Colors.white,
    ),
    ),
    SizedBox(
    height: 4.0,
    ),
    Text(
    (userProfileVM == null ||
    userProfileVM.location == null)
    ? ''
    : userProfileVM.location,
    style: TextStyle(
    color: Colors.white,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ListTile(
    title: Text('Logout'),
    onTap: () {
    Navigator.of(context).pop();
    NavigationHelper.login(context);
    },
    ),
    ],
    ),
    ),
    appBar: appBar[_currentIndex],
    body: (_currentIndex == 0 && vm == null) ?
    Container(
    color: colorPrimary,
    ) :
    _children[_currentIndex],
    floatingActionButton: FloatingActionButton(
    onPressed: () {
    // TODO: Add your onPressed code here!
    },
    child: Icon(Icons.add),
    backgroundColor: colorPrimary,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: BottomNavigationBar(
    currentIndex:
    _currentIndex, // this will be set when a new tab is tapped
    type: BottomNavigationBarType.fixed,
    selectedItemColor: colorPrimary,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedItemColor: Colors.grey,
    onTap: onTapped,
    items: [
    BottomNavigationBarItem(
    icon: Container(
    height: 36.0,
    width: 36.0,
    padding: EdgeInsets.all(8.0),
    child: SvgPicture.asset(
    'assets/home.svg',
    color: colorPrimary,
    ),
    ),
    //             title: Text(
    //               'HOME',
    //               style: TextStyle(
    //                 fontSize: 10.0,
    // //                color: Colors.grey
    //               ),
    //             ),
    label: 'HOME',
    ),
    BottomNavigationBarItem(
    icon: Container(
    height: 36.0,
    width: 36.0,
    padding: EdgeInsets.all(8.0),
    child: SvgPicture.asset(
    'assets/maximize.svg',
    color: colorPrimary,
    height: 16.0,
    width: 16.0,
    ),
    ),
    //               title: Text(
    //                 'SCAN',
    //                 style: TextStyle(
    //                   fontSize: 10.0,
    // //                color: Colors.grey
    //                 ),
    //               ),
    label: 'SCAN',
    ),
    BottomNavigationBarItem(
    icon: Container(
    height: 36.0,
    padding: EdgeInsets.all(8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SvgPicture.asset(
    'assets/camera.svg',
    color: colorPrimary,
    height: 16.0,
    width: 16.0,
    ),
    Container(
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    height: 24.0,
    width: 2.0,
    color: colorPrimary,
    ),
    SvgPicture.asset(
    'assets/video.svg',
    color: colorPrimary,
    height: 16.0,
    width: 16.0,
    ),
    ],
    ),
    ),
    //               title: Text(
    //                 'SEND REPORT',
    //                 style: TextStyle(
    //                   fontSize: 10.0,
    // //                color: Colors.grey
    //                 ),
    //               ),
    label: 'SEND REPORT',
    ),
    BottomNavigationBarItem(
    icon: Container(
    child: Image.asset(
    'assets/images/report-button.png',
    height: 36.0,
    width: 36.0,
    fit: BoxFit.cover,
    ),
    ),
    //               title: Text(
    //                 'EMERGENCY CALL',
    //                 style: TextStyle(
    //                   fontSize: 10.0,
    // //                  color: Colors.grey
    //                 ),
    //               ),
    label: 'EMERGENCY CALL',
    )
    ],
    ),
    ),
    ),
    );
 */

/***
 * DefaultTabController(
    length: 6,
    child: Scaffold(
    appBar: AppBar(
    centerTitle: true,
    leading: Icon(Icons.person_outline),
    title: Text(‘HOME SCREEN',style: TextStyle(fontSize: 16.0),),
    bottom: PreferredSize(
    child: TabBar(
    isScrollable: true,
    unselectedLabelColor: Colors.white.withOpacity(0.3),
    indicatorColor: Colors.white,
    tabs: [
    Tab(
    child: Text(‘Kumar'),
    ),
    Tab(
    child: Text(‘Lokesh'),
    ),
    Tab(
    child: Text(‘Rathod'),
    ),
    Tab(
    child: Text(‘Raj'),
    ),
    Tab(
    child: Text(’Madan'),
    ),
    Tab(
    child: Text(‘Manju'),
    )
    ]),
    preferredSize: Size.fromHeight(30.0)),
    actions: <Widget>[
    Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Icon(Icons.add_alert),
    ),
    ],
    ),
    body: TabBarView(
    children: <Widget>[
    Container(
    child: Center(
    child: Text('Tab 1'),
    ),
    ),
    Container(
    child: Center(
    child: Text('Tab 2'),
    ),
    ),
    Container(
    child: Center(
    child: Text('Tab 3'),
    ),
    ),
    Container(
    child: Center(
    child: Text('Tab 4'),
    ),
    ),
    Container(
    child: Center(
    child: Text('Tab 5'),
    ),
    ),
    Container(
    child: Center(
    child: Text('Tab 6'),
    ),
    ),
    ],
    )),
    );
 ***/
