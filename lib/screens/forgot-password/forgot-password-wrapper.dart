import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/dialogs/dialog-send-otp.dart';
import '../../utils/loading.dart';
import '../../widgets/header.dart';
import '../../widgets/forgot-password/footer.dart';

class ForgotPasswordWrapper extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordWrapper> {
  bool _isLoading = false;
  String _view = 'email';
  String _email = '';
  String _otp = '';
  String _newPass = '';
  String _cnfrmPass = '';
  String _name = '';
  String _number;
  int _time = 300;
  Timer _timer;
  String _errorText = null;
  String _pin;

  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _otpController = TextEditingController(text: '');
  TextEditingController _passController = TextEditingController(text: '');
  TextEditingController _newPassController = TextEditingController(text: '');

  final _formPageKey = GlobalKey<FormState>();

  toggleView(String v) {
    _mockCheckForSession().then((_) {
      setState(() {
        _isLoading = !_isLoading;
        _view = v;
      });
    });
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer t) {
        if(_time == 0) {
          setState(() {
            _timer.cancel();
          });
        } else {
          setState(() {
            _time--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return _isLoading ?
    Loading() :
    Scaffold(
      body: Form(
        key: _formPageKey,
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            color: colorPrimary,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      header(88.0, 48.0),
                      SizedBox(
                        height: 16.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 72.0,
                        ),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: colorPrimary,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    _view == 'email'
                                        ? FaIcon(
                                            FontAwesomeIcons.envelope,
                                            size: 16.0,
                                            color: Colors.black,
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.key,
                                            size: 16.0,
                                            color: Colors.black,
                                          ),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(_view == 'email' ?
                                        'Enter your email address for '
                                          'verification.' : _view == 'otp' ?
                                        'You will receive a One-Time Pin '
                                          '(OTP) on your registered mobile '
                                          'number.' :
                                        'Please enter a new password that is '
                                          'not less than 8 characters in '
                                          'length.',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                _view == 'email' ?
                                TextFormField(
                                  key: Key('email'),
                                  validator: (value) => value.isEmpty
                                      ? 'Please enter Email'
                                      : EmailValidator.validate(value)
                                      ? null
                                      : 'Please enter a valid email',
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _emailController,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: colorPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4.0,),
                                      ),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: colorPrimary,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4.0,),
                                      ),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4.0,),
                                      ),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: colorPrimary,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4.0,),
                                      ),
                                      borderSide: BorderSide(width: 1,),
                                    ),
                                    hintText: 'Input Email here',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    errorText: _errorText,
                                    errorStyle: TextStyle(
                                      letterSpacing: 1.5,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  onSaved: (String val) => _email = val,
                                ) : _view == 'otp' ?
                                Column(
                                  children: [
                                    TextFormField(
                                      key: Key('otp'),
                                      textAlign: TextAlign.center,
                                      validator: (value) => value.isEmpty
                                          ? 'Please enter OTP' : _pin != value
                                          ? 'OTP does not match' : null,
                                      autovalidateMode: AutovalidateMode
                                          .onUserInteraction,
                                      controller: _otpController,
                                      obscureText: true,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: colorPrimary,
                                        letterSpacing: 4.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets
                                            .fromLTRB(16.0, 0.0, 16.0, 0.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'XXXXXX',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          letterSpacing: 4.0,
                                        ),
                                        labelText: 'OTP',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 2.0,
                                        ),
                                        counterText: '',
                                        // errorText: _validateUsername ? _usernameErrorMsg : null,
                                        errorStyle: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 10.0,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(width: 1,),
                                        ),
                                      ),
                                      onSaved: (String val) => _otp = val,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      'Did you receive and OTP?',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    _time == 0 ?
                                    FlatButton(
                                      child: Text(
                                        'Resend OTP',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        textColor: Colors.grey.shade800,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                        ),
                                        color: Colors.grey,
                                        splashColor: Colors.grey.shade500,
                                        onPressed: () {
                                          // TODO : Reset timer and send new otp
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          _sendOtp().then((value) {
                                            print('resend otp x $value x $_pin');
                                            setState(() {
                                              _pin = value;
                                              _isLoading = false;
                                              _timer.cancel();
                                              _timer = null;
                                              _time = 300;
                                              _startTimer();
                                            });
                                          });
                                        },
                                    ) :
                                    Text(
                                      'Resend OTP after $_time seconds',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Text(
                                      'If you need to change your mobile number. You may do so through Update Profile or by reaching out to your Operation Center Administrator at admin@guardian.ph',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ) :
                                Column(
                                  children: [
                                    TextFormField(
                                      key: Key('newPass'),
                                      validator: (value) => value.isEmpty
                                          ? 'Please enter new Password'
                                          : value.length < 8
                                          ? 'Password must not be less than 8 characters'
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _passController,
                                      obscureText: true,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: colorPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(width: 1,),
                                        ),
                                        hintText: 'Input new Password here',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        // errorText: _validateUsername ? _usernameErrorMsg : null,
                                        errorStyle: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      onSaved: (String val) => _newPass = val,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      key: Key('confirmPass'),
                                      validator: (value) => value.isEmpty
                                          ? 'Please confirm Password'
                                          : _passController.text != value
                                          ? 'Passwords do not match'
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _newPassController,
                                      obscureText: true,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: colorPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets
                                            .fromLTRB(16.0, 0.0, 16.0, 0.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: colorPrimary,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0,),
                                          ),
                                          borderSide: BorderSide(width: 1,),
                                        ),
                                        hintText: 'Please confirm Password',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        // errorText: _validateUsername ? _usernameErrorMsg : null,
                                        errorStyle: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      onSaved: (String val) => _cnfrmPass = val,
                                    )
                                  ]
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                FlatButton(
                                  child: Text(_view == 'email' ?
                                    'Send OTP' : _view == 'otp' ?
                                    'Proceed' :
                                    'Change Password',
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
                                    if (_formPageKey.currentState.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _formPageKey.currentState.save();
                                      switch (_view) {
                                        case 'otp':
                                          {
                                            toggleView('change');
                                          }
                                          break;
                                        case 'change':
                                          {
                                            // toggleView('email');
                                            // TODO: change password then proceed to login.
                                            _changePass().then((value) {
                                              var result = jsonDecode(value);
                                              String token = result['token'];
                                              if (token != null) {
                                                Navigator.pop(context);
                                              }
                                            });
                                          }
                                          break;
                                        default:
                                          {
                                            _forgotPass().then((value) {
                                              try {
                                                var result = jsonDecode(value);
                                                _name = result['name'];
                                                _number = result['number'];
                                                // toggleView('otp');
                                                var err = result['errors'];
                                                if (_name == '' || _name == null) {
                                                  setState(() {
                                                    _isLoading = !_isLoading;
                                                    _errorText = 'User does not exists';
                                                  });
                                                } else /*if (err.length != 0) */{
                                                  _sendOtp().then((value) {
                                                    setState(() {
                                                      print('$_name x dri pud? x $_pin x $value');
                                                      _isLoading = !_isLoading;
                                                      _view = 'otp';
                                                      _pin = value;
                                                    });
                                                    _startTimer();
                                                  });
                                                }/* else {
                                                }*/
                                              } catch (e) {
                                                /*try {
                                                  _emailController.text = 'User does not exists';
                                                } catch (f) {
                                                  _emailController.text = 'Server Error';
                                                }*/
                                              }
                                            });
                                          }
                                          break;
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                forgotPasswordFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _forgotPass() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/auth/forgot');
    Map data = {'email': _email};
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
      body: reqBody,
    );
    print('forgotPass r: $response X ${response.body}');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return response.body;
  }

  Future<String> _sendOtp() async {
    _pin = '${100000 + Random().nextInt(999999 - 100000)}';
    var url = Uri.parse('$secretHollowsEndPoint/api/sms/sendOtp');
    Map data = {'number': _number, 'msg': 'Hi $_name, Proceed with your Change Password for GUARDIAN Account, Your One-Time PIN is $_pin. OTP will expire 15 minutes. If you did not initiate this request, please call your Operation Center Administrator.'};
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
      body: reqBody,
    );
    print('sendOtp r: $response X ${response.body} X $_pin');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return _pin;
  }

  Future<String> _changePass() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/sms/changepassword');
    Map data = {'number': _number, 'password': _newPass};
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
      body: reqBody,
    );
    print('changePass r: $response X ${response.body}');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return response.body;
  }
}
