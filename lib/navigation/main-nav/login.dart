import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

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
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                          filled: true,
                          fillColor: colorPrimary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(width: 1,color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                          hintText: 'Input Email or Mobile Number here',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                          ),
                          labelText: 'Email / Mobile Number',
                          labelStyle: TextStyle(
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
                        controller: _passwordController,
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
                          hintText: 'Input Password here',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Container(
                  width: 340.0,
                  height: 46.0,
                  margin: EdgeInsets.only(top: 8.0),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : FlatButton(
                    child: Text(
                      'Log-in',
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
                      setState(() => _isLoading = true);
                      // DialogHelper.login(context);
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
                    NavigationHelper.createAccount(context);
                  },
                  child: Text('Create Account',
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
                      onTap: () {
                        _launchURL(context, 'https://guardian4emergency.com/legal');},
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
                      onTap: () {
                        _launchURL(context, 'https://guardian4emergency.com/legal');
                      },
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
                        _launchURL(context, 'https://guardian4emergency.com/legal');
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

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
          ),
          extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

}
