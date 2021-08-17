import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';

/*GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);*/

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _firstNameController, _lastNameController,
      _mobileController, _emailController, _passwordController,
      _cpwordController, _otpController;

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _obscureText = true;

  int _time = 300;
  Timer _timer;

  String _firstName = '', _lastName = '', _email = '', _mobile = '',
      _pword = '', _cpword = '', _otpInput = '', _otp = '',
      _errFirstName, _errLastName, _errEmail, _errMobile, _errPWord,
      _errCPWord, _errOtp, _view = 'signup';

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

  _toggleView(String v) {
    _mockCheckForSession().then((_) {
      setState(() {
        _isLoading = false;
        _view = v;
      });
    });
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(seconds: 3), () {});
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _validateSignUpForm() {
    bool flag = true;
    String errorMsg = '';
    if (_firstName.isEmpty) {
      errorMsg += '- first name is empty.\n';
      _errFirstName = 'error';
      flag = false;
    }
    if (_lastName.isEmpty) {
      errorMsg += '- last name is empty.\n';
      _errLastName = 'error';
      flag = false;
    }
    if (_mobile.isEmpty) {
      errorMsg += '- mobile number is empty.\n';
      _errMobile = 'error';
      flag = false;
    } else if (!_mobile.startsWith('09') || _mobile.length < 11) {
      errorMsg += '- mobile number is invalid.\n';
      _errMobile = 'error';
      flag = false;
    } else {
      _errMobile = null;
    }
    if (_email.isEmpty) {
      errorMsg += '- email address is empty.\n';
      _errEmail = 'error';
      flag = false;
    } else if (!_email.contains('@') || !_email.contains('.') || _email.contains('@.')) {
      errorMsg += '- email address is invalid.\n';
      _errEmail = 'error';
      flag = false;
    } else {
      _errEmail = null;
    }
    if (_pword.isEmpty) {
      _errPWord = 'error';
      errorMsg += '- password is empty.\n';
      flag = false;
    } else if (_pword.length < 8) {
      _errPWord = 'error';
      errorMsg += '- password must not be less than 8 characters.\n';
      flag = false;
    } else if (_pword != _cpword) {
      errorMsg += '- passwords do not match.\n';
      _errPWord = 'error';
      flag = false;
    } else {
      _errPWord = null;
    }
    if (_cpword.isEmpty) {
      errorMsg += '- confirm password is empty.';
      _errCPWord = 'error';
      flag = false;
    } else if (_cpword.length < 8) {
      errorMsg += '- confirm password must not be less than 8 characters.';
      _errCPWord = 'error';
      flag = false;
    } else {
      _errCPWord = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Sign up failed', errorMsg);
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

  @override
  void initState() {
    super.initState();
    /*_initPlatformState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact();
      // }
    });
    _googleSignIn.signInSilently();*/
    _firstNameController = TextEditingController(text: '');
    _lastNameController = TextEditingController(text: '');
    _mobileController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _cpwordController = TextEditingController(text: '');
    _otpController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpwordController.dispose();
    _otpController.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
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

  /*Future<void> _handleSignIn() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var size = mq.size;
    double h = size.height;
    double w = size.width;
    Orientation o = mq.orientation;
    return _isLoading ? Loading() : Scaffold(
      key: _pageKey,
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  /*return mQOrientation == Orientation.portrait
                      ? height >= 900
                          ? _buildVerticalLayout(width, height)
                          : _buildVerticalLayout900(width, height)
                      : _buildHorizontalLayout(width, height);*/
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
    if (_view == 'otp') {
      return _buildFormOTP(newW);
    } else {
      return _buildFormSignUp(newW);
    }
  }

  Widget _buildFormSignUp(double w) => Container(
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
            'Sign Up',
            style: TextStyle(
              fontSize: 36.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        vSpacer(h: 16.0,),
        _labelSignUp,
        vSpacer(h: 16.0,),
        _firstNameField,
        vSpacer(h: 4.0,),
        _lastNameField,
        vSpacer(h: 4.0,),
        _mobileNumberField,
        vSpacer(h: 4.0,),
        Text(
          'This site uses your mobile number for authentication, sending alerts and other communication.',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        vSpacer(h: 4.0,),
        _emailAddressField,
        vSpacer(h: 4.0,),
        _passwordField,
        vSpacer(h: 4.0,),
        _cpwordField,
        vSpacer(h: 8.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _registerBtn,
        ),
        vSpacer(h: 16.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _footerSignIn,
        ),
      ],
    ),
  );

  Widget get _labelSignUp => Row(
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      FaIcon(
        FontAwesomeIcons.userAlt,
        size: 16.0,
      ),
      hSpacer(w: 8.0,),
      Text(
        'Create your Account',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ],
  );

  Widget get _firstNameField => TextFormField(
    controller: _firstNameController,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'First Name',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errFirstName,
    ),
    keyboardType: TextInputType.name,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _firstName = val,
  );

  Widget get _lastNameField => TextFormField(
    controller: _lastNameController,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Last Name',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errLastName,
    ),
    keyboardType: TextInputType.name,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _lastName = val,
  );

  Widget get _mobileNumberField => TextFormField(
    controller: _mobileController,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: '09XX XXX XXXX',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errMobile,
    ),
    keyboardType: TextInputType.phone,
    maxLines: 1,
    minLines: 1,
    maxLength: 11,
    onChanged: (val) => _mobile = val,
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

  Widget get _passwordField => TextFormField(
    controller: _passwordController,
    obscureText: _obscureText,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Password',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errPWord,
      suffixIcon: InkWell(
        onTap: _togglePassword,
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade900,
        ),
      ),
    ),
    keyboardType: TextInputType.visiblePassword,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _pword = val,
  );

  Widget get _cpwordField => TextFormField(
    controller: _cpwordController,
    obscureText: _obscureText,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Confirm Password',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _errCPWord,
      suffixIcon: InkWell(
        onTap: _togglePassword,
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade900,
        ),
      ),
    ),
    keyboardType: TextInputType.visiblePassword,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _cpword = val,
  );

  Widget get _registerBtn => TextButton(
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
      if (_validateSignUpForm()) {
        setState(() {
          _isLoading = true;
          _otpController.clear();
        });
        _sendOtp();
      }
    },
    child: Text(
      'Sign up',
      style: TextStyle(
        fontSize: 24.0,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Widget get _footerSignIn => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Already have an account?',
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      hSpacer(w: 4.0,),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          NavigationHelper.login(context);
        },
        child: Text(
          'Sign In',
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
        _createAccount();
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

  void _sendOtp() {
    try {
      _sendOtpApi().then((value) {
        // if (value != 'server error') {
          setState(() {
            _isLoading = false;
            _view = 'otp';
            // _otp = value;
            _timer?.cancel();
            _timer = null;
            _time = 300;
            _startTimer();
          });
        /*} else {
          setState(() {
            _isLoading = false;
          });
          showMessageDialog(context, 'Sign up failed', '- cannot connect to GSM server.');
        }*/
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<String> _sendOtpApi() async {
    _otp = '${100000 + Random().nextInt(999999 - 100000)}';
    var url = Uri.parse('$secretHollowsEndPoint/api/sms/sendOtp');
    Map data = {
      'number': _mobile,
      'msg': 'Hi $_firstName, Proceed with your Registration for GUARDIAN Account, Your One-Time PIN is $_otp. OTP will expire 15 minutes. If you did not initiate this request, please call your Operation Center Administrator.',
      'name': '$_firstName $_lastName',
      'user': 'register',
      'otp': _otp,};
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
      showMessageDialog(context, 'Sending OTP failed', '- cannot connect to OTP server.');
      return 'server error';
    }
    return _otp;
  }

  void _createAccount() {
    try {
      _createAccountApi().then((value) {
        if (value.contains('error')) {
          if (value.contains('exist')) {
            _toggleView('signup');
            final _snackBar = SnackBar(
              duration: Duration(seconds: 7),
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              content: Text(
                'User already exists',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            );
            // Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          }
        } else {
          final _snackBar = SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            content: Text(
              'Sign up successful',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        }
      });
    } catch (e) {
      print('regErr - $e');
    }
  }

  Future<String> _createAccountApi() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/users');
    Map data = {
      'name': _firstName,
      'lname': _lastName,
      'email': _email,
      'number': _mobile,
      'password': _pword
    };
    var reqBody = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: reqBody,
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      showMessageDialog(context, 'Sign up failed',
          '- can\'t connect to server.');
      return error;
    });
    print('regRes: $response X ${response.body}');
    return response.body;
  }

  /*Widget _buildVerticalLayout(double w, double h) => SingleChildScrollView(
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
                                *//* else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }*//*
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
    var url = Uri.parse('https://ccc.guardian4emergency.com/mobile/register');
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
    var url = Uri.parse('https://secret-hollows-28950.herokuapp.com/api/users');
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
  }*/
}

/*class Error {
  String errorMsg;

  Error(this.errorMsg);

  factory Error.fromJson(dynamic json) => Error(json['msg'] as String);

// @override
// String toString() =>

}*/
