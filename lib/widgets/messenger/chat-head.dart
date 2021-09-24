import 'package:flutter/material.dart';

import '../../utils/constants/utils.dart';


class ChatHead extends StatelessWidget {

  final String url;
  final String fName;
  final String lName;

  ChatHead({this.url, this.fName, this.lName});

  @override
  Widget build(BuildContext context) {
    return (fName != null && fName.isNotEmpty) ?
    Column(
      children: [
        CircleAvatar(
          radius: 36.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/$url'),
          backgroundImage: AssetImage('assets/images/guardian.png'),
        ),
        vSpacer(4.0),
        Text(
          fName ?? '',
          style: TextStyle(
            fontSize: 16.0,
            color: colorPrimary,
          ),
        ),
        Text(
          lName ?? '',
          style: TextStyle(
            fontSize: 16.0,
            color: colorPrimary,
          ),
        ),
      ],
    ) :
    CircleAvatar(
      radius: 36.0,
      foregroundImage: NetworkImage(url),
      backgroundImage: AssetImage('assets/images/guardian.png'),
    );
  }

}
