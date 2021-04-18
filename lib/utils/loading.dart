import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './constants/utils.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorPrimary,
      child: Stack(
        children: [
          Center(
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
          ),
          Center(
            child: SpinKitChasingDots(
              color: colorPrimary,
              size: 64.0,
            ),
          ),
        ],
      ),
    );
  }
}
