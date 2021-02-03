import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants/utils.dart';

class ProfileHeader extends StatelessWidget {
  final String name;

  ProfileHeader({this.name});

  @override
  Widget build(BuildContext context) {
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
                  'Welcome $name',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
