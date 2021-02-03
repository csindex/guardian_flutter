import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:get_mac/get_mac.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/helpers/fb-authentication-helper.dart';
import '../../utils/dialogs/dialog-send-otp.dart';
import '../../widgets/header.dart';
import '../../widgets/create-account/footer.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String _deviceID = 'Unknown';
  String _macAddress = 'Unknown';

  GoogleSignInAccount _currentUser;
  String _contactText;

  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _mobileNumberController;
  TextEditingController _otpController;
  TextEditingController _passwordController;

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _isRegCodeSent = false;

  String _fullName;
  String _email;
  String _mobileNumber;
  String _password;
  String _regCode = '';

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact();
      // }
    });
    _googleSignIn.signInSilently();
    _fullNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _mobileNumberController = TextEditingController(text: '');
    _otpController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  /*Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }*/

  Future<void> _handleSignIn() async {
    try {
      var response = await _googleSignIn.signIn();
      print('resp: $response');
      print('body: ${response.displayName}');
      if (response.displayName != '' || response.displayName != null) {
        NavigationHelper.navigateToHome(context, '');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _initPlatformState() async {
    String deviceID = '';
    String macAddress;
    try {
      if (Platform.isAndroid) {
        deviceID = _readAndroidDeviceID(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceID = _readIOSDeviceID(await deviceInfoPlugin.iosInfo);
      }
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      deviceID = 'Failed to get Device ID';
      macAddress = 'Failed to get Device MAC Address';
    }
    if (!mounted) return;
    setState(() {
      _deviceID = deviceID;
      _macAddress = macAddress;
      // print('$deviceID x $macAddress');
    });
  }

  String _readAndroidDeviceID(AndroidDeviceInfo build) {
    return build.androidId;
  }

  String _readIOSDeviceID(IosDeviceInfo data) {
    return data.identifierForVendor;
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _handleLoadingChanged(String code) {
    print('$code X ${code.length}');
    if (code.length == 4) {
      setState(() {
        _regCode = code;
        _isLoading = false;
        print('setState man $_isLoading');
        _isRegCodeSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation mQOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _pageKey,
      body: Form(
        key: _formPageKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return mQOrientation == Orientation.portrait
                ? height >= 900
                    ? _buildVerticalLayout(width, height)
                    : _buildVerticalLayout900(width, height)
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
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      header(88.0, 48.0),
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        _isRegCodeSent
                            ? 'Verify Mobile Number & Create Account'
                            : 'Create Account or Log-in with',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      _isRegCodeSent
                          ? _verifyMobileNumberField()
                          : Column(
                              children: [
                                _facebookButton(context, w),
                                SizedBox(
                                  height: 8.0,
                                ),
                                _googleButton(context, w),
                                SizedBox(
                                  height: 32.0,
                                ),
                                _buildOr(),
                                SizedBox(
                                  height: 32.0,
                                ),
                                _signUpFormField(),
                              ],
                            ),
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
                                  _isRegCodeSent
                                      ? 'Verify & Create Account'
                                      : 'Create Account',
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
                                  // TODO : Button
                                  if (_formPageKey.currentState.validate()) {
                                    setState(() => _isLoading = true);
                                    _formPageKey.currentState.save();
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              createAccountFooter(context),
            ],
          ),
        ),
      );

  Widget _buildVerticalLayout900(double w, double h) => SingleChildScrollView(
        child: _isRegCodeSent
            ? Container(
                height: h,
                color: colorPrimary,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            header(88.0, 48.0),
                            SizedBox(
                              height: 32.0,
                            ),
                            Text(
                              'Verify Mobile Number & Create Account',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 32.0,
                            ),
                            _verifyMobileNumberField(),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Container(
                                    width: w,
                                    height: 48.0,
                                    margin: EdgeInsets.only(
                                        top: 8.0, left: 64.0, right: 64.0),
                                    child: FlatButton(
                                      child: Text(
                                        'Verify & Create Account',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      color: btnColor1,
                                      splashColor: Colors.grey.shade500,
                                      onPressed: () {
                                        // TODO : Button
                                        if (_formPageKey.currentState
                                            .validate()) {
                                          setState(() => _isLoading = true);
                                          _formPageKey.currentState.save();
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    createAccountFooter(context),
                  ],
                ),
              )
            : Container(
                color: colorPrimary,
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 64.0),
                        header(88.0, 48.0),
                        SizedBox(
                          height: 32.0,
                        ),
                        Text(
                          'Create Account or Log-in with',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                        _facebookButton(context, w),
                        SizedBox(
                          height: 8.0,
                        ),
                        _googleButton(context, w),
                        SizedBox(
                          height: 32.0,
                        ),
                        _buildOr(),
                        SizedBox(
                          height: 32.0,
                        ),
                        _signUpFormField(),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Container(
                                width: w,
                                height: 48.0,
                                margin: EdgeInsets.only(
                                    top: 8.0, left: 64.0, right: 64.0),
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
                                  color: btnColor1,
                                  splashColor: Colors.grey.shade500,
                                  onPressed: () {
                                    // TODO : Button
                                    if (_formPageKey.currentState.validate()) {
                                      setState(() => _isLoading = true);
                                      _formPageKey.currentState.save();
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 64.0,
                    ),
                    createAccountFooter(context),
                  ],
                ),
              ),
      );

  Widget _buildHorizontalLayout(double w, double h) => SingleChildScrollView(
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
                      height: 16.0,
                    ),
                    _isRegCodeSent
                        ? SizedBox(
                            height: 64.0,
                          )
                        : Column(
                            children: [
                              Text(
                                'Create Account or Log-in with',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              _facebookButton(context, w),
                              SizedBox(
                                height: 8.0,
                              ),
                              _googleButton(context, w),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
                          ),
                    createAccountFooter(context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isRegCodeSent
                        ? Column(
                            children: [
                              Text(
                                'Verify Mobile Number & Create Account',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              _verifyMobileNumberField(),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildOr(),
                              SizedBox(
                                height: 32.0,
                              ),
                              _signUpFormField(),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
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
                                _isRegCodeSent
                                    ? 'Verify & Create Account'
                                    : 'Create Account',
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
                                // TODO : Button
                                if (_formPageKey.currentState.validate()) {
                                  _formPageKey.currentState.save();
                                }
                                /* else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }*/
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _horizontalLine() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        height: 1.0,
        width: 32.0,
        color: Colors.white,
      );

  Widget _buildOr() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _horizontalLine(),
          Text(
            'OR',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          _horizontalLine(),
        ],
      );

  Widget _facebookButton(BuildContext ctx, double w) => Container(
        width: w,
        height: 48.0,
        margin: EdgeInsets.only(top: 8.0, left: 64.0, right: 64.0),
        child: FlatButton(
          child: Row(
            children: [
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
          onPressed: () {
            FBAuthenticationHelper auth = FBAuthenticationHelper();
            auth.signInFB().then((value) {
              NavigationHelper.navigateToHome(ctx, '');
            });
          },
        ),
      );

  Widget _googleButton(BuildContext ctx, double w) => Container(
        width: w,
        height: 48.0,
        margin: EdgeInsets.only(left: 64.0, right: 64.0),
        child: FlatButton(
          child: Row(
            children: [
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
          onPressed: _handleSignIn,
        ),
      );

  Widget _fullNameField() => TextFormField(
        key: Key('fullname'),
        validator: (value) =>
            (value.isEmpty || value.replaceAll(' ', '').length == 0)
                ? 'Please enter Full Name'
                : null,
        controller: _fullNameController,
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
          hintText: 'Input Full Name here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: 'Full Name',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: _validateName ? _nameErrorMsg : null,
          errorStyle: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10.0,
          ),
        ),
        keyboardType: TextInputType.text,
        onSaved: (String val) => _fullName = val,
      );

  Widget _emailField() => TextFormField(
        key: Key('email'),
        validator: (value) =>
            (value.isEmpty || value.replaceAll(' ', '').length == 0)
                ? 'Please enter Email'
                : null,
        controller: _emailController,
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
          hintText: 'Input Email here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: _validateName ? _nameErrorMsg : null,
          errorStyle: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10.0,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (String val) => _email = val,
      );

  Widget _mobileNumberField() => TextFormField(
        key: Key('mobileNumber'),
        validator: (value) => value.isEmpty
            ? 'Please enter Mobile Number'
            : value.length < 11
                ? 'Mobile Number must not be less than 11 digits'
                : !(value.length == 11 && value.startsWith('09'))
                    ? 'Mobile Number is invalid PH mobile number'
                    : null,
        controller: _mobileNumberController,
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
          hintText: 'Input Mobile Number here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: 'Mobile Number',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: _validateMobileNumber ? _mobileNumberErrorMsg : null,
          errorStyle: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10.0,
          ),
          counterText: '',
          counterStyle: TextStyle(
            fontSize: 0,
          ),
        ),
        maxLength: 11,
        keyboardType: TextInputType.phone,
        onSaved: (String val) {
          _mobileNumber = val;
          _getRegCode();
        },
      );

  Widget _verifyMobileNumberField() => Container(
        margin: EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            TextFormField(
              key: Key('otp'),
              validator: (value) => value.isEmpty
                  ? 'Please enter One-Time Pin'
                  : value.length < 4
                      ? 'Please enter 4-digit One-Time Pin'
                      : value != _regCode
                          ? 'Invalid One-Time Pin'
                          : null,
              controller: _otpController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                hintText: 'Input One-Time Pin here',
                hintStyle: TextStyle(
                  color: Colors.white38,
                ),
                labelText: 'One-Time Pin',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                // errorText: _validateOtp ? _verifyMobileNumberErrorMsg : null,
                errorStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 10.0,
                ),
                counterText: '',
                counterStyle: TextStyle(
                  fontSize: 0.0,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              onSaved: (String val) => _verifyMobileNumber(),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Verify your mobile number for added security.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _passwordField() => TextFormField(
        key: Key('password'),
        validator: (value) => value.isEmpty
            ? 'Please enter Password'
            : value.length < 8
                ? 'Password must not be less than 8 characters'
                : null,
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
              )),
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
        onSaved: (String val) => _password = val,
      );

  Widget _signUpFormField() => Container(
        margin: EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            _fullNameField(),
            SizedBox(
              height: 8.0,
            ),
            _emailField(),
            SizedBox(
              height: 8.0,
            ),
            _mobileNumberField(),
            SizedBox(
              height: 8.0,
            ),
            _passwordField(),
          ],
        ),
      );

  void _getRegCode() {
    try {
      setState(() => _isLoading = true);
      showDialog(
          context: context,
          builder: (context) => SendOtpDialog(
                registrationCode: _regCode,
                mobileNumber: _mobileNumber,
                onLoadingChanged: _handleLoadingChanged,
              ));
    } catch (e) {
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Create Account')));
    }
  }

  void _verifyMobileNumber() {
    try {
      setState(() {
        _isLoading = true;
        _isRegCodeSent = false;
        _createAccount();
      });
    } catch (e) {
      print('catch');
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Create Account')));
    }
  }

  void _createAccount() {
    try {
      // TODO: Create Account
      _createAccountAPI2().then((value) {
        setState(() {
          _isLoading = false;
          // if (value) {
          //   NavigationHelper.login(context);
          // } else {
          //   _pageKey.currentState.showSnackBar(
          //       SnackBar(content: Text('Failed to Create Account'))
          //   );
          // }
          var result = jsonDecode(value);
          String token = result['token'];
          if (token != null) {
            NavigationHelper.login(context);
          } else {
            var errorMsgs = jsonDecode(value)['errors'] as List;
            String errorMsg = errorMsgs
                .map((errorMsg) => Error.fromJson(errorMsg))
                .toList()[0]
                .errorMsg;
            _pageKey.currentState
                .showSnackBar(SnackBar(content: Text(errorMsg)));
          }
        });
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Create Account')));
    }
  }

  Future<bool> _createAccountAPI() async {
    var url = 'https://ccc.guardian4emergency.com/mobile/register';
    var response = await http.post(
      url,
      body: {
        'firstname': _fullName,
        'lastname': '',
        'password': _password,
        'imei': _deviceID,
        'macaddress': _macAddress,
        'commandcenter_id': '5',
        'mobile': _mobileNumber
      },
    );
    print('response: ${response.body}');
    final body = jsonDecode(response.body);
    return body["success"];
  }

  Future<String> _createAccountAPI2() async {
    var url = 'https://secret-hollows-28950.herokuapp.com/api/users';
    Map data = {
      'name': _fullName,
      'email': _email,
      'number': _mobileNumber,
      'password': _password
    };
    var reqBody = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: reqBody,
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
