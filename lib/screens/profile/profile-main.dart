import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/utils/helpers/navigation-helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';

class ProfileMain extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userVM;
  final String token;
  final String origin;
  final UserProfileViewModel userOVM;
  final Function refresh;

  ProfileMain({
    this.vm, this.userVM, this.token, this.origin, this.userOVM, this.refresh});

  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.userVM == null ? _emptyProfile : _mainProfile;
  }

  Widget get _nameHeader
  => Row(
    children: [
      FaIcon(
        FontAwesomeIcons.solidUser,
        size: 20.0,
        color: Colors.black,
      ),
      SizedBox(
        width: 8.0,
      ),
      Flexible(
        child: Text(
          'Welcome, ${widget.vm.name}',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );

  Widget get _emptyProfile
  => Scaffold(
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
          _nameHeader,
          SizedBox(
            height: 8.0,
          ),
          Text(
            'You have not yet added a profile, please add your information',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colorPrimary,
              primary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0,),
            ),
            onPressed: () {
              NavigationHelper.openEditProfile(
                context, widget.token, widget.refresh, false, widget.userVM,);
            },
            child: Text(
              'Create Profile',
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget get _mainProfile
  => Scaffold(
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
          _nameHeader,
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorPrimary,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidUserCircle,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 12.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorPrimary,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0,),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  onPressed: () {
                    NavigationHelper.openAddTraining(
                      context, widget.token, widget.refresh,
                    );
                  },
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.blackTie,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Trainings/Experiences',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorPrimary,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  onPressed: () {
                    NavigationHelper.openAddEducation(
                      context, widget.token, widget.refresh,
                    );},
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.graduationCap,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Education',
                        style: TextStyle(
                          fontSize: 12.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Trainings/Experiences',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Years',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Action',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          _trainings,
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Education Credentials',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'School',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Degree',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Years',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: Container(
                  color: colorPrimary,
                  padding: EdgeInsets.symmetric(vertical: 8.0,),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Action',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          _education,
          SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              primary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidUser,
                  size: 16.0,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  '- Delete My Account',
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
  
  Widget get _trainings 
  => ConstrainedBox(
    constraints: BoxConstraints(),
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return _trainingItem(index);
      },
      itemCount: widget.userVM.experience.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    ),
  );

  Widget _trainingItem(int i) {
    var t = widget.userVM.experience[i];
    print('current - ${t.current} x ${t.dateTo}');
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${t.company}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${t.title}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                t.current || t.dateTo == null
                    ? '${DateFormat('yyyy/MM').format(DateTime.parse(t.dateFrom))} - Now'
                    : '${DateFormat('yyyy/MM').format(DateTime.parse(t.dateFrom))} - '
                    '${DateFormat('yyyy/MM').format(DateTime.parse(t.dateTo))}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
            ),
            onPressed: () {
              deleteTraining(t.id).then((value) {
                print('DELETE T- $value');
                if (!value.contains('error')) {
                  widget.refresh();
                }
              });
            },
            child: FaIcon(
              FontAwesomeIcons.trashAlt,
              size: 12.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _education
  => ConstrainedBox(
    constraints: BoxConstraints(),
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return _educationItem(index);
      },
      itemCount: widget.userVM.education.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    ),
  );

  Widget _educationItem(int i) {
    var e = widget.userVM.education[i];
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${e.school}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${e.degree}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                e.current || e.dateTo == null
                    ? '${DateFormat('yyyy/MM').format(DateTime.parse(e.dateFrom))} - Now'
                    : '${DateFormat('yyyy/MM').format(DateTime.parse(e.dateFrom))} - '
                    '${DateFormat('yyyy/MM').format(DateTime.parse(e.dateTo))}',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
            ),
            onPressed: () {
              deleteEducation(e.id).then((value) {
                print('DELETE E- $value');
                if (!value.contains('error')) {
                  widget.refresh();
                }
              });
            },
            child: FaIcon(
              FontAwesomeIcons.trashAlt,
              size: 12.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<String> deleteTraining(String tId) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/profile/experience/$tId');
    final response = await http.delete(
      url,
      headers: {
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('${response.body}');
      throw Exception("Failed to delete training!");
    }
  }

  Future<String> deleteEducation(String eId) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/profile/education/$eId');
    final response = await http.delete(
      url,
      headers: {
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('${response.body}');
      throw Exception("Failed to delete education!");
    }
  }
  
}
