import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  final double width;
  final double height;
  SplashScreen({this.width, this.height});

  @override
  Widget build(BuildContext context) {
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
