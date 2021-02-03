import 'package:flutter/material.dart';

import '../../navigation/main-nav/guardian-home.dart';
import '../../navigation/main-nav/login.dart';
import '../../navigation/main-nav/forgot-password.dart';
import '../../navigation/main-nav/signup.dart';
import '../../navigation/main-nav/verify-otp.dart';
import '../../reporting/report-call-screen.dart';
import '../../navigation/main-nav/screen-profile.dart';
import '../../widgets/posts/post-image-full.dart';
import '../../widgets/profile/profile-picture-full.dart';
import '../../widgets/profile/qr-code-full.dart';
import '../../widgets/profile/edit-profile-picture/camera/camera-screen.dart';
import '../../widgets/profile/edit-profile-picture/gallery/gallery-screen.dart';
import '../../screens/profile/profile.dart';

class NavigationHelper {
  static createAccount(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => SignUp()));

  static login(context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));

  static forgotPassword(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ForgotPassword()));

  static verifyOtp(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => VerifyOtp()));

  static navigateToHome(context, token) =>
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => GuardianHome(token: token)));

  static navigateToCall(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => ReportCallScreen()));

  static openImageFull(context, url) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => PostImageFull(imageUrl: url)));

  static openProfileScreen(context, vm, userVM, token, editProfilePicture) =>
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              vm: vm,
              userProfileVM: userVM,
              token: token,
              editProfilePicture: editProfilePicture,
            ),
          ));

  static openProfileScreen2(context, vm, userVM, token) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          vm: vm,
          userProfileVM: userVM,
          token: token,
        ),
      ));

  static openProfPicFull(context, url) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePictureFull(imageUrl: url)));

  static openQRFull(context, userId) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => QrCodeFull(userId: userId)));

  static openCameraScreen(context, token) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => CameraScreen(token)));

  static openGalleryScreen(context, token) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => GalleryScreen(token)));
}
