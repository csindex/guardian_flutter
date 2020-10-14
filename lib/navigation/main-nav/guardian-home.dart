import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bottom-nav/home.dart';
import '../bottom-nav/report.dart';
import '../bottom-nav/special.dart';
import '../../utils/constants/utils.dart';

class GuardianHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GuardianHomeState();

}

class _GuardianHomeState extends State<GuardianHome> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    Container(),
    Report(),
    Special(androidFusedLocation: true),
  ];
  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: appBar[_currentIndex],
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
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
              title: Text(
                'HOME',
                style: TextStyle(
                  fontSize: 10.0,
  //                color: Colors.grey
                ),
              ),
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
              title: Text(
                'SCAN',
                style: TextStyle(
                  fontSize: 10.0,
  //                color: Colors.grey
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                height: 36.0,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
              title: Text(
                'SEND REPORT',
                style: TextStyle(
                  fontSize: 10.0,
  //                color: Colors.grey
                ),
              ),
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
              title: Text(
                'EMERGENCY CALL',
                style: TextStyle(
                  fontSize: 10.0,
  //                  color: Colors.grey
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
