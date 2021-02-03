import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants/utils.dart';
import '../../provider/user/viewmodel-user.dart';

class ProfileDashboard extends StatefulWidget {
  final String token;
  final UserViewModel vm;

  ProfileDashboard({this.token, this.vm});

  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  final List<String> responderStatus = [
    'Emergency Dispatch Operator',
    'Emergency Medical Service',
    'Firefighter',
    'Police Officer',
    'Military',
    'Quick Response',
    'Traffic Enforcer',
    'LGU Frontliner',
    'Volunteer',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    print('token- ${widget.token}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 32.0,
            top: 16.0,
          ),
          child: Text(
            'Profile Dashboard',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: colorPrimary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidUser,
                size: 14.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 8.0,
              ),
              Flexible(
                child: Text(
                  'Welcome ${widget.vm.name}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: Text(
            'You have not yet added a profile, please add your information.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: FlatButton(
            color: colorPrimary1,
            onPressed: () {},
            child: Text(
              'Create Profile',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
