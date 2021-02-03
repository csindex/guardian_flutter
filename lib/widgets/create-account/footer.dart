import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';

Widget _labelLogin(BuildContext ctx) => GestureDetector(
      onTap: () {
        NavigationHelper.login(ctx);
      },
      child: Text(
        'Log-in',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

Widget _labelForgotPassword(BuildContext ctx) => GestureDetector(
      onTap: () {
        NavigationHelper.forgotPassword(ctx);
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );

Widget _labelTermsAndPoliciesMaker(
        BuildContext ctx, String label, String route) =>
    GestureDetector(
      onTap: () {
        launchURL(ctx, '$termsEndPoint$route');
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );

Widget _divider() => Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 14.0,
      width: 1.0,
      color: Colors.white,
    );

Widget _termsAndPolicies(BuildContext ctx) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _labelTermsAndPoliciesMaker(ctx, 'Use Policy', '/legal'),
        _divider(),
        _labelTermsAndPoliciesMaker(ctx, 'Privacy Policy', '/legal'),
        _divider(),
        _labelTermsAndPoliciesMaker(ctx, 'Terms of Use', '/legal'),
      ],
    );

Widget createAccountFooter(BuildContext ctx) => Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _labelLogin(ctx),
          SizedBox(
            height: 16.0,
          ),
          _labelForgotPassword(ctx),
          SizedBox(
            height: 16.0,
          ),
          _termsAndPolicies(ctx),
        ],
      ),
    );
