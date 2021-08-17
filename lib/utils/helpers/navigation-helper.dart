import 'package:flutter/material.dart';

import '../../navigation/main-nav/guardian-home.dart';
import '../../navigation/main-nav/login.dart';
import '../../navigation/main-nav/signup.dart';
import '../../navigation/main-nav/verify-otp.dart';
import '../../reporting/report-call-screen.dart';
import '../../navigation/main-nav/screen-profile.dart';
import '../../screens/responders/responders.dart';
import '../../screens/posts/post-image-full.dart';
import '../../screens/authenticate/forgot-password-wrapper.dart';
import '../../widgets/profile/profile-picture-full.dart';
import '../../widgets/profile/qr-code-full.dart';
import '../../widgets/profile/edit-profile-picture/camera/camera-screen.dart';
import '../../widgets/profile/edit-profile-picture/gallery/gallery-screen.dart';
import '../../screens/profile/profile-main.dart';
import '../../screens/profile/add-training.dart';
import '../../screens/profile/add-education.dart';
import '../../screens/profile/edit-profile.dart';
import '../../screens/profile/select-address.dart';
import '../../screens/posts/camera/camera-screen.dart' as cPost;
import '../../screens/posts/gallery/gallery-screen.dart' as gPost;
import '../../screens/posts/comments/comments.dart';
import '../../screens/profile/camera/camera-screen.dart' as cProfile;
import '../../screens/authenticate/signup.dart' as nSignUp;
import '../../screens/authenticate/login.dart' as nLogin;

class NavigationHelper {
  static createAccount(context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => nSignUp.SignUp(),
        ),
      );

  static login(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => nLogin.Login(),
        ),
      );

  // static forgotPassword(context) => Navigator.push(
  //   context, MaterialPageRoute(builder: (context) => ForgotPassword()),
  // );

  static forgotPassword(context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordWrapper(),
        ),
      );

  static verifyOtp(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VerifyOtp(),
        ),
      );

  static navigateToHome(context, token, vm, userVM, userList) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GuardianHome(
            token: token,
            vm: vm,
            userProfileVM: userVM,
            userList: userList,
          ),
        ),
      );

  static navigateToCall(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReportCallScreen(),
        ),
      );

  static openImageFull(context, url) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostImageFull(
            imageUrl: url,
          ),
        ),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Responders(
            vm: vm,
            userVM: userVM,
            token: token,
            origin: origin,
            responderList: responderList,
          ),
        ),
      );

  static openProfileScreen2(
          context, vm, userVM, userOriginalVM, token, origin) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileMain(
            vm: vm,
            userVM: userVM,
            token: token,
            origin: origin,
            userOVM: userOriginalVM,
          ),
        ),
      );

  static openProfPicFull(context, url) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePictureFull(
            imageUrl: url,
          ),
        ),
      );

  static openQRFull(context, userId) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeFull(
            userId: userId,
          ),
        ),
      );

  static openCameraScreen(context, token, vm) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(token: token, userProfileVM: vm),
        ),
      );

  static openGalleryScreen(context, token, vm) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryScreen(token: token, userProfileVM: vm),
        ),
      );

  static openSelectAddress(context, onAddressSelected, initialLL) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectAddress(
            onAddressSelected: onAddressSelected,
            initialLL: initialLL,
          ),
        ),
      );

  static openCameraPost(context, token, f) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => cPost.CameraScreen(
            token: token,
            handleImage: f,
          ),
        ),
      );

  static openGalleryPost(context, token) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gPost.GalleryScreen(
            token: token,
          ),
        ),
      );

  static openComments(context, token, vm, userVM, userList, post, r) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Comments(
            token: token,
            vm: vm,
            userVM: userVM,
            userList: userList,
            post: post,
            refresh: r,
          ),
        ),
      );

  static openAddTraining(context, token, r) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTraining(
            token: token,
            refresh: r,
          ),
        ),
      );

  static openAddEducation(context, token, r)
  => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddEducation(
        token: token,
        refresh: r,
      ),
    ),
  );

  static openEditProfile(context, token, r, isUpdate, userVM,)
  => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfile(
        token: token,
        userVM: userVM,
        refresh: r,
        isUpdate: isUpdate,
      ),
    ),
  );

  static openCameraProfile(context, token, f) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => cProfile.CameraScreen(
        token: token,
        handleImage: f,
      ),
    ),
  );
}
