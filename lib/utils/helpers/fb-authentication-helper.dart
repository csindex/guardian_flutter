import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class FBAuthenticationHelper {
  /*final fbLogin = FacebookLogin();

  Future<void> signInFB() async {
    final FacebookLoginResult result =
        await fbLogin.logIn(['email', 'public_profile']);
    print('FBResult: $result');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = result.accessToken.token;
        final response = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?'
            'fields=name,first_name,last_name,email&access_token=$token'));
        final profile = jsonDecode(response.body);
        print(profile);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Cancel');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }*/
}
