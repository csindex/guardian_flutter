import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';

import 'profile-header.dart';
import 'personal-info.dart';
import 'organization-info.dart';
import 'emergency-info.dart';

class Profile extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final String token;
  final String origin;
  final UserProfileViewModel userOriginalVM;

  Profile({
    this.vm, this.userProfileVM, this.token, this.origin, this.userOriginalVM});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SwiperController _swiperController = SwiperController();

  UserViewModel _vm;
  UserProfileViewModel _userProfileVM;
  UserProfileViewModel _userOriginalVM;
  String _token;

  int _index = 0;

  Widget _getSwiperChild(int index) {
    switch (index) {
      case 1: return OrganizationInfo(
        vm: _vm,
        userProfileVM: _userProfileVM,
        token: _token,
        userOriginalVM: _userOriginalVM,
      );
      case 2: return EmergencyInfo();
      default: return PersonalInfo(
        vm: _vm,
        userProfileVM: _userProfileVM,
        token: _token,
        userOriginalVM: _userOriginalVM,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _vm = widget.vm;
    _userProfileVM = widget.userProfileVM;
    _userOriginalVM = widget.userOriginalVM;
    _token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(
              vm: _vm,
              userProfileVM: _userProfileVM,
              token: _token,
              userOriginalVM: _userOriginalVM,
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
                itemBuilder: (BuildContext context, int index) =>
                    _getSwiperChild(index),
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
