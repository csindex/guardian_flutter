import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/loading.dart';
import '../../utils/constants/common-methods.dart';

class ForgotPasswordWrapper extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordWrapper> {
  bool _isLoading = false, _obscureText = true;
  String _view = 'email', _email = '', _otp = '', _otpInput = '',
      _newPass = '', _cPass = '', _name = '', _number = '',
      _errEmail, _errOtp, _errPass, _errCPass;
  int _time = 300;
  Timer _timer;

  TextEditingController _emailController, _otpController,
      _passController, _cPassController;

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
    await Future.delayed(Duration(seconds: 3), () {});
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

  bool _validateEmailForm() {
    bool flag = true;
    String errorMsg = '';
    if (_email.isEmpty) {
      errorMsg = '- email address is empty.';
      _errEmail = 'error';
      flag = false;
    } else if (!_email.contains('@') || !_email.contains('.') || _email.contains('@.')) {
      errorMsg = '- invalid email address.';
      _errEmail = 'error';
      flag = false;
    } else {
      _errEmail = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Forgot password failed', errorMsg);
    }
    return flag;
  }

  bool _validateOTPForm() {
    bool flag = true;
    String errorMsg = '';
    if (_otpInput.isEmpty) {
      errorMsg = '- OTP is empty.';
      _errOtp = 'error';
      flag = false;
    } else if (_otpInput.length < 6) {
      errorMsg = '- OTP must be 6 digits.';
      _errOtp = 'error';
      flag = false;
    } else if (_otp != _otpInput) {
      errorMsg = '- invalid OTP.';
      _errOtp = 'error';
      flag = false;
    } else {
      _errOtp = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Forgot password failed', errorMsg);
    }
    return flag;
  }

  bool _validateChangePassForm() {
    bool flag = true;
    String errorMsg = '';
    if (_newPass.isEmpty) {
      errorMsg = '- password is empty.\n';
      _errPass = 'error';
      flag = false;
    } else if (_newPass.length < 8) {
      errorMsg = '- password must be 8 or more characters.\n';
      _errPass = 'error';
      flag = false;
    } else if (_newPass != _cPass) {
      errorMsg = '- passwords do not match.\n';
      _errPass = 'error';
      flag = false;
    }
    if (_cPass.isEmpty) {
      errorMsg += '- confirm password is empty.';
      _errCPass = 'error';
      flag = false;
    } else if (_cPass.length < 8) {
      errorMsg += '- confirm password must be 8 or more characters.';
      _errCPass = 'error';
      flag = false;
    } else {
      _errCPass = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Forgot password failed', errorMsg);
    }
    return flag;
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
    _otpController = TextEditingController(text: '');
    _passController = TextEditingController(text: '');
    _cPassController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    _emailController.dispose();
    _otpController.dispose();
    _passController.dispose();
    _cPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var size = mq.size;
    double h = size.height;
    double w = size.width;
    Orientation o = mq.orientation;
    return _isLoading ?
    Loading() :
    Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return o == Orientation.portrait ?
                  _buildForm(h) : _buildForm(w);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(double w) {
    double newW = w / 2;
    switch (_view) {
      case 'otp': {
        return _buildFormOTP(newW);
      }
      case 'change': {
        return _buildFormChangePass(newW);
      }
      default: {
        return _buildFormEmail(newW);
      }
    }
  }

  Widget _buildFormEmail(double w) => Container(
    width: w,
    margin: EdgeInsets.symmetric(horizontal: 16.0,),
    padding: EdgeInsets.all(16.0,),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 1.0,
        color: Colors.white,
      ),
      color: Colors.white,
    ),
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 36.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        vSpacer(h: 16.0,),
        _labelEnterEmail,
        vSpacer(h: 16.0,),
        _emailAddressField,
        vSpacer(h: 8.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _sendOtpBtn,
        ),
        vSpacer(h: 16.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _footerSignUp,
        ),
      ],
    ),
  );

  Widget get _labelEnterEmail => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: FaIcon(
          FontAwesomeIcons.envelope,
          size: 16.0,
        ),
      ),
      hSpacer(w: 8.0,),
      Flexible(
        child: Text(
          'Enter your email address, for verification.',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );

  Widget get _emailAddressField => TextFormField(
    controller: _emailController,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Email Address',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errEmail,
    ),
    keyboardType: TextInputType.emailAddress,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _email = val,
  );

  Widget get _sendOtpBtn => TextButton(
    style: TextButton.styleFrom(
      primary: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: colorPrimary1,
    ),
    onPressed: () {
      FocusScope.of(context).unfocus();
      if (_validateEmailForm()) {
        setState(() => _isLoading = true);
        _getMobileNumber();
      }
    },
    child: Text(
      'Send OTP',
      style: TextStyle(
        fontSize: 24.0,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Widget get _footerSignUp => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Don\'t have an account?',
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      hSpacer(w: 4.0,),
      GestureDetector(
        onTap: () {
          // Navigator.of(context).pop();
          NavigationHelper.createAccount(context);
        },
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20.0,
            color: colorPrimary1,
          ),
        ),
      ),
    ],
  );

  Widget _buildFormOTP(double w) => Container(
    width: w,
    margin: EdgeInsets.symmetric(horizontal: 16.0,),
    padding: EdgeInsets.all(16.0,),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 1.0,
        color: Colors.white,
      ),
      color: Colors.white,
    ),
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 36.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        vSpacer(h: 16.0,),
        _labelEnterOTP,
        vSpacer(h: 16.0,),
        _otpField,
        vSpacer(h: 8.0,),
        Text(
          'Did you receive an OTP?',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
        vSpacer(h: 4.0,),
        _time == 0 ?
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0,),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            backgroundColor: Colors.grey.shade300,
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            _sendOtp();
          },
          child: Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 16.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ) :
        Text(
          'Resend OTP after $_time seconds',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
        vSpacer(h: 8.0,),
        Text(
          'If you need to change your mobile number, you may do so through Update Profile, or by reaching out to your Operation Center Administrator at admin@guardian.ph',
          style: TextStyle(
            fontSize: 10.0,
          ),
          textAlign: TextAlign.center,
        ),
        vSpacer(h: 8.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _proceedBtn,
        ),
      ],
    ),
  );

  Widget get _labelEnterOTP => Row(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      FaIcon(
        FontAwesomeIcons.key,
        size: 16.0,
      ),
      hSpacer(w: 8.0,),
      Flexible(
        child: Text(
          'You will receive a One-Time Password (OTP) on your registered mobile number.',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );

  Widget get _otpField => TextFormField(
    controller: _otpController,
    textAlign: TextAlign.center,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'XXXXXX',
      hintStyle: TextStyle(
        letterSpacing: 8.0,
      ),
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errOtp,
    ),
    style: TextStyle(
      letterSpacing: 8.0,
    ),
    obscureText: true,
    keyboardType: TextInputType.numberWithOptions(),
    maxLines: 1,
    minLines: 1,
    maxLength: 6,
    onChanged: (val) => _otpInput = val,
  );

  Widget get _proceedBtn => TextButton(
    style: TextButton.styleFrom(
      primary: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: colorPrimary1,
    ),
    onPressed: () {
      FocusScope.of(context).unfocus();
      if (_validateOTPForm()) {
        setState(() => _isLoading = true);
        toggleView('change');
      }
    },
    child: Text(
      'Proceed',
      style: TextStyle(
        fontSize: 24.0,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Widget _buildFormChangePass(double w) => Container(
    width: w,
    margin: EdgeInsets.symmetric(horizontal: 16.0,),
    padding: EdgeInsets.all(16.0,),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 1.0,
        color: Colors.white,
      ),
      color: Colors.white,
    ),
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 36.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        vSpacer(h: 16.0,),
        _labelEnterNewPass,
        vSpacer(h: 16.0,),
        _newPassField,
        vSpacer(h: 8.0,),
        _cPassField,
        vSpacer(h: 8.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _changePassBtn,
        ),
      ],
    ),
  );

  Widget get _labelEnterNewPass => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: FaIcon(
          FontAwesomeIcons.key,
          size: 16.0,
        ),
      ),
      hSpacer(w: 8.0,),
      Flexible(
        child: Text(
          'Enter your new password.',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );

  Widget get _newPassField => TextFormField(
    controller: _passController,
    textAlign: TextAlign.start,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'New Password',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errPass,
      suffixIcon: InkWell(
        onTap: _togglePassword,
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade900,
        ),
      ),
    ),
    obscureText: _obscureText,
    keyboardType: TextInputType.visiblePassword,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _newPass = val,
  );

  Widget get _cPassField => TextFormField(
    controller: _cPassController,
    textAlign: TextAlign.start,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Confirm Password',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errCPass,
      suffixIcon: InkWell(
        onTap: _togglePassword,
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade900,
        ),
      ),
    ),
    obscureText: _obscureText,
    keyboardType: TextInputType.visiblePassword,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _cPass = val,
  );

  Widget get _changePassBtn => TextButton(
    style: TextButton.styleFrom(
      primary: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: colorPrimary1,
    ),
    onPressed: () {
      FocusScope.of(context).unfocus();
      if (_validateChangePassForm()) {
        setState(() => _isLoading = true);
        _changePass();
      }
    },
    child: Text(
      'Change Password',
      style: TextStyle(
        fontSize: 24.0,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  void _getMobileNumber() {
    try {
      _getMobileNumberApi().then((value) {
        // setState(() {
        //   _isLoading = false;
          var result = jsonDecode(value);
          _name = result['name'];
          _number = result['number'];
          if (_name == null || _name.isEmpty) {
            setState(() => _isLoading = false);
            showMessageDialog(context, 'Forgot password failed',
                '- user does not exist');
          } else {
            _sendOtp();
          }
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _sendOtp() {
    try {
      _sendOtpApi().then((value) {
        if (value != 'server error') {
          setState(() {
            _isLoading = false;
            _view = 'otp';
            _otp = value;
            _timer?.cancel();
            _timer = null;
            _time = 300;
            _startTimer();
          });
        } else {
          setState(() {
            _isLoading = false;
            _errEmail = 'error';
          });
          showMessageDialog(context, 'Forgot Password failed', '- cannot connect to GSM server.');
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _changePass() {
    try {
      _changePassApi().then((value) {
        var result = jsonDecode(value);
        String token = result['token'];
        if (token != null) {
          final _snackBar = SnackBar(
            duration: Duration(seconds: 10),
            backgroundColor: colorPrimary1,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            content: Text(
              'Password changed successfully.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        } else {
          setState(() {
            _isLoading = false;
            _errPass = 'error';
            _errCPass = 'error';
          });
          showMessageDialog(context, 'Forgot password failed', '- failed to change password');
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showMessageDialog(context, 'Forgot password failed', '- failed to change password');
    }
  }

  Future<String> _getMobileNumberApi() async {
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

  Future<String> _sendOtpApi() async {
    _otp = '${100000 + Random().nextInt(999999 - 100000)}';
    var url = Uri.parse('$secretHollowsEndPoint/api/sms/sendOtp');
    Map data = {'number': _number, 'msg': 'Hi $_name, Proceed with your Change Password for GUARDIAN Account, Your One-Time PIN is $_otp. OTP will expire 15 minutes. If you did not initiate this request, please call your Operation Center Administrator.'};
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
    print('sendOtp r: $response X ${response.body} X $_otp');
    if (response.body.contains('Server Error')) {
      // showMessageDialog(context, 'Sending OTP failed', '- cannot connect to OTP server.');
      return 'server error';
    }
    return _otp;
  }

  Future<String> _changePassApi() async {
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
