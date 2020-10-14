import 'package:GUARDIAN/utils/constants/utils.dart';
import 'package:GUARDIAN/utils/helpers/dialog-helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class VerifyOtp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.fromLTRB(48.0, 48.0, 48.0, 32.0),
        color: colorPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 32.0,
            ),
            Image.asset(
              'assets/images/guardian.png',
              height: 48.0,
              width: 88.0,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 16.0,
            ),
            Column(
              children: <Widget>[
                Text('GUARDIAN',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.5,
                  ),
                ),
                Text('Emergency Response',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    wordSpacing: 4.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 152.0,
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 340.0,
                  height: 46.0,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                      filled: true,
                      fillColor: colorPrimary,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,)
                      ),
//                      errorBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(4)),
//                          borderSide: BorderSide(width: 1,color: Colors.red.shade900)
//                      ),
//                      focusedErrorBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(4)),
//                          borderSide: BorderSide(width: 1,color: Colors.red)
//                      ),
//                      errorText: 'Invalid mobile number',
                      hintText: 'One-Time PIN',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Verify your phone number for added security.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 96.0,
            ),
            Container(
              width: 340.0,
              height: 46.0,
              margin: EdgeInsets.only(top: 8.0),
              child: FlatButton(
                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: btnColor1,
                splashColor: Colors.grey.shade500,
                onPressed: () {
                  DialogHelper.login(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
