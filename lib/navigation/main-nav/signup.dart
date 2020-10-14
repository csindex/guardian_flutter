import 'package:GUARDIAN/utils/constants/utils.dart';
import 'package:GUARDIAN/utils/helpers/dialog-helper.dart';
import 'package:GUARDIAN/utils/helpers/navigation-helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
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
                        fontSize: 28.0,
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
                  height: 32.0,
                ),
                Text('Welcome Volunteer!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 340.0,
                      height: 46.0,
                      margin: EdgeInsets.only(top: 8.0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: Image.asset(
                                'assets/images/fb-logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              'CONNECT WITH FACEBOOK',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        color: fbBtnColor,
                        splashColor: Colors.grey.shade500,
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      width: 340.0,
                      height: 46.0,
                      margin: EdgeInsets.only(top: 8.0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/google-logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              'CONNECT WITH GOOGLE',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        color: Colors.white,
                        splashColor: Colors.grey.shade500,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28.0,
                      height: 1.0,
                      color: Colors.white,
                    ),
                    Text(
                      '   or   ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 28.0,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.0,
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
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
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
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
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
//                      errorText: 'Incorrect password',
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: 340.0,
                  height: 46.0,
                  margin: EdgeInsets.only(top: 8.0),
                  child: FlatButton(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    color: Color(0xFF30607A),
                    splashColor: Colors.grey.shade500,
                    onPressed: () {
                      DialogHelper.createAccount(context);
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    NavigationHelper.login(context);
                  },
                  child: Text('Log-in',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text('Forgot Password?',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Text('Use Policy',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      height: 16.0,
                      width: 1.0,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      height: 16.0,
                      width: 1.0,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Text('Terms of Use',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
