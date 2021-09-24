import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/loading.dart';
import '../../services/web-service.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {
  TextEditingController _usernameController, _passwordController;

  final _formPageKey = GlobalKey<FormState>();

  bool _isLoading = false, _obscureText = true;

  String _username = '', _password = '', _emailErrorMsg, _pwordErrorMsg;

  /*static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
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
  }*/

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _validateForm() {
    bool flag = true;
    String errorMsg = '';
    if (_username.isEmpty) {
      errorMsg = '- email address is empty.\n';
      _emailErrorMsg = 'error';
      flag = false;
    } else if (!_username.contains('@') || !_username.contains('.') || _username.contains('@.')) {
      errorMsg = '- invalid email address.\n';
      _emailErrorMsg = 'error';
      flag = false;
    } else {
      _emailErrorMsg = null;
    }
    if (_password.isEmpty) {
      _pwordErrorMsg = 'error';
      errorMsg += '- password is empty.';
      flag = false;
    } else if (_password.length < 8) {
      _pwordErrorMsg = 'error';
      errorMsg += '- password must not be less than 8 characters.';
      flag = false;
    } else {
      _pwordErrorMsg = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Sign in failed', errorMsg);
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var size = mq.size;
    var o = mq.orientation;
    var h = size.height;
    var w = size.width;
    return _isLoading ? Loading() : Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: OrientationBuilder(
                builder: (c, or) {
                  return o == Orientation.portrait ?
                      _buildForm(h) : _buildForm(w);
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _labelSignIn => Row (
    // mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      FaIcon(
        FontAwesomeIcons.userAlt,
        size: 16.0,
      ),
      hSpacer(8.0,),
      Text(
        'Sign into your Account',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ],
  );

  Widget get _userNameField => TextFormField(
    controller: _usernameController,
    decoration: editInputDecoration2.copyWith(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      hintText: 'Email Address',
      errorStyle: TextStyle(
        fontSize: 0.0,
      ),
      errorText: _emailErrorMsg,
    ),
    keyboardType: TextInputType.emailAddress,
    maxLines: 1,
    minLines: 1,
    onChanged: (val) => _username = val,
  );

  Widget get _pwordField => TextFormField(
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
      errorText: _pwordErrorMsg,
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
    onChanged: (val) => _password = val,
  );

  Widget get _loginBtn => TextButton(
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
      // WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (_validateForm()) {
        setState(() => _isLoading = true);
        checkInternetConnection().then((value) {
          if (value) {
            _login();
          } else {
            setState(() => _isLoading = false);
            showMessageDialog(context, 'Sign in failed', '- please check your internet connection.');
          }
        });
        // _mockCheckForSession().then((value) {
        //   setState(() => _isLoading = false);
        //   NavigationHelper.navigateToHome(context);
        // });
        // }
      }
    },
    child: Text(
      'Sign in',
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
      hSpacer(4.0,),
      GestureDetector(
        onTap: () {
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

  Widget get _footerForgotPass => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Forgot password?',
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      hSpacer(4.0,),
      GestureDetector(
        onTap: () {
          NavigationHelper.forgotPassword(context);
        },
        child: Text(
          'Forgot',
          style: TextStyle(
            fontSize: 20.0,
            color: colorPrimary1,
          ),
        ),
      ),
    ],
  );

  Widget _buildForm(double w) => Container(
    width: w / 2,
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
            'Sign In',
            style: TextStyle(
              fontSize: 36.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        vSpacer(16.0,),
        _labelSignIn,
        vSpacer(16.0,),
        _userNameField,
        vSpacer(4.0,),
        _pwordField,
        vSpacer(8.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _loginBtn,
        ),
        vSpacer(16.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _footerSignUp,
        ),
        vSpacer(12.0,),
        Align(
          alignment: Alignment.centerLeft,
          child: _footerForgotPass,
        ),
      ],
    ),
  );

  /*Widget _buildVerticalLayout(double w, double h) => SingleChildScrollView(
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
      );*/

  void _login() {
    try {
      _loginApi().then((value) {
        if (value.contains('Error')) {
          setState(() => _isLoading = false);
          showMessageDialog(context, 'Sign in failed', '- server error.');
        } else {
          var result = jsonDecode(value);
          String token = result['token'];
          if (token != null) {
            final _snackBar = SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              content: Text(
                'Login successful',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            );
            // Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            _fetchVMApi(token).then((v) {
              UserViewModel vm = v;
              _fetchUserProfileVMApi(token).then((val) {
                UserProfileViewModel userVM;
                try {
                  if ((val as String).contains('no profile')) {
                    userVM = null;
                  } else {
                    userVM = UserProfileViewModel(userDetails: val);
                  }
                } catch(e) {
                  userVM = UserProfileViewModel(userDetails: val);
                }
                fetchUsers().then((value) {
                  List<UserProfileViewModel> userList = value;
                  NavigationHelper.navigateToHome(
                      context, token, vm, userVM, userList);
                });
              });
            });
          }
          else {
            setState(() => _isLoading = false);
            print('result: $result');
            if (result.toString().toLowerCase().contains(
                'invalid credential')) {
              showMessageDialog(
                  context, 'Sign in failed', '- invalid credentials.');
            }
          }
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // showError(context, e.message);
    }
  }

  Future<String> _loginApi() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/auth');
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
      body: reqBody,
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      showMessageDialog(context, 'Sign in failed',
          '- can\'t connect to server.');
      return error;
    });
    print('loginRes: $response X ${response.body}');
    return response.body;
  }

  Future<UserViewModel> _fetchVMApi(String token) async {
    var result = await Webservice().fetchUserDetails(token);
    print('User = $result x ${result.name}');
    return UserViewModel(user: result);
  }

  Future<Object> _fetchUserProfileVMApi(String token) async {
    var result = await Webservice().fetchUserProfile(token);
    print('UserProfile = $result');
    return result;
  }

  Future<List<UserProfileViewModel>> fetchUsersApi() async {
    var result = await Webservice().fetchUsers();
    var userList = result.map((item) => UserProfileViewModel(userDetails: item)).toList();
    return userList;
  }
}
