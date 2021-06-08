import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/dialogs/dialog-send-otp.dart';
import '../../widgets/header.dart';
import '../../widgets/forgot-password/footer.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _mobileNumberController;
  TextEditingController _otpController;
  TextEditingController _newPasswordController;
  TextEditingController _confirmPasswordController;

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _isMobileNumberVerified = false;
  bool _isRegCodeSent = false;

  String _mobileNumber;
  String _newPassword;
  String _regCode = '';

  @override
  void initState() {
    super.initState();
    _mobileNumberController = TextEditingController(text: '');
    _otpController = TextEditingController(text: '');
    _newPasswordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation mQOrientation = MediaQuery.of(context).orientation;
    print('Width: $width');
    print('Height: $height');
    print('Orientation: $mQOrientation');
    // print ('DeviceID: $_deviceID');
    return Scaffold(
      key: _pageKey,
      body: Form(
        key: _formPageKey,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return mQOrientation == Orientation.portrait
                ? _buildVerticalLayout(context, width, height)
                : _buildHorizontalLayout(context, width, height);
          },
        ),
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext ctx, double w, double h) =>
      SingleChildScrollView(
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
                            ? 'Verify Mobile Number'
                            : 'Forgot Password',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      _isMobileNumberVerified
                          ? _verifyNewPasswordField()
                          : _isRegCodeSent
                              ? _verifyMobileNumberField()
                              : _mobileNumberField(),
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
                                  _isMobileNumberVerified
                                      ? 'Change Password'
                                      : _isRegCodeSent
                                          ? 'Verify'
                                          : 'Submit',
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
                                    // _isMobileNumberVerified
                                    //     ? _changePassword() : _isRegCodeSent
                                    //     ? _verifyMobileNumber() : _getRegCode();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _formPageKey.currentState.save();
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              forgotPasswordFooter(context),
            ],
          ),
        ),
      );

  Widget _buildHorizontalLayout(BuildContext ctx, double w, double h) =>
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
                    forgotPasswordFooter(context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isRegCodeSent ? 'Verify Account' : 'Forgot Password',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    _isMobileNumberVerified
                        ? _verifyNewPasswordField()
                        : _isRegCodeSent
                            ? _verifyMobileNumberField()
                            : _mobileNumberField(),
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
                                _isMobileNumberVerified
                                    ? 'Change Password'
                                    : _isRegCodeSent
                                        ? 'Verify'
                                        : 'Submit',
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
                                  // _isMobileNumberVerified
                                  //   ? _changePassword() : _isRegCodeSent
                                  //   ? _verifyMobileNumber() : _getRegCode();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _formPageKey.currentState.save();
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
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

  Widget _mobileNumberField() => Container(
        margin: EdgeInsets.symmetric(horizontal: 64.0),
        child: TextFormField(
          key: Key('mobileNumber'),
          validator: (value) => value.isEmpty
              ? 'Please enter Mobile Number'
              : value.length < 11
                  ? 'Mobile Number must not be less than 11 digits'
                  : !(value.length == 11 && value.startsWith('09'))
                      ? 'Mobile Number is invalid PH mobile number'
                      : null,
          controller: _mobileNumberController,
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
              fontSize: 0.0,
            ),
          ),
          keyboardType: TextInputType.phone,
          maxLength: 11,
          onSaved: (String val) {
            _mobileNumber = val;
            _getRegCode();
          },
        ),
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

  Widget _passwordField(bool isNew) => TextFormField(
        key: Key(isNew ? 'newPassword' : 'confirmPassword'),
        validator: (value) => _validatePassword(isNew, value),
        controller: isNew ? _newPasswordController : _confirmPasswordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
          hintText:
              isNew ? 'Input new Password here' : 'Confirm new Password here',
          hintStyle: TextStyle(
            color: Colors.white38,
          ),
          labelText: isNew ? 'New Password' : 'Confirm Password',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          // errorText: isNew ? _validateNewPassword ? _newPasswordErrorMsg : null
          //     : _validateConfirmPassword ? _confirmPasswordErrorMsg : null,
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
          _newPassword = val;
          _changePassword();
        },
      );

  Widget _verifyNewPasswordField() => Container(
        margin: EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            _passwordField(true),
            SizedBox(
              height: 16.0,
            ),
            _passwordField(false),
          ],
        ),
      );

  String _validatePassword(bool isNew, String val) {
    if (val.isEmpty) {
      if (isNew) {
        return 'Please enter new Password';
      } else {
        return 'Please confirm new Password';
      }
    } else {
      if (isNew) {
        if (val.length < 8) {
          return 'Password must not be less than 8 characters';
        } else {
          return null;
        }
      } else {
        if (val.length < 8) {
          return 'Password must not be less than 8 characters';
        } else if (val != _newPasswordController.text) {
          return 'Passwords do not match';
        } else {
          return null;
        }
      }
    }
  }

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
          .showSnackBar(SnackBar(content: Text('Failed to Reset Password')));
    }
  }

  void _verifyMobileNumber() {
    print('verifyMobileNumber');
    try {
      print('try');
      // setState(() => _isLoading = true);
      // if (_verifyMobileNumberController.text == _regCode) {
      setState(() {
        _isLoading = false;
        _isRegCodeSent = false;
        _isMobileNumberVerified = true;
      });
      // } else {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
    } catch (e) {
      print('catch');
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Reset Password')));
    }
  }

  void _changePassword() {
    try {
      // TODO: Login
      _changePasswordAPI().then((value) {
        setState(() {
          _isLoading = false;
          if (value) {
            print('success');
            _pageKey.currentState.showSnackBar(
                SnackBar(content: Text('Password Changed successfully')));
            NavigationHelper.login(context);
          } else {
            print('failed');
          }
        });
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showError(context, e.message);
      _pageKey.currentState
          .showSnackBar(SnackBar(content: Text('Failed to Reset Password')));
    }
  }

  Future<bool> _changePasswordAPI() async {
    var url = Uri.parse('https://ccc.guardian4emergency.com/mobile/userUpdate');
    var response = await http.post(
      url,
      body: {
        'mobile': _mobileNumber,
        'password': _newPassword,
      },
    );
    final body = jsonDecode(response.body);
    return body["success"];
  }
}
