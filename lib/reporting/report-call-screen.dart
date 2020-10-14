import 'package:GUARDIAN/utils/constants/utils.dart';
import 'package:flutter/material.dart';

class ReportCallScreen extends StatefulWidget {

  @override
  _ReportCallScreenState createState() => _ReportCallScreenState();

}

class _ReportCallScreenState extends State<ReportCallScreen> {

  String callStatus = '';
  bool btnVisibility = false;
  bool videoBtnVisibility = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      color: colorPrimary,
      height: h,
      width: w,
      child: Stack(
        children: <Widget>[
          Container(
            height: h,
            width: w,
            child: Image.asset(
              'assets/images/saber-squad.jpg',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: w,
            height: h,
            color: colorPrimary,
            child: Container(
              margin: EdgeInsets.only(bottom: 56.0),
              padding: EdgeInsets.all(36.0),
              width: w * 0.6,
              height: h * 0.28,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/guardian.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            'Incoming call'
          ),
        ],
      ),
    );
  }

}
