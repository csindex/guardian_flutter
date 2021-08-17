import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './constants/utils.dart';

class SmallLoading extends StatefulWidget {
  final String txt;
  final bool showTxt;

  SmallLoading({this.txt, this.showTxt});

  @override
  _SmallLoadingState createState() => _SmallLoadingState();
}

class _SmallLoadingState extends State<SmallLoading> {
  @override
  Widget build(BuildContext context) {
    print('small loading build');
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final w = size.width;
    final h = size.height;
    final o = mq.orientation;
    print('w x h - ${w / 2} x ${h / 2}');
    return o == Orientation.portrait ? _buildLayout(h / 2) : _buildLayout(w / 2);
  }

  _buildLayout(double w) => Container(
    width: w,
    height: w,
    decoration: BoxDecoration(
      color: colorPrimary1,
      borderRadius: BorderRadius.circular(16.0,),
    ),
    child: Stack(
      children: [
        /*Positioned(
          top: -100,
          child: Container(
            child: Image.asset(
              'assets/images/guardian.png',
              height: 156.0,
              width: 156.0,
            ),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.teal,
                  Color(0xFF44758D),
                  Color(0xFF205A72),
                  colorPrimary,
                ],
              ),
            ),
          ),
        ),*/
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.txt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            if (!widget.showTxt) ... [
              vSpacer(h: 16.0),
              SpinKitChasingDots(
                color: Colors.white,
                size: 64.0,
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
