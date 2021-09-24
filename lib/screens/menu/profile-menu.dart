import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/utils/helpers/navigation-helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:network_to_file_image/network_to_file_image.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../profile/profile-main.dart';

class ProfileMenu extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userVM;
  final String token;
  final String origin;
  final UserProfileViewModel userOVM;
  final Function updateProfile;

  ProfileMenu({
    this.vm, this.userVM, this.token, this.origin, this.userOVM, this.updateProfile,});

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  bool _isVolSelected = true;
  bool _isViewProfile = false;

  void _viewProfile() => setState(() => _isViewProfile = !_isViewProfile);

  void _selectVolunteer() => setState(() => _isVolSelected = !_isVolSelected);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('profile-menu - ${widget.vm}');
    // return (widget.userVM == null || widget.userVM?.company == null) ? _emptyProfile : _mainProfile;
    return _isViewProfile ? ProfileMain(
      vm: widget.vm,
      userVM: widget.userVM,
      token: widget.token,
      origin: 'posts',
      userOVM: widget.userOVM,
      refresh: widget.updateProfile,
      viewProfile: _viewProfile,
    ) : (widget.userVM == null
        || widget.userVM.profilePic == null
        || widget.userVM.profilePic.contains('null')) ? FutureBuilder<File>(
      future: file('defaultProfPic.png'),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          Widget w;
          if (snapshot.hasData) {
            print('Ikaw pala ${snapshot.data}');
            var data = snapshot.data;
            w = Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Container(
              margin: EdgeInsets.all(16.0,),
              padding: EdgeInsets.all(16.0,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.white,
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0,),
                    ),
                    onPressed: _viewProfile,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24.0,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkToFileImage(
                            url: '$secretHollowsEndPoint/img/Spotter.png',
                            file: data,
                            debug: true,
                          ),
                        ),
                        hSpacer(16.0,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.vm == null ?
                                'Juan dela Cross' : widget.vm.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              vSpacer(4.0,),
                              Text(
                                'View your profile',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  vSpacer(24.0,),
                  Text(
                    'Logged in as: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  vSpacer(8.0,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 36.0,),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _isVolSelected ? colorPrimary : Colors.white,
                        primary: _isVolSelected ? Colors.white : colorPrimary,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      ),
                      onPressed: () {
                        if (!_isVolSelected) {
                          _selectVolunteer();
                        }
                      },
                      child: Text(
                        'Volunteer',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  vSpacer(16.0,),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 16.0,),
                    ),
                    onPressed: () {
                      NavigationHelper.login(context);
                    },
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.signOutAlt,
                          size: 24.0,
                        ),
                        hSpacer(16.0,),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          w = Container(color: Colors.black,);
        } else {
          w = Container(color: Colors.red,);
        }
        return w;
      },
    ) :
    Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Container(
        margin: EdgeInsets.all(16.0,),
        padding: EdgeInsets.all(16.0,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 1.0,
            color: Colors.white,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0,),
              ),
              onPressed: _viewProfile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    NetworkImage(widget.userVM.profilePic,),
                  ),
                  hSpacer(16.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vm.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        vSpacer(4.0,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'View your profile',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            vSpacer(24.0,),
            Text(
              'Logged in as: ',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            vSpacer(8.0,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 36.0,),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: _isVolSelected ? colorPrimary : Colors.white,
                  primary: _isVolSelected ? Colors.white : colorPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
                onPressed: () {
                  if (!_isVolSelected) {
                    _selectVolunteer();
                  }
                },
                child: Text(
                  'Volunteer',
                  style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (widget.vm.responderData.isNotEmpty) ... [
              vSpacer(4.0,),
              Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 36.0,),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: _isVolSelected ? Colors.white : colorPrimary,
                  primary: _isVolSelected ? colorPrimary : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                ),
                onPressed: () {
                  if (_isVolSelected) {
                    _selectVolunteer();
                  }
                },
                child: Text(
                  'Responder',
                  style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ],
            vSpacer(16.0,),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                primary: Colors.grey.shade500,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              ),
              onPressed: () {
                NavigationHelper.login(context);
              },
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    size: 16.0,
                  ),
                  hSpacer(8.0,),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
