import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/helpers/navigation-helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((value) => NavigationHelper.login(context));
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(64.0),
        width: width,
        height: height,
        child: Image.asset(
          'assets/images/guardian.png',
          height: height / 4.0,
          width: height / 4.0,
        ),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.teal,
              Color(0xFF44758D),
              Color(0xFF205A72),
              Color(0xFF1A475B),
            ],
          ),
        ),
      ),
    );
  }
}
