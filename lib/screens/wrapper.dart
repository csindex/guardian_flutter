import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../navigation/main-nav/splash-screen.dart';
import '../screens/authenticate/login.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();

}

class _WrapperState extends State<Wrapper> {
  bool isSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _mockCheckForSession().then((_) => setState (() => isSplashScreen = false));
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return isSplashScreen ?
    SplashScreen(width: _width, height: _height) : Login();
  }
}