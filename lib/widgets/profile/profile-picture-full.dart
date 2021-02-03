import 'package:flutter/material.dart';

import '../../utils/constants/utils.dart';

class ProfilePictureFull extends StatelessWidget {
  final String imageUrl;

  ProfilePictureFull({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: colorPrimary,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
