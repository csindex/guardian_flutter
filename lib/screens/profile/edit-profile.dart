import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';

class EditProfile extends StatefulWidget {
  final String token;
  final UserProfileViewModel userVM;
  final Function refresh;
  final bool isUpdate;

  EditProfile({
    Key key,
    this.token,
    this.userVM,
    this.refresh,
    this.isUpdate
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formPageKey = GlobalKey<FormState>();

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'LGBT',
  ];

  final List<String> _civilStatusOptions = [
    'Single',
    'Married',
    'Widowed',
    'Separated',
  ];

  String _bio;
  String _gender;
  String _civilStatus;
  String _birthDate;
  String _homeAddress;
  double _lat = 0.0;
  double _lng = 0.0;

  bool _isLoading = false;

  TextEditingController _schoolController;
  TextEditingController _degreeController;
  TextEditingController _fieldController;
  TextEditingController _descController;

  // Future<String> addEducation() async {
  //   print('$_school - $_degree - $_field - $_dateFrom - $_isCurrent - $_dateTo - $_desc');
  //   final url = "$secretHollowsEndPoint/api/profile/education";
  //   Map data = {
  //     'school' : _school,
  //     'degree' : _degree,
  //     'fieldofstudy' : _field,
  //     'from' : _dateFrom,
  //     'to' : _dateTo,
  //     'current' : '$_isCurrent',
  //     'description' : _desc,
  //   };
  //   print('data - $data');
  //   var reqBody = jsonEncode(data);
  //   final response = await http.put(
  //     url,
  //     headers: {
  //       'Cache-Control' : 'no-cache',
  //       'Accept' : '*/*',
  //       'Accept-Encoding' : 'gzip, deflate, br',
  //       'Connection' : 'keep-alive',
  //       'Content-Type': 'application/json',
  //       'x-auth-token': widget.token,
  //     },
  //     body: reqBody,
  //   );
  //   print('add education - ${response.body}');
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     return 'failed';
  //   }
  // }

  Future<File> _file(String filename) async {
    Directory dir = await getExternalStorageDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: '');
    _degreeController = TextEditingController(text: '');
    _fieldController = TextEditingController(text: '');
    _descController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _displayBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16.0,),
                  ),
                  onPressed: () {
                    // if (userProfileVM == null || userProfileVM.gender == null) {
                    //   print('No Profile');
                    // } else {
                    //   print('unsa d i sulod? $userProfileVM X ${userProfileVM.gender}');
                    //   Navigator.pop(context);
                    //   NavigationHelper.openCameraScreen(context, token, userProfileVM);
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.camera,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Take a Photo',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16.0,),
                  ),
                  onPressed: () {
                    // if (userProfileVM == null || userProfileVM.gender == null) {
                    //   print('No Profile');
                    // } else {
                    //   print('unsa d i sulod? $userProfileVM X ${userProfileVM.gender}');
                    //   Navigator.pop(context);
                    //   NavigationHelper.openCameraScreen(context, token, userProfileVM);
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidImage,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Select a Photo',
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
          );
        },
      );
    }

    return _isLoading ? Loading() : (widget.userVM == null
        || widget.userVM.profilePic == null
        || widget.userVM.profilePic.contains('null')) ? FutureBuilder<File>(
      future: _file('defaultProfPic.png'),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        Widget w;
        if (snapshot.hasData) {
          print('Ikaw pala ${snapshot.data}');
          w = Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: SafeArea(
              child: Form(
                key: _formPageKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            '${(widget.isUpdate ? 'Update' : 'Create')} Your Profile',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        _header,
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          '* = required field',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _displayBottomSheet,
                                child: CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 79.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkToFileImage(
                                      url: '$secretHollowsEndPoint/img/Spotter.png',
                                      file: snapshot.data,
                                      debug: true,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.transparent, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey.shade500, // inkwell color
                                      child: SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: colorPrimary,
                                        ),
                                      ),
                                      onTap: _displayBottomSheet,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
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
    ) : Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      '${(widget.isUpdate ? 'Update' : 'Create')} Your Profile',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _header,
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '* = required field',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _header
  => Row(
    children: [
      FaIcon(
        FontAwesomeIcons.solidUser,
        size: 16.0,
        color: Colors.black,
      ),
      SizedBox(
        width: 8.0,
      ),
      Flexible(
        child: Text(
          '${(widget.isUpdate ? 'Update' : 'Let\'s get some')} '
              'information to make your profile stand out.',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );
}
