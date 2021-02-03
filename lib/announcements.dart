import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Announcements extends StatelessWidget {
  final List<String> _images = [
    'assets/images/saber-squad.jpg',
    'assets/images/royal-squad.jpg',
    'assets/images/lightborn-squad.jpg',
    'assets/images/venom-squad.jpg',
    'assets/images/fiery-squad.jpg',
  ];

  final List<String> _title = [
    'S.A.B.E.R. Squad',
    'Royal Squad',
    'Light-born Squad',
    'V.E.N.O.M. Squad',
    'Fiery Hell-fire Squad',
  ];

  final double _height;

  Announcements(this._height);

  Widget _createSampleAnnouncement() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(_images[Random().nextInt(5)]),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0),
              child: CircleAvatar(
                radius: 16.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage:
                      AssetImage('assets/images/guardian-colored-primary.png'),
                ),
              ),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 4.0,
            color: Colors.grey,
          ),
          Container(
            height: _height - 4.0,
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
                _createSampleAnnouncement(),
              ],
            ),
          ),
        ],
      );
}
