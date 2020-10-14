import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';

class SendOtpDialog extends StatefulWidget {

  @override
  _SendOtpState createState() => _SendOtpState();

}

class _SendOtpState extends State<SendOtpDialog> {
  bool  btnVisibility = false;
  String otpLabel = 'Sending';

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((value) {
      setState(() {
        otpLabel = 'Sent';
        btnVisibility = true;
      });
    });
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(context)  => Container(
    padding: EdgeInsets.all(32.0),
    width: 344.0,
    height: 406.0,
    decoration: BoxDecoration(
      color: dialogColor,
      borderRadius: BorderRadius.circular(20.0)
    ),
    child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Icon(
                Icons.smartphone,
                size: 110.0,
                color: colorPrimary,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/key.svg',
                  height: 24.0,
                  width: 24.0,
                  fit: BoxFit.fitWidth,
                  color: colorPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          'One-Time PIN',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          otpLabel,
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        Text(
          'Don\'t SHARE the PIN to anyone.',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        Stack(
          children: <Widget>[
            Visibility(
              visible: !btnVisibility,
              child: Container(
                width: 56.0,
                height: 56.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Visibility(
              visible: btnVisibility,
              child: Container(
                height: 46.0,
                width: 224.0,
                child: RaisedButton(
                  elevation: 4.0,
                  child:
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: dialogBtnColor,
                  splashColor: Colors.grey.shade500,
                  onPressed: () {
                    NavigationHelper.navigateToHome(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

}
