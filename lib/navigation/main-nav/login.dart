import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/helpers/dialog-helper.dart';
import '../../widgets/header.dart';
import '../../widgets/login/footer.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _obscureText = true;

  String _username;
  String _password;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String _deviceID = 'Unknown';

  // Future<void> _mockCheckForSession() async {
  //   await Future.delayed(Duration(milliseconds: 3500), () {});
  // }

  Future<void> initPlatformState() async {
    String deviceID = '';
    try {
      if (Platform.isAndroid) {
        deviceID = _readAndroidDeviceID(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceID = _readIOSDeviceID(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceID = 'Failed to get Device ID';
    }
    if (!mounted) return;
    setState(() {
      _deviceID = deviceID;
      // print('$deviceID x $macAddress');
    });
  }

  String _readAndroidDeviceID(AndroidDeviceInfo build) {
    return build.androidId;
  }

  String _readIOSDeviceID(IosDeviceInfo data) {
    return data.identifierForVendor;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation mQOrientation = MediaQuery.of(context).orientation;
    print('Width: $width');
    print('Height: $height');
    print('Orientation: $mQOrientation');
    print('DeviceID: $_deviceID');
    return Scaffold(
      key: _pageKey,
      body: Form(
        key: _formPageKey,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return mQOrientation == Orientation.portrait
                ? _buildVerticalLayout(width, height)
                : _buildHorizontalLayout(width, height);
          },
        ),
      ),
    );
  }

  Widget _buildVerticalLayout(double w, double h) => SingleChildScrollView(
        child: Container(
          height: h,
          color: colorPrimary,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: 32.0,
                      // ),
                      header(88.0, 48.0),
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        'Welcome Volunteer!',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      _usernamePasswordField(),
                      SizedBox(
                        height: 16.0,
                      ),
                      _isLoading ?
                      Container(
                        width: 48.0,
                        height: 48.0,
                        margin: EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ) :
                      Container(
                        width: w,
                        height: 48.0,
                        margin: EdgeInsets.only(
                            top: 8.0, left: 64.0, right: 64.0),
                        child: FlatButton(
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
                            FocusScope.of(context).unfocus();
                            // WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                            // SystemChannels.textInput.invokeMethod('TextInput.hide');
                            if (_formPageKey.currentState.validate()) {
                              setState(() => _isLoading = true);
                              _formPageKey.currentState.save();
                              // _mockCheckForSession().then((value) {
                              //   setState(() => _isLoading = false);
                              //   NavigationHelper.navigateToHome(context);
                              // });
                              // }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loginFooter(context),
            ],
          ),
        ),
      );

  Widget _buildHorizontalLayout(double w, double h) =>
      SingleChildScrollView(
        child: Container(
          height: h,
          width: w,
          color: colorPrimary,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    header(88.0, 48.0),
                    SizedBox(
                      height: 64.0,
                    ),
                    loginFooter(context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Volunteer!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    _usernamePasswordField(),
                    SizedBox(
                      height: 16.0,
                    ),
                    _isLoading
                        ? Container(
                            width: 48.0,
                            height: 48.0,
                            margin: EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Container(
                            width: w,
                            height: 48.0,
                            margin: EdgeInsets.only(
                                top: 8.0, left: 64.0, right: 64.0),
                            child: FlatButton(
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
                                FocusScope.of(context).unfocus();
                                if (_formPageKey.currentState.validate()) {
                                  setState(() {
                                    return _isLoading = true;
                                  });
                                  _formPageKey.currentState.save();
                                  // _mockCheckForSession().then((value) {
                                  //   setState(() => _isLoading = false);
                                  //   NavigationHelper.navigateToHome(context);
                                  // });
                                  // }
                                }
                              },
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _usernameField() =>
      TextFormField(
        key: Key('username'),
        validator: (value) =>
            value.isEmpty ? 'Please enter Email or Mobile Number' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _usernameController,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          filled: true,
          fillColor: colorPrimary,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                width: 1,
              )),
          hintText: 'Input Email or Mobile Number here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: 'Email / Mobile Number',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: _validateUsername ? _usernameErrorMsg : null,
          errorStyle: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10.0,
          ),
        ),
        onSaved: (String val) => _username = val,
      );

  Widget _passwordField() =>
      TextFormField(
        key: Key('password'),
        validator: (value) => value.isEmpty
            ? 'Please enter Password'
            : value.length < 8
                ? 'Password must be not less than 8 characters'
                : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _passwordController,
        obscureText: _obscureText,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
          filled: true,
          fillColor: colorPrimary,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                width: 1,
              ),
          ),
          hintText: 'Input Password here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: _validatePassword ? _passwordErrorMsg : null,
          errorStyle: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10.0,
          ),
          suffixIcon: InkWell(
            onTap: _togglePassword,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ),
        onSaved: (String val) {
          _password = val;
          _login();
        },
      );

  Widget _usernamePasswordField() =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            _usernameField(),
            SizedBox(
              height: 16.0,
            ),
            _passwordField(),
          ],
        ),
      );

  void _login() {
    try {
      // TODO: Login
      _loginAPI2().then((value) {
        setState(() {
          _isLoading = false;
          // if (value) {
          //   NavigationHelper.navigateToHome(context);
          // } else {
          //   _pageKey.currentState.showSnackBar(
          //       SnackBar(content: Text('Failed to Log-in'))
          //   );
          //   DialogHelper.login(context);
          // }
          var result = jsonDecode(value);
          String token = result['token'];
          if (token != null) {
            NavigationHelper.navigateToHome(context, token);
          } else {
            var errorMsgs = jsonDecode(value)['errors'] as List;
            String errorMsg = errorMsgs
                .map((errorMsg) => Error.fromJson(errorMsg))
                .toList()[0]
                .errorMsg;
            _pageKey.currentState
                .showSnackBar(SnackBar(content: Text(errorMsg)));
            DialogHelper.login(context);
          }
        });
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Log-in')));
    }
  }

  Future<bool> _loginAPI() async {
    var url = 'https://ccc.guardian4emergency.com/mobile/login';
    var response = await http.post(
      url,
      body: {
        'username': _username,
        'password': _password,
        'imei': _deviceID,
        'fcm_token': '$_deviceID$_deviceID',
      },
    );
    print('response: $response');
    final body = jsonDecode(response.body);
    return body["success"];
  }

  Future<String> _loginAPI2() async {
    var url = '$secretHollowsEndPoint/api/auth';
    Map data = {'email': _username, 'password': _password};
    var reqBody = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        // 'Cache-Control' : 'no-cache',
        // 'Postman-Token' : '<calculated when request is sent>',
        // 'Content-Length' : '<calculated when request is sent>',
        // 'Host' : '<calculated when request is sent>',
        // 'Accept' : '*/*',
        // 'Accept-Encoding' : 'gzip, deflate, br',
        // 'Connection' : 'keep-alive',
        'Content-Type': 'application/json',
      },
      body:
          reqBody /*{
        'email': _username,
        'password': _password,
        // 'imei': _deviceID,
        // 'fcm_token': '$_deviceID$_deviceID',
      }*/
      ,
    );
    print('response: $response X ${response.body}');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return response.body;
  }
}

class Error {
  String errorMsg;

  Error(this.errorMsg);

  factory Error.fromJson(dynamic json) => Error(json['msg'] as String);

  // @override
  // String toString() =>

}
