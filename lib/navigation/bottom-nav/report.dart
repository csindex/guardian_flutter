import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/utils.dart';

class Report extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 48.0,
                backgroundColor: colorPrimary,
                child: CircleAvatar(
                  radius: 44.0,
                  backgroundImage: AssetImage(
                    'assets/images/chibi-lelouch.jpg',
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Volunteer',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: colorPrimary,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Mandaue City',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(
                fontSize: 24.0,
                color: colorPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Incident Details?',
                hintStyle: TextStyle(
                  color: Color(0xAA205A72),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/alert-octagon.svg',
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                'Incident Type',
                style: TextStyle(
                  fontSize: 16.0,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
          child: Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.car,
                size: 20.0,
                color: colorPrimary,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                'Need/Request',
                style: TextStyle(
                  fontSize: 16.0,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/image.svg',
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                'Photo/Video',
                style: TextStyle(
                  fontSize: 16.0,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/map-pin.svg',
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 16.0,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/calendar.svg',
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                'Date/Time',
                style: TextStyle(
                  fontSize: 16.0,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey.shade500,
        ),
      ],
    );
  }
}
