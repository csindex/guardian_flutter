import '../../navigation/main-nav/guardian-home.dart';
import '../../navigation/main-nav/login.dart';
import '../../navigation/main-nav/signup.dart';
import '../../navigation/main-nav/verify-otp.dart';
import '../../reporting/report-call-screen.dart';
import 'package:flutter/material.dart';

class NavigationHelper {

  static createAccount(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => SignUp()));

  static login(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => Login()));

  static verifyOtp(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => VerifyOtp()));

  static navigateToHome(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => GuardianHome()));



  static navigateToCall(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => ReportCallScreen()));

}