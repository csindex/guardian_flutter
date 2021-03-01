import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';

class CreateAccountDialog extends StatelessWidget {
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

  _buildChild(context) => Container(
        padding: EdgeInsets.all(16.0),
        width: 334.0,
        height: 370.0,
        decoration: BoxDecoration(
            color: dialogColor, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Material(
                      // button color
                      color: dialogColor,
                      child: InkWell(
                        splashColor: Colors.grey.shade500, // inkwell color
                        child: SizedBox(
                          width: 48.0,
                          height: 48.0,
                          child: Icon(
                            Icons.arrow_back,
                            color: colorPrimary,
                            size: 40.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/guardian.png',
              height: 88.0,
              width: 90.0,
              fit: BoxFit.fitWidth,
            ),
            Text(
              'Account does not exist.',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: 42.0,
            ),
            Container(
              height: 46.0,
              width: 224.0,
              child: RaisedButton(
                elevation: 4.0,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/edit-3.svg',
                      color: colorPrimary,
                      height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: dialogBtnColor,
                splashColor: Colors.grey.shade500,
                onPressed: () {
                  NavigationHelper.createAccount(context);
                },
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              height: 46.0,
              width: 224.0,
              child: RaisedButton(
                elevation: 4.0,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/key.svg',
                      color: colorPrimary,
                      height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: dialogBtnColor,
                splashColor: Colors.grey.shade500,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
}
