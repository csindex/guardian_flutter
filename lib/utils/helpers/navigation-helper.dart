import 'package:flutter/material.dart';

import '../../navigation/main-nav/guardian-home.dart';
import '../../navigation/main-nav/login.dart';
import '../../navigation/main-nav/forgot-password.dart';
import '../../navigation/main-nav/signup.dart';
import '../../navigation/main-nav/verify-otp.dart';
import '../../reporting/report-call-screen.dart';
import '../../navigation/main-nav/screen-profile.dart';
import '../../screens/responders/responders.dart';
import '../../screens/posts/post-image-full.dart';
import '../../screens/forgot-password/forgot-password-wrapper.dart';
import '../../widgets/profile/profile-picture-full.dart';
import '../../widgets/profile/qr-code-full.dart';
import '../../widgets/profile/edit-profile-picture/camera/camera-screen.dart';
import '../../widgets/profile/edit-profile-picture/gallery/gallery-screen.dart';
import '../../screens/profile/profile.dart';
import '../../screens/profile/select-address.dart';

class NavigationHelper {
  static createAccount(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUp()),
      );

  static login(context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));

  // static forgotPassword(context) => Navigator.push(
  //   context, MaterialPageRoute(builder: (context) => ForgotPassword()),
  // );

  static forgotPassword(context) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => ForgotPasswordWrapper()),
  );

  static verifyOtp(context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => VerifyOtp()));

  static navigateToHome(context, token) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GuardianHome(token: token)));

  static navigateToCall(context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ReportCallScreen()));

  static openImageFull(context, url) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostImageFull(imageUrl: url)),
      );

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
        ),
      );

  static openRespondersScreen(
      context, token, userVM, vm, origin, responderList) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          Responders(
            vm: vm,
            userVM: userVM,
            token: token,
            origin: origin,
            responderList: responderList,
          ))
      );

  static openProfileScreen2(
      context, vm, userVM, userOriginalVM, token, origin) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            vm: vm,
            userProfileVM: userVM,
            token: token,
            origin: origin,
            userOriginalVM: userOriginalVM,
          ),
        ),
      );

  static openProfPicFull(context, url) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePictureFull(imageUrl: url)),
      );

  static openQRFull(context, userId) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QrCodeFull(userId: userId)),
      );

  static openCameraScreen(context, token, vm) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen(token: token, vm: vm)),
      );

  static openGalleryScreen(context, token, vm) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryScreen(token: token, vm: vm)),
      );

  static openSelectAddress(context, onAddressSelected, initialLL) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          SelectAddress(
            onAddressSelected: onAddressSelected,
            initialLL: initialLL,
          )),
      );
}
