import 'package:flutter/material.dart';

import '../../navigation/main-nav/login.dart';
import '../../navigation/main-nav/signup.dart';
import '../../navigation/main-nav/forgot-password.dart';

class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();

}

class _AuthenticateState extends State<Authenticate> {
  String _formDisplay = "sign-in";

  _toggleView(String fDisplay) => setState(() => _formDisplay = fDisplay);

  @override
  Widget build(BuildContext context) {
    switch(_formDisplay) {
      case 'sign-up': {
        return SignUp();
      }
      // break;
      case 'forgot-password': {
        return ForgotPassword();
      }
      // break;
      default: {
        return Login();
      }
      // break;
    };
  }

}
