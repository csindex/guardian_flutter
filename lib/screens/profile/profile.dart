import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';

import 'profile-header.dart';
import 'personal-info.dart';

class Profile extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final String token;

  Profile({this.vm, this.userProfileVM, this.token});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SwiperController _swiperController = SwiperController();

  final List<Widget> _info = [
    PersonalInfo(),
    Card(
        child: Container(
      height: 100.0,
      width: 100.0,
    )),
    Card(
        child: Container(
      height: 100.0,
      width: 100.0,
    ))
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(
              vm: widget.vm,
              userProfileVM: widget.userProfileVM,
              token: widget.token,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: (_index == 0) ? colorPrimary : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: colorPrimary),
                  ),
                  onPressed: () {
                    _swiperController.move(0);
                  },
                  child: Text(
                    'Personal',
                    style: TextStyle(
                      color: (_index == 0) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                FlatButton(
                  color: (_index == 1) ? colorPrimary : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(color: colorPrimary)),
                  onPressed: () {
                    _swiperController.move(1);
                  },
                  child: Text(
                    'Organization',
                    style: TextStyle(
                      color: (_index == 1) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                FlatButton(
                  color: (_index == 2) ? colorPrimary : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(color: colorPrimary)),
                  onPressed: () {
                    _swiperController.move(2);
                  },
                  child: Text(
                    'Emergency',
                    style: TextStyle(
                      color: (_index == 2) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Swiper(
                controller: _swiperController,
                itemBuilder: (BuildContext context, int index) => _info[index],
                itemCount: 3,
                itemWidth: MediaQuery.of(context).size.width - 64.0,
                pagination: SwiperPagination(),
                onIndexChanged: (index) => setState(() {
                  _index = index;
                }),
                viewportFraction: 0.8,
                scale: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
